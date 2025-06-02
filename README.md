# How to update from aws rds_mysql ~>5.0 to 6.12.0

## To deploy rds_mysql 5.x version on AWS

- Prepare tf vriables:
```bash
cd rds_mysql-5
cp terraform.tfvars.example terraform.tfvars
```

update "terraform.tfvars" with your data, especialy ssh key should alredy exist on AWS within region

- Deploy rds_mysql 5.x version on AWS
```bash
terraform init
terraform plan
terraform apply
```

- Fill in DB and data check

Connect to ec2 (mysql client preinstalled):
```bash
ssh -i "<your_ssh_from_variables.pem>" ec2-user@<ec2_public_dns_from_output>
```

Fill in data in DB:

```bash
mysql -h <rds_endpoint_from_output> -P 3306 -u admin -p <rds_db_name> < dummy.sql
```

OR

```bash
mysql -h <rds_endpoint_from_output> -P 3306 -u admin -p
```
```sql
USE testdb;
SHOW TABLES;
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100),
  email VARCHAR(100)
);

INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com'),
('Charlie', 'charlie@example.com');
```

Check that data exists

```sql
SELECT * FROM users;
```

## Preparation steps before update:

- RDS backup (snapshot)
```bash
aws rds create-db-snapshot \
  --db-snapshot-identifier my-rds-backup-20250601 \
  --db-instance-identifier test-rds-instance
```

- backup state
Run terraform state list > tf-state.txt
Export your terraform.tfstate for safety.

## Updateing rds_mysql to 6.12.0

- check changelog from ~>5.0 to 6.12.0

https://github.com/terraform-aws-modules/terraform-aws-rds/blob/master/CHANGELOG.md


- update module
```
module "rds_mysql" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0"

  manage_master_user_password = false # to manage password in current way from variables
  
  ...
}
```

- update outputs.tf

module.rds_mysql.db_instance_id => module.rds_mysql.db_instance_identifier

remove output "rds_password" # created explecetly instead (variable exists)


- run
```bash
terraform init
terraform apply
```

In result only module.rds_mysql.random_password.master_password[0] will be destroyed - it's ok for us. RDS will be in place.

❗ WARNING: to connect under master user you should use password from defined in module config

