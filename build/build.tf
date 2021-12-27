terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region = "${var.region}"
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

resource "aws_instance" "buildserver" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = [aws_security_group.allow-ssh.id, aws_security_group.allow-all-egress.id]
  tags = {
    Name = "buildserver"
  }
  key_name = "${var.keyname}"

  provisioner "remote-exec" {
    inline = ["sudo apt update"]
  }

  connection {
    type = "ssh"
    host = aws_instance.buildserver.public_ip
    user = "ubuntu"
    private_key = file("${var.private_key}")
  }

  provisioner "local-exec" {
    command = "echo '[buildserver]' > buildserver && echo ${self.public_ip} >> buildserver"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -u ubuntu -i buildserver --private-key ${var.private_key} build.yml"
  }
}