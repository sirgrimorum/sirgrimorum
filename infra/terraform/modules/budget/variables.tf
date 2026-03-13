variable "environment" {
  type = string
}

variable "budget_limit" {
  type    = number
  default = 1
}

variable "budget_alert_email" {
  type    = string
  default = ""
}

variable "create_budgets" {
  type    = bool
  default = false
}
