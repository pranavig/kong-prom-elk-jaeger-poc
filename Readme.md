# Install k3s
```bash
curl -sfL https://get.k3s.io | sh - 
```

# Install helm
```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

## Installation of Kong Gateway in local Kind cluster

```bash
cd 00-Kong

chmod +x install.sh
./install.sh
```

## Install prometheus and grafana in the kind cluster created above to collect the kong metrics
```bash
cd 01-prometheus

chmod +x install.sh
./install.sh
```

## Install ELK stack using kubernetes CRDs and collect the kong logs
```bash
cd 02-elk

chmod +x install.sh
./install.sh
```


## Generate some proxy traffic
### Create a service and route in kong
```bash
http --verify=no POST https://admin-dev.127.0.0.1.nip.io/services name=first-demo url=https://httpbin.org Kong-Admin-Token:password
http --verify=no -f POST https://admin-dev.127.0.0.1.nip.io/services/first-demo/routes name=first-route paths=/demo Kong-Admin-Token:password
```

### Test the route
http://127.0.0.1.nip.io/demo
http://127.0.0.1.nip.io/demo/anything