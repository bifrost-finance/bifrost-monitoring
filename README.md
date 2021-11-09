# Architecture

![](https://i.imgur.com/Rnf3jUh.png)


- 基础设施包括平行链节点，容器，中心化数据库通过对应的exporter走prometheus统一接入,再由AlertManager将告警接入slack通知，这种数据可视化主要运维使用，定制化要求不高，有些开源的grafana dashboard模板可以直接拿过来用

- 业务数据分析可以定义一些数据库层面的视图函数，引入了一个postgraphile组件可以基于数据库自动生成graphql查询接口供前端使用

- 业务统计数据的趋势分析，可以定期存储下来做成时序数据存储到相应的历史数据表，也可以通过postgresql-exporter组件expose到prometheus

- 引入了一个pgsync组件实时同步pg数据到es

- 时序业务数据可以直接在grafana上做数据可视化，通过iframe嵌入App。定制化要求高数据面板视图前端走es和graphql接口自行构建

- Since there are many components(Subql app, Postgresql, Elasticsearch, Grafana, Pgsync, Postgraphile and Prometheus, ...) in this stack we may use [docker-compose](https://github.com/bifrost-finance/bifrost-subql/blob/pgsync/docker-compose.yml) to deploy and move to some container orchestration tool like k8s for future


- [some predefined dashboards](https://github.com/bifrost-finance/bifrost-subql/blob/pgsync/grafana/provisioning/dashboards/salp.json) will be automatic provisioned in Grafana accessed and viewed via the Grafana UI

![](https://i.imgur.com/UeG4z8n.png)

![](https://i.imgur.com/5ZM3kh4.png)

![](https://i.imgur.com/JodQUwT.jpg)


- pgsync

we need to define rules to mapping data in postgresql to elasticsearch
https://github.com/bifrost-finance/bifrost-subql/blob/pgsync/pgsync/schema/salp.json

- postgraphile

we need to define [views&functions](https://github.com/bifrost-finance/bifrost-subql/blob/pgsync/postgresql/monitor.sql) in postgresql and postgraphile will turn it into graphql endpoints automaticlly

![](https://i.imgur.com/SeAIRoH.png)

- postgreql-exporter

we need to define [rules](https://github.com/bifrost-finance/bifrost-subql/blob/pgsync/postgres-exporter/query.yaml) to mapping data in postgresql to prometheus

- alert rules

we need to define [alert rules](https://github.com/bifrost-finance/bifrost-subql/blob/pgsync/prometheus/rule_para.yaml) in prometheums

we can also define alert rules in grafana directly

![](https://i.imgur.com/yG56ynp.png)

- forward alert to slack

we need to add a slack channel and with the [predefind notifiers](https://github.com/bifrost-finance/bifrost-subql/blob/pgsync/grafana/provisioning/notifiers/slack.yaml) alert will be forwarded to slack channel

![](https://i.imgur.com/nnWo3Td.png)


- cadvisor

this component is for monitoring the docker containers

![](https://i.imgur.com/cPYDOSh.png)
![](https://i.imgur.com/1l3bi9m.png)


# Deploy

- build

```make build```

- start
    
```make start```
