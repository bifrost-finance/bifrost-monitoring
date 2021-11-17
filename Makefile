.PHONY: submodule
submodule:
	git submodule update --init --recursive

.PHONY: update-bifrost-subql
update-bifrost-subql:
	cd bifrost-subql && git checkout master && git pull

.PHONY: build
build:
	cd bifrost-subql && rm -rf dist && yarn && yarn codegen && yarn build

.PHONY: run
run:
	docker-compose -f docker-compose.yml -f bifrost-subql/docker-compose-monitor.yml up -d

.PHONY: init-monitor-sql
init-monitor-sql:
	sh ./postgresql/init.sh

.PHONY: sleep
sleep:
	sleep 10s

.PHONY: init
init:
	make run && make sleep && make init-monitor-sql

.PHONY: stop
stop:
	docker-compose -f docker-compose.yml -f bifrost-subql/docker-compose-monitor.yml down

.PHONY: run-full
run-full:
	docker-compose -f docker-compose.yml -f docker-compose-elasticsearch-pgsync.yml -f bifrost-subql/docker-compose-monitor.yml up -d

.PHONY: start-full
start-full:
	make run-full && make sleep && make init-monitor-sql
