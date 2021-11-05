variable "project" {
  description = "The name of project"
  type        = string
}

variable "environment" {
  description = "Source's enviroment"
  type        = string
  default     = "stage"
}

variable "db_name" {
  description = "The name for the database"
  type        = string
}

variable "db_username" {
  description = "The username for the database"
  type        = string
}

variable "db_password" {
  description = "The password for the database"
  type        = string
}