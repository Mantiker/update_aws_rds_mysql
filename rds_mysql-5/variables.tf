variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "rds_instance_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "rds_db_name" {
  description = "Initial database name"
  type        = string
}

variable "rds_username" {
  description = "Master username for RDS"
  type        = string
}

variable "rds_password" {
  description = "Master password for RDS"
  type        = string
  sensitive   = true
}

variable "ec2_ami_id" {
  description = "Amazon Linux 2023 AMI"
  type        = string
  default     = "ami-02b7d5b1e55a7b5f1"
}

variable "ec2_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ec2_key_pair" {
  description = "Pre-created EC2 key pair name"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Allowed IP for ec2 connection: narrow this for security"
  default     = "0.0.0.0/0"
}
