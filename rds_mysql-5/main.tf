# RDS Instance
module "rds_mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier              = var.rds_instance_identifier
  engine                  = "mysql"
  engine_version          = "8.0"
  family                  = "mysql8.0"
  major_engine_version    = "8.0"
  instance_class          = "db.t3.micro"
  allocated_storage       = 20
  max_allocated_storage   = 25

  db_name                 = var.rds_db_name
  port                    = 3306
  username                = var.rds_username
  password                = var.rds_password

  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  subnet_ids              = [aws_subnet.private_1a.id, aws_subnet.private_1b.id]
  create_db_subnet_group  = true
  multi_az                = false

  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 0

  tags = {
    Name        = "rds-mysql"
    Environment = "dev"
  }
}

# EC2 Instance in Public Subnet
resource "aws_instance" "ec2" {
  ami                         = var.ec2_ami_id
  instance_type               = var.ec2_instance_type
  subnet_id                   = aws_subnet.public_1a.id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = var.ec2_key_pair

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf install -y mariadb105
              EOF

  tags = {
    Name = "rds-client-ec2"
  }
}