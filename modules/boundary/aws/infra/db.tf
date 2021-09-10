resource "aws_db_instance" "boundary" {
  allocated_storage   = 20
  storage_type        = "gp2"
  engine              = "postgres"
  engine_version      = "11.8"
  instance_class      = "db.t2.micro"
  name                = "boundary"
  username            = "boundary"
  password            = "boundarydemo"
  skip_final_snapshot = true

  vpc_security_group_ids = [aws_security_group.allow-boundary-db-inbound.id]
  db_subnet_group_name   = aws_db_subnet_group.boundary.name

  tags = {
    owner = var.owner
    TTL = var.ttl
  }
}

resource "aws_db_subnet_group" "boundary" {
  name       = "boundary"
  subnet_ids = var.public_subnet_ids

  tags = {
    owner = var.owner
    TTL = var.ttl
  }
}