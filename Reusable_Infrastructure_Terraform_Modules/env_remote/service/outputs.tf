output "alb_dns_name" {
  value       = module.webserver_cluster.alb_dns_name
  description = "The domain name of the load balancer"
}

output "address" {
  value       = module.relational_db.address
  description = "Connect to the database at this endpoint"
}

output "port" {
  value       = module.relational_db.port
  description = "The port the database is listening on"
}