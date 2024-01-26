# kubectl apply -f prometheus-plugin.yaml
curl -k -X POST https://admin-dev.127.0.0.1.nip.io/plugins/ \
   --data "name=prometheus"  \
   --data "config.per_consumer=false" \
   --data "config.bandwidth_metrics=true" \
   --data "config.upstream_health_metrics=true" \
   --data "config.latency_metrics=true" \
   -H 'Kong-Admin-Token:password'


# > In the seclector field in `prometheus-plugin-svc.yaml` file put the `kong-dp` pod label.
# To verify which label we have to use in selector field of `prometheus-plugin-svc.yaml` file, try get the kong dp pod using `-l` command. For example: `kubectl get pods -l  app.kubernetes.io/instance=kong-dp -n kong-dp`. If you get the kong dp pod using label use that label as a selector.

kubectl apply -f prometheus-plugin-svc.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/prometheus -f prometheus-values.yaml


# kubectl port-forward service/prometheus-server 9090:80 --address=0.0.0.0

sleep 10

helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade --install grafana grafana/grafana --set adminPassword=admin --set "service.type"=NodePort

echo "Setup Done. Verify the installation and add prometheus data source to grafana from the UI."