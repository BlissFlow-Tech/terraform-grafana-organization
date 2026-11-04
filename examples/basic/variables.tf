variable "tenant" {
  description = "Tenant slug, also used as its Mimir and Loki tenant id"
  type        = string
  default     = "acme"
}

variable "metrics_url" {
  description = "Mimir's Prometheus-compatible query endpoint"
  type        = string
  default     = "http://mimir.example.internal/prometheus"
}

variable "logs_url" {
  description = "Loki's query endpoint"
  type        = string
  default     = "http://loki.example.internal"
}
