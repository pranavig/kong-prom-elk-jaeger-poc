## Install kong gateway
- Installation of Kong gateway is done in step 00-Kong

## Enable prometheus plugin on kong api gateway using yaml file
```bash
kubectl apply -f prometheus-plugin.yaml
```
## Enable prometheus plugin on kong api gateway using admin api file

```bash
curl -k -X POST https://admin-dev.127.0.0.1.nip.io/plugins/ \
   --data "name=prometheus"  \
   --data "config.per_consumer=false" \
   --data "config.bandwidth_metrics=true" \
   --data "config.upstream_health_metrics=true" \
   --data "config.latency_metrics=true" \
   -H 'Kong-Admin-Token:password'
```
## Create a service for prometheus plugin
```bash
kubectl apply -f prometheus-plugin-svc.yaml
```
> In the seclector field in `prometheus-plugin-svc.yaml` file put the `kong-dp` pod label.
To verify which label we have to use in selector field of `prometheus-plugin-svc.yaml` file, try get the kong dp pod using `-l` command. For example: `kubectl get pods -l  app.kubernetes.io/instance=kong-dp -n kong-dp`. If you get the kong dp pod using label use that label as a selector.

## Check the metrics using curl
```bash
# curl http://<svc-cluster-ip>:8100/metrics
# (or)
curl http://kong-monitoring.kong-dp.svc.cluster.local:8100/metrics
```

## Install prometheus to export metrics to grafana
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/prometheus -f prometheus-values.yaml
```
> We created new job called `kong` under scrape_configs section.
We mentioned prometheus service which we created as a target for this job.
The service url format is `<prometehus-service-name>.<namespace-of-promtehus-service>.svc.cluster.local:<port-no>`

```bash
kubectl port-forward service/prometheus-server 9090:80 --address=0.0.0.0`

# http://127.0.0.1.nip.io:9090
```

## Ensure the kong metrics target shows up in Prometheus
> This can be seen at `http://<prometheus-cluster-ip:port>/targets`
> prometheus-server.default.svc.cluster.local

## Install grafana to see kong metrics
```
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana --set adminPassword=<your_password>
```
> grafana.default.svc.cluster.local

## Add prometheus as a datasource in grafana
http://grafana.default.svc.cluster.local

login as admin/admin

Go to connections -> datasources -> add new datasource -> select promtheus and mention the Prometheus server URL as
http://prometheus-server.default.svc.cluster.local

## Create a dashboard
Go to `Dashboards` -> `New` -> `New Dashboard` -> `Import Dashboard` -> input `7424` -> `Load` -> Select the Prometheus datasource created above
