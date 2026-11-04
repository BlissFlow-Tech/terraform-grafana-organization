locals {
  datasources = {
    mimir = {
      type       = "prometheus"
      name       = "Mimir"
      url        = var.metrics_url
      is_default = true
      json_data = {
        httpMethod     = "POST"
        prometheusType = "Mimir"
        timeInterval   = "30s"
      }
    }
    loki = {
      type       = "loki"
      name       = "Loki"
      url        = var.logs_url
      is_default = false
      json_data = {
        httpMethod = "POST"
      }
    }
  }

  dashboards = fileset(var.dashboards_path, "*.json.tftpl")
}

resource "grafana_organization" "this" {
  name         = var.tenant
  admin_user   = var.admin_user
  create_users = false
  lifecycle {
    ignore_changes = [viewers, editors, admins]
  }
}

resource "grafana_data_source" "tenant" {
  for_each = local.datasources

  org_id            = grafana_organization.this.org_id
  type              = each.value.type
  name              = each.value.name
  uid               = "${each.key}-${var.tenant}"
  url               = each.value.url
  is_default        = each.value.is_default
  json_data_encoded = jsonencode(each.value.json_data)
  http_headers      = { "X-Scope-OrgID" = var.tenant_id }
}

resource "grafana_data_source" "staff" {
  for_each = local.datasources

  org_id            = var.staff_org_id
  type              = each.value.type
  name              = "${each.value.name} ${var.tenant_id}"
  uid               = "staff-${each.key}-${var.tenant}"
  url               = each.value.url
  json_data_encoded = jsonencode(each.value.json_data)
  http_headers      = { "X-Scope-OrgID" = var.tenant_id }
}

resource "grafana_folder" "this" {
  org_id = grafana_organization.this.org_id
  title  = var.tenant
  uid    = var.tenant_id
}

resource "grafana_dashboard" "this" {
  for_each = local.dashboards

  org_id    = grafana_organization.this.org_id
  folder    = grafana_folder.this.uid
  overwrite = true

  config_json = templatefile("${var.dashboards_path}/${each.value}", {
    tenant      = var.tenant
    namespace   = var.tenant_id
    logs_uid    = grafana_data_source.tenant["loki"].uid
    metrics_uid = grafana_data_source.tenant["mimir"].uid
  })
}
