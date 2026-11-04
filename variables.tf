variable "tenant" {
  description = "Tenant slug. Becomes the Grafana organization name, the folder title and the suffix of every datasource uid."
  type        = string
}

variable "tenant_id" {
  description = "The Mimir and Loki tenant id, which is also the tenant's Kubernetes namespace. Sent as X-Scope-OrgID by every datasource this module creates."
  type        = string
}

variable "metrics_url" {
  description = "Mimir's Prometheus-compatible query endpoint"
  type        = string
}

variable "logs_url" {
  description = "Loki's query endpoint"
  type        = string
}

variable "staff_org_id" {
  description = "Organization that also receives the tenant's datasources, so support can read one customer at a time. Grafana's default organization is 1."
  type        = string
  default     = "1"
}

variable "admin_user" {
  description = "Login name of the Grafana server admin. Declaring it keeps the organization from adopting or removing that user."
  type        = string
  default     = "admin"
}

variable "dashboards_path" {
  description = "Directory holding the *.json.tftpl dashboards this module should create"
  type        = string
}
