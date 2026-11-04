output "organization" {
  description = "The Grafana organization created for the tenant"
  value = {
    id     = grafana_organization.this.id
    org_id = grafana_organization.this.org_id
    name   = grafana_organization.this.name
  }
}

output "datasources" {
  description = "Datasource uids, in the tenant's own organization and in the staff organization"
  value = {
    tenant = { for k, d in grafana_data_source.tenant : k => d.uid }
    staff  = { for k, d in grafana_data_source.staff : k => d.uid }
  }
}

output "dashboards" {
  description = "Dashboard uids created in the tenant's organization, keyed by template file name"
  value       = { for k, d in grafana_dashboard.this : k => d.uid }
}
