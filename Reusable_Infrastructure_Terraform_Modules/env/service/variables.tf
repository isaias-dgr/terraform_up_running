variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
}

variable "project" {
  description = "The name of the project."
  type = string
}

variable "environment" {
  description = "The enviroment of deploy."
  type = string
}

variable "db_password" {
  description = "The password for setup of rdb."
  type = string
}

