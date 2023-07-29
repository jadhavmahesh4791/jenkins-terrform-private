# Creating  instance with imanage
resource "aws_instance" "web" {
    ami           = lookup(var.aws_ami, var.aws_region, false)
    instance_type = var.ec2_type
    tags ={
        Name = "web-server"
    }
}

# Create a VPC
resource "aws_vpc" "underlay-0" {
  cidr_block = "10.0.0.0/16"
}