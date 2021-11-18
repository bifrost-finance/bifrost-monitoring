CREATE OR REPLACE view unconfirmed_contributions as
(
    select * from salp_contributions t where t.message_id in (
           select message_id from
           (
                SELECT message_id, count(*) as cnt
                FROM salp_contributions t1 where t1.method != 'Issued'
                group by message_id) t2
                where t2.cnt = 1
           )
    and t.block_timestamp < NOW() - INTERVAL '1 HOURS'
);

CREATE OR REPLACE VIEW top_contributors as
(
    select * from
    (
        select para_id,account,contributed,row_number() over (partition by para_id order by contributed desc) as contribution_rank from
        (
            SELECT sum(balance) as contributed,para_id,account FROM salp_contributions
            GROUP BY para_id,account
            ORDER BY contributed desc
        ) contributions
    ) ranks where contribution_rank<=1
);

create or replace view ksm_fund_contributed as
(
    select *
    from salp_contributions t where t.method = 'Contributed'
);

create or replace view ksm_success_fund_contributed as
(
    select *
    from ksm_fund_contributed t where
    exists(select * from salp_infos i where i.para_id = t.para_id and i.method = 'Success')
);

create or replace view ksm_failed_fund_contributed as
(
    select *
    from ksm_fund_contributed t where
    exists(select * from salp_infos i where i.para_id = t.para_id and i.method = 'Failed')
);

create or replace view ksm_fund_refunded as
(
    select *
    from salp_contributions t where t.method = 'Refunded' or t.method = 'Redeemed'
);

create or replace view ksm_success_fund_refunded as
(
    select *
    from ksm_fund_refunded t where
    exists(select * from salp_infos i where i.para_id = t.para_id and i.method = 'Success')
);

create or replace view ksm_failed_fund_refunded as
(
    select *
    from ksm_fund_refunded t where
    exists(select * from salp_infos i where i.para_id = t.para_id and i.method = 'Failed')
);

create or replace view dot_fund_contributed as
(
    select *
    from salp_contributions t where t.method = 'Issued'
);

create or replace view dot_success_fund_contributed as
(
    select *
    from dot_fund_contributed t where
    exists(select * from salp_infos i where i.para_id = t.para_id and i.method = 'Success')
);

create or replace view dot_failed_fund_contributed as
(
    select *
    from dot_fund_contributed t where
    exists(select * from salp_infos i where i.para_id = t.para_id and i.method = 'Failed')
);

create or replace view large_fund_operation as
(
    select *
    from salp_contributions t where t.balance/1000000000000 >= 5000
);

