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


resource "aws_instance" "buildserver" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  vpc_security_group_ids = ["${var.buildserver_sg_id}"]
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