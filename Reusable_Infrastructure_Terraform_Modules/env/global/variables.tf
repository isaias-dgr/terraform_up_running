variable "project" {
  description = "The name of project application."
  type        = string
}

variable "environment" {
  description = "The environment in which the application will run."
  type        = string
  default     = "stage"
}