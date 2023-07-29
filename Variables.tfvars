variable "aws_region" {
    default = "us-west-2"
}

variable "ec2_type" {
  default = "t2.micro"
}


variable "aws_ami" {
    type = map
    default = {
        us-east-1 = "ami-05f157d0d07e733c3"
        us-east-2 = "ami-0f91cedb707b09db0"
        us-west-1 = "ami-05f157d0d07e733c3"
        us-west-2 = "ami-094125af156557ca2"
    }

}