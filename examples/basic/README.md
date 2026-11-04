# Basic example

Creates a Grafana organization for the `acme` tenant, with Mimir and Loki datasources scoped to it and one overview dashboard from `dashboards/`.

The Grafana provider reads its server URL and admin credentials from `GRAFANA_URL` and `GRAFANA_AUTH`.

```sh
terraform init
terraform apply -var tenant=acme
```
