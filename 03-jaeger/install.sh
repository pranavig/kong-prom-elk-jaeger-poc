helm repo add jaegertracing https://jaegertracing.github.io/helm-charts

# Install Jaeger
kubectl create ns jaeger
helm upgrade -i -n jaeger jaeger jaegertracing/jaeger -f values.yaml

# Need to test the below once
curl -k -X POST https://admin-dev.127.0.0.1.nip.io/plugins \
   --data "name=opentelemetry"  \
   --data "config.endpoint=http://jaeger-collector.jaeger.svc.cluster.local:4318/v1/traces"  \
   --data "config.header_type=preserve" \
   --data "config.batch_flush_delay=3" \
   --data "config.batch_span_count=200" \
   --data "config.connect_timeout=1000" \
   --data "config.http_response_header_for_traceid=null" \
   --data "config.read_timeout=5000" \
   --data "config.send_timeout=5000" \
   --data "config.queue.initial_retry_delay=0.01" \
   --data "config.queue.max_batch_size=1" \
   --data "config.queue.max_coalescing_delay=1" \
   --data "config.queue.max_entries=10000" \
   --data "config.queue.max_retry_delay=60" \
   --data "config.queue.max_retry_time=60" \
   -H "Kong-Admin-Token:password"


# - config:
#     batch_flush_delay: 3
#     batch_span_count: 200
#     connect_timeout: 1000
#     endpoint: http://jaeger-collector.jaeger.svc.cluster.local:4318/v1/traces
#     header_type: preserve
#     headers: {}
#     http_response_header_for_traceid: null
#     queue:
#       initial_retry_delay: 0.01
#       max_batch_size: 1
#       max_bytes: null
#       max_coalescing_delay: 1
#       max_entries: 10000
#       max_retry_delay: 60
#       max_retry_time: 60
#     read_timeout: 5000
#     resource_attributes: {}
#     send_timeout: 5000
#   enabled: false
#   name: opentelemetry
#   protocols:
#   - grpc
#   - grpcs
#   - http
#   - https