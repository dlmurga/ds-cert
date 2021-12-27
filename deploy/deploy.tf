terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  shared_credentials_file = "${var.aws_credentials}"
  region = "${var.region}"
}

resource "aws_security_group" "allow-tomcat" {
  name = "allow-tomcat"
  ingress {
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_security_group" "allow-ssh" {
  name = "allow-ssh"
  ingress {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow-all-egress" {
  name = "allow-all-egress"
  egress {
    protocol  = "-1"
    from_port = 0
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "prodserver" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-tomcat.id, aws_security_group.allow-all-egress.id]
  tags = {
    Name = "prodserver"
  }
  key_name = "${var.keyname}"

  provisioner "remote-exec" {
    inline = ["sudo apt update"]
  }

  connection {
    type = "ssh"
    host = aws_instance.prodserver.public_ip
    user = "ubuntu"
    private_key = file("${var.private_key}")
  }

  provisioner "local-exec" {
    command = "echo '[prodserver]' > prodserver && echo ${self.public_ip} >> prodserver"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i prodserver --private-key ${var.private_key} deploy.yml"
  }
}