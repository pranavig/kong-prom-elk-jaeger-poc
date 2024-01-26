## Hybrid setup with kong KIC and manual self signed certs

This is more like self signed kong hybrid setup with cert manager. The difference is, the certs are generated manually with OpenSSL(self signed)

One limitation when configuring Kong in hybrid setup with KIC locally is, we cannot have Load Balancer for kong cluster service and telemetry service, so the DP cannot communicate to admin/manager/portal/portal-api services.

So for the DP to communicate to the CP cluster, we need to use service to service communication rather than communication over Ingress or Load Balancer. For this reason, the ssl certs for the cluster and telemetry will be created separately. i.e we have 2 sets of self signed certs in this setup, 1 set for admin/manager/portal/porta-api(wildcard) and 1 set for cluster/telemetry(wildcard) services.

For Certs: 
```
cd certs
sh create-certs.sh
```

Install: 
```
sh install.sh
```
