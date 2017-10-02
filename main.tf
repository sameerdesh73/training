#
# DO NOT DELETE THESE LINES!
#
# Your AMI ID is:
#
#     ami-d651b8ac
#
# Your subnet ID is:
#
#     subnet-a2a469e9
#
# Your security group ID is:
#
#     sg-2788a154
#
# Your Identity is:
#
#     NWI-vault-panda
#

terraform {
  backend "atlas" {
    name    = "sameerd/traing"
    address = "https://atlas.hashicorp.com"
  }
}


variable "aws_access_key" {}
variable "aws_secret_key" {}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

# variable "public_ip" {}

variable "count" {
  default = 2
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.aws_region}"
}

module "example" {
  source  = "./example-module"
  command = "echo bye bye module"
}

resource "aws_instance" "web" {
  # ...
  ami                    = "ami-d651b8ac"
  instance_type          = "t2.micro"
  subnet_id              = "subnet-a2a469e9"
  vpc_security_group_ids = ["sg-2788a154"]

  count = "2"

  tags {
    "Identity" = "NWI-vault-panda"
    "owner"    = "sameer"
    "when"     = "trainingclass"
    "count"    = "${var.count}"
    "name"     = "${format("web-%03d", count.index + 1)}"
  }
}

output "public_ips" {
  value = "${aws_instance.web.*.public_ip}"
}
