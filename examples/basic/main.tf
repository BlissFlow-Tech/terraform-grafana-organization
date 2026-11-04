module "grafana" {
  source = "../.."

  tenant          = var.tenant
  tenant_id       = var.tenant
  metrics_url     = var.metrics_url
  logs_url        = var.logs_url
  dashboards_path = "${path.module}/dashboards"
}

output "organization_id" {
  value = module.grafana.organization.org_id
}
