output "rds_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.rds_mysql.db_instance_id
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS database"
  value       = module.rds_mysql.db_instance_endpoint
}

output "rds_port" {
  description = "The port the RDS instance is listening on"
  value       = module.rds_mysql.db_instance_port
}

output "rds_username" {
  description = "Username for the database"
  value       = module.rds_mysql.db_instance_username
}

output "rds_db_name" {
  description = "The ARN of the RDS instance"
  value       = var.rds_db_name
}

output "rds_password" {
  description = "Password for the db_instance_username"
  value     = module.rds_mysql.db_instance_password
  sensitive = true
}

output "ec2_public_dns" {
  description = "ec2 public hostname"
  value = aws_instance.ec2.public_dns
}