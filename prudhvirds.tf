resource "aws_db_instance" "prudhvidb" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  name                 = "mydb"
  username             = "prudhvi"
  password             = "8686569292"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
}

resource "aws_db_instance" "prudhvidb" {
 

  allocated_storage     = 50
  max_allocated_storage = 100
}