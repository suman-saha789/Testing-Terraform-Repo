# Security group for db

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  vpc_id      = aws_vpc.tf-vpc.id
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}




#6 Secret manager
#Firstly create a random generated password to use in secrets

resource "random_password" "password" {
  length              = 16
  special             = true
  override_special    = "_%@"

}

# Creating a AWS secret for database master account (Masteraccoundb)

resource "aws_secretsmanager_secret" "secretmasterDB1" {
  name                = "masteraccountDB2"
}

# Creating a AWS secret versions for database master account (Masteraccoundb)

/*resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id          = "aws_secretmanager_secret.secretmasterDB1.id"
  secret_string = <<EOF
   {
    "username": "adminaccount",
    "password": random_password.password.result
   }
EOF
}*/


data "aws_secretsmanager_secret_version" "cred1" {
  secret_id = "arn:aws:secretsmanager:ap-southeast-1:848584396919:secret:masteraccountDB2-M7SCwK"
  version_stage   = "AWSCURRENT" 
}




resource "aws_db_instance" "myrds" {
  allocated_storage    = 5
  storage_type         = "gp2"
  db_name              = "mydb"
  engine               = "mysql"
  engine_version       = "8.0.32"
  multi_az             = false
  port                 = "3306"
  instance_class       = "db.t2.micro"
  db_subnet_group_name = aws_db_subnet_group.db-subnet.name
  vpc_security_group_ids = [ aws_security_group.rds_sg.id ]
  #manage_master_user_password = true
  skip_final_snapshot  = true
  deletion_protection  = false
  username             = "adminaccount"
  password             = random_password.password.result
}



# Create DB subnet group

resource "aws_db_subnet_group" "db-subnet" {
  name       = "db-subnet"
  subnet_ids = [ aws_subnet.private-subnet1.id, aws_subnet.private-subnet2.id ]
  tags = {
    Name = "My-DB-subnet-  group"
  }
}


#manage_master_user_password = true  use this value with secret manager
