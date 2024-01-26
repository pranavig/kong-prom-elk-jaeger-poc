# START - (Optional Clean up commands)

helm uninstall kong-cp -n kong-cp
helm uninstall kong-dp -n kong-dp
kubectl delete pvc --all -n kong-cp
kubectl delete pvc --all -n kong-dp

sleep 10
kubectl delete po --all -n kong-cp
kubectl delete jobs --all -n kong-cp

kubectl delete po --all -n kong-dp
kubectl delete jobs --all -n kong-dp

kubectl delete ns kong-cp --grace-period=0 --force
kubectl delete ns kong-dp --grace-period=0 --force
## END - (Optional Clean up commands)

helm uninstall traefik -n kube-system

sleep 5
kubectl create ns kong-cp
kubectl create ns kong-dp

echo "-------------------------------------------------------------------------------------"
echo "WARNING!! This license.json file is empty, please make sure to copy your license here."
echo "-------------------------------------------------------------------------------------"

kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong-cp --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong-dp --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic kong-manager-password -n kong-cp \
 --from-literal=password=password

kubectl create secret generic kong-cp-postgresql -n kong-cp \
    --from-literal=password=password@123
kubectl create secret generic kong-smtp-password -n kong-cp \
    --from-literal=smtp_password=Mail123$

kubectl create secret generic kong-session-config -n kong-cp --from-literal=portal_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"portal_session","cookie_same_site":"Lax","cookie_secure":false,"cookie_domain":".127.0.0.1.nip.io"}' --from-literal=admin_gui_session_conf='{"cookie_name":"admin_session","cookie_same_site":"Lax","secret":"super_secret_salt_string","cookie_secure":false,"storage":"kong","cookie_domain":".127.0.0.1.nip.io"}'

## Cert secrets
kubectl create secret tls kong-cluster-cert -n kong-cp \
 --cert=certs/cp-tls-bundle.crt \
 --key=certs/cp-tls.key
 
kubectl create secret generic kong-ca-cert -n kong-cp \
 --from-file=ca.crt=certs/ca.crt

kubectl create secret tls kong-cluster-cert -n kong-dp \
 --cert=certs/cp-tls-bundle.crt \
 --key=certs/cp-tls.key 

kubectl create secret generic kong-ca-cert -n kong-dp \
 --from-file=ca.crt=certs/ca.crt 

### for cluster
kubectl create secret tls kong-cluster-cert-two -n kong-cp \
 --cert=certs/cluster-cp-tls-bundle.crt \
 --key=certs/cluster-cp-tls.key
 
kubectl create secret tls kong-cluster-cert-two -n kong-dp \
 --cert=certs/cluster-dp-tls-bundle.crt \
 --key=certs/cluster-dp-tls.key

helm repo add kong https://charts.konghq.com
helm repo update
helm upgrade --install kong-cp kong/kong --namespace kong-cp -f values-cp.yaml
sleep 10
helm upgrade --install kong-dp kong/kong --namespace kong-dp -f values-dp.yaml

# kubectl get po -n kong-enterprise -w