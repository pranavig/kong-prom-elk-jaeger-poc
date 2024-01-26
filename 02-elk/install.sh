kubectl create ns elk-wip

kubectl apply -f elasticsearch-ss.yaml

kubectl apply -f logstash-deployment.yaml

kubectl apply -f filebeat-kubernetes.yaml

kubectl apply -f kibana-deployment.yaml

kubectl get pods -n elk-wip

sleep 60

# kubectl port-forward service/elasticsearch 9200:9200 -n elk-wip
kubectl port-forward service/kibana 5601:5601 -n elk-wip

# # check indices
# ```bash
# curl http://localhost:9200/_cat/indices\?v
# ```


# > Test filebeat logs with autodiscover
# ```bash
# kubectl logs -n elk-wip -l app=filebeat
# ```