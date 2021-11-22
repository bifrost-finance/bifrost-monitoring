import { SubstrateBlock, SubstrateEvent } from '@subql/types';
import { FarmingPoolChange } from '../types';
import { BlockNumber, Balance } from "@polkadot/types/interfaces";
import { u32 } from "@polkadot/types/primitive";
import { Compact } from '@polkadot/types';

const farmingPoolType = (secion: string): string => {
    return secion === 'liquidityMining' ? 'ksm' : 'dot';
}

const decideSign = (method: string): bigint => {
    return method === 'UserDeposited' ? BigInt(1) : BigInt(-1);
}

export async function handleFarmingPoolChange(
    block: SubstrateBlock
): Promise<void> {
    const blockNumber = (block.block.header.number as Compact<BlockNumber>).toNumber();
    const farmingEvts = block.events.filter(
        e => (e.event.section === 'liquidityMining' || e.event.section === 'liquidityMiningDot')
    ) as SubstrateEvent[];

    for (const fevt of farmingEvts) {
        const { event: { data, section, method } } = fevt;

        logger.info(`${blockNumber}: ${section}-${method}`);

        if (method !== 'UserDeposited' && method !== 'UserRedeemed') continue;

        const {
            event: {
                data: [poolId, poolType, tokenPair, amount, account],
            },
        } = fevt;

        if (poolType.toString() !== 'Farming') continue;

        const record = new FarmingPoolChange(`${blockNumber}-${fevt.idx}`);
        record.event_id = fevt.idx;
        record.extrinsic_id = fevt.extrinsic.idx;
        record.block_height = blockNumber;
        record.block_timestamp = block.timestamp;
        record.pool_id = (poolId as u32).toNumber();
        record.farming_pool_type = farmingPoolType(section);
        record.change = decideSign(method) * (amount as Balance).toBigInt();
        record.account = account.toString();

        await record.save();
    }
}