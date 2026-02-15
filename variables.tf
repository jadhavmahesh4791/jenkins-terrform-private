variable "aws_region" {
  default = "us-west-2"
}

variable "ec2_type" {
  default = "t2.medium"
}

variable "aws_ami" {
  type = map(any)
  default = {

    us-east-1 = "ami-0aff18ec83b712f02"
    us-east-2 = "ami-0aff18ec83b712f03"
    us-west-1 = "ami-0aff18ec83b712f04"
    us-west-2 = "ami-0aff18ec83b712f05"
  }
}

variable "role" {
  default = "arn:aws:iam::851725402722:role/terraform-role"
}


variable "master" {
  default = "Jenkins-Master"

}

variable "agent" {
  default = "Jenkins-Agent"

}

variable "availability_zone" {
  type = map(any)
  default = {
    us-east-1 = "us-east-1a"
    us-east-2 = "us-east-2b"
    us-west-1 = "us-west-1a"
    us-west-2 = "us-west-2a"
  }
}

variable "tags" {
  default = {
    Crateion = "Terraform-July-2024"
    Name     = "Terraform-resource"
  }
}

variable "name" {
  type = map(any)
  default = {
    master = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240701",
    agent  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240701"
  }
}
