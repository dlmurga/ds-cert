variable "region" {
  default = "us-east-2"
}

variable "ami" {
  default = "ami-03a0c45ebc70f98ea"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "keyname" {
  default = "terraform"
}

variable "private_key" {
  default = "/var/lib/jenkins/keys/terraform.pem"
}

variable "aws_credentials" {
  default = "/var/lib/jenkins/.aws/credentials"
}

variable "allow-all-egress-id" {
  default = "sg-03c6e44b06e768f35"
}

variable "allow-ssh-id" {
  default = "sg-030cdef92b5a83468"
}

variable "allow-tomcat-id" {
  default = "sg-0add683087d0243e1"
}