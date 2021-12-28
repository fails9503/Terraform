# Web security group
# external -> 80(HTTP)
# external -> 22(HTTP)
# any -> external(Outbound)
resource "aws_security_group" "sg_web" {
  name = "sg_web"
  description = "HTTP / SSH"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "tcp"
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_web"
    Project = var.project
  }

}

# Web security group
# external -> 3306(HTTP)
# any -> external(Outbound)
resource "aws_security_group" "sg_db" {
  name = "sg_db"
  description = "Allow 3306 From WEB"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 3306
    protocol = "tcp"
    to_port = 3306
    # Allow from another security groups
    security_groups = [aws_security_group.sg_web.id]
  }

  egress {
    from_port = 0
    protocol = "tcp"
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_db"
    Project = var.project
  }
}