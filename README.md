# terraform-grafana-organization

Terraform module that creates an isolated Grafana organization with Mimir and Loki datasources scoped to one tenant id, a folder, and dashboards rendered from templates.

## Usage

```hcl
module "grafana" {
  source  = "blissflow-tech/organization/grafana"
  version = "~> 1.0"

  tenant          = "acme"
  tenant_id       = "acme"
  metrics_url     = "http://mimir.example.internal/prometheus"
  logs_url        = "http://loki.example.internal"
  dashboards_path = "${path.module}/dashboards"
}
```

## Notes

* Isolation comes from the `X-Scope-OrgID` header each datasource sends server-side with `tenant_id`. A Viewer can't see or edit it, and can't add a datasource of their own, so the organization only ever reads that tenant's metrics and logs.
* The same datasources are mirrored into a support/operator organization (`staff_org_id`, Grafana's default organization `1` unless set) under a tenant-qualified name, so operators can read one tenant at a time without a second copy of the data.
* Every `*.json.tftpl` file in `dashboards_path` becomes a dashboard in the tenant's folder. Templates receive `tenant`, `namespace` (the `tenant_id`), `logs_uid` and `metrics_uid`. Bake the tenant in as a constant instead of offering it as a dashboard variable: a dropdown a Viewer can change is not a boundary.
* Dashboards are keyed by file name, so renaming a file replaces the dashboard instead of updating it.
* `admin_user` is declared on the organization so it neither adopts nor removes the Grafana server admin. User membership is ignored, so users are managed outside Terraform.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| terraform | ~> 1.0 |
| grafana | ~> 4.49 |

## Providers

| Name | Version |
| ---- | ------- |
| grafana | ~> 4.49 |

## Resources

| Name | Type |
| ---- | ---- |
| [grafana_dashboard.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/dashboard) | resource |
| [grafana_data_source.staff](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [grafana_data_source.tenant](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/data_source) | resource |
| [grafana_folder.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/folder) | resource |
| [grafana_organization.this](https://registry.terraform.io/providers/grafana/grafana/latest/docs/resources/organization) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| dashboards\_path | Directory holding the *.json.tftpl dashboards this module should create | `string` | n/a | yes |
| logs\_url | Loki's query endpoint | `string` | n/a | yes |
| metrics\_url | Mimir's Prometheus-compatible query endpoint | `string` | n/a | yes |
| tenant | Tenant slug. Becomes the Grafana organization name, the folder title and the suffix of every datasource uid. | `string` | n/a | yes |
| tenant\_id | The Mimir and Loki tenant id, which is also the tenant's Kubernetes namespace. Sent as X-Scope-OrgID by every datasource this module creates. | `string` | n/a | yes |
| admin\_user | Login name of the Grafana server admin. Declaring it keeps the organization from adopting or removing that user. | `string` | `"admin"` | no |
| staff\_org\_id | Organization that also receives the tenant's datasources, so support can read one customer at a time. Grafana's default organization is 1. | `string` | `"1"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| dashboards | Dashboard uids created in the tenant's organization, keyed by template file name |
| datasources | Datasource uids, in the tenant's own organization and in the staff organization |
| organization | The Grafana organization created for the tenant |
<!-- END_TF_DOCS -->

## License

Apache 2.0. See [LICENSE](LICENSE).
