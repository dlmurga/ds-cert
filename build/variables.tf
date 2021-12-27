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
