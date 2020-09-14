provider "aws" {
	region = "ap-south-1"
	profile = "pushkar1"
}

resource "aws_security_group" "rds_mysql_sg" {
  name        = "rds_mysql_sg"
  description = "Allow Tcp and mysql "
  vpc_id      = "vpc-5a595432"
  

 
 ingress {
    description = "http"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_MySql_http"
  }
}

resource "aws_db_instance" "rds_mysql" {
  identifier = "database-sql"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7.30"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "pushkar"
  password             = "pushkar121"
  parameter_group_name = "default.mysql5.7"
  iam_database_authentication_enabled = true
  publicly_accessible = true
  skip_final_snapshot = true
  vpc_security_group_ids = [ "${aws_security_group.rds_mysql_sg.id}"]
}

output "ip" {
value = "${aws_db_instance.rds_mysql.address}"
}