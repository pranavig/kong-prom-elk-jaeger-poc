# mkdir -p certs
# cd certs

openssl genrsa -out ca.key 4096
openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 -out ca.crt

openssl genrsa -out cp-tls.key 2048
openssl req -new -key cp-tls.key -out cp-tls.csr -subj "/CN=*.127.0.0.1.nip.io"

openssl genrsa -out dp-tls.key 2048
openssl req -new -key dp-tls.key -out dp-tls.csr -subj "/CN=*.127.0.0.1.nip.io"

openssl x509 -req -in cp-tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out cp-tls.crt -days 365 -sha256
openssl x509 -req -in dp-tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out dp-tls.crt -days 365 -sha256

cat cp-tls.crt ca.crt > cp-tls-bundle.crt
cat dp-tls.crt ca.crt > dp-tls-bundle.crt

## Create separate certs for cluster communication
openssl genrsa -out cluster-cp-tls.key 2048
openssl req -new -key cluster-cp-tls.key -out cluster-cp-tls.csr -subj "/CN=*.kong-cp.svc.cluster.local"

openssl genrsa -out cluster-dp-tls.key 2048
openssl req -new -key cluster-dp-tls.key -out cluster-dp-tls.csr -subj "/CN=*.kong-cp.svc.cluster.local"

openssl x509 -req -in cluster-cp-tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out cluster-cp-tls.crt -days 365 -sha256
openssl x509 -req -in cluster-dp-tls.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out cluster-dp-tls.crt -days 365 -sha256

cat cluster-cp-tls.crt ca.crt > cluster-cp-tls-bundle.crt
cat cluster-dp-tls.crt ca.crt > cluster-dp-tls-bundle.crt
