# key pair (login)
resource "aws_key_pair" "myec2_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

# VPC & Security group
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}
# inbound rules
resource "aws_security_group" "tera_sec_group" {
  name = "terra_sec_grp"
  description = "this will add TF gen group"
  vpc_id = aws_default_vpc.default.id

ingress {
  from_port = 22
  to_port = 22
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
  description = "ssh open"

}
ingress {
  from_port = 80
  to_port = 80
  protocol = "TCP"
  cidr_blocks = ["0.0.0.0/0"]
  description = "http open"

}
# outbond rules
egress {
  from_port = 0
  to_port = 0
  protocol = -1
  cidr_blocks = ["0.0.0.0/0"]
  description = "all access open"

}
tags = {
  Name = "terra_sec_grp"
 }
}

# ec2 instance
resource "aws_instance" "my_instance" {
  key_name = aws_key_pair.myec2_key.key_name
  security_groups = [aws_security_group.tera_sec_group.name]
  instance_type = "t2.micro"
  ami = "ami-0cb91c7de36eed2cb"
  root_block_device {
        volume_size = 14
        volume_type = "gp3"
    }
    tags = {
        Name = "my auto inst"
    }
  
  
}

