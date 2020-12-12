# This example has automatic snapshots enabled, server whitelist enabled, server properties + other config enabled, and auto-start for the minecraft server enabled

locals {
  region = "eu-north-1"
}

provider "aws" {
  version = "~> 2.0"
  region  = local.region
}

#########
# Module
#########
module "minecraft_server" {
  source = "./../../."

  # VPC
  vpc_cidr = "172.31.0.0/16"

  # EC2
  instance_type     = "t3.nano" # pick one to fit your usage
  instance_key_pair = "sveliland"
  ami_id            = "ami-01996625fff6b8fcc" # ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200611
  snapshot_config = {
    hour_interval = 24
    time          = "08:45" # 8:45am UTC / 4:45am EDT
    retain        = 7
  }
  ingress = {
    ssh = {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_block  = "51.175.152.42/32"
      description = "jhsveli@gmail.com"
    }
    icmp = {
      from_port   = -1
      to_port     = -1
      protocol    = "icmp"
      cidr_block  = "51.175.152.42/32"
      description = "jhsveli@gmail.com"
    }
  }

  # Server init
  ssh_private_key_filepath    = "~/.ssh/sveliland.pem"
  server_package_filepath     = "./files/bedrock-server-1.16.1.02.zip"
  server_properties_filepath  = "./files/server.properties"
  server_whitelist_filepath   = "./files/whitelist.json"
  server_permissions_filepath = "./files/permissions.json"

  # Tag
  tag_postfix = "sveliland"
}

#########
# Output
#########
output "instance_public_ip" {
  value = module.minecraft_server.instance_public_ip
}
