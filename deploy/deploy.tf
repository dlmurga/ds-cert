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


resource "aws_instance" "prodserver" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.prodserver_sg_id}"]
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