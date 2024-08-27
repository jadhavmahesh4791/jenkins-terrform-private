
resource "aws_security_group" "terraform_sg" {
  name        = "terraform_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id
  tags        = var.tags
}


resource "aws_vpc_security_group_ingress_rule" "terraform_sg_ipv4_80" {
  security_group_id = aws_security_group.terraform_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "terraform_sg_ipv4_22" {
  security_group_id = aws_security_group.terraform_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "terraform_sg_ipv4_443" {
  security_group_id = aws_security_group.terraform_sg.id
  cidr_ipv4         = "10.0.0.0/8"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "terraform_sg_ipv4_8080" {
  security_group_id = aws_security_group.terraform_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 8080
  ip_protocol       = "tcp"
  to_port           = 8080
  tags              = var.tags
}

## Allow Outbound traffic from AWS security group

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.terraform_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
  tags              = var.tags
}


# resource "aws_network_interface_sg_attachment" "sg_attachment" {
#   security_group_id    = aws_security_group.terraform_sg.id
#   network_interface_id = aws_instance.Jenkins-Master.primary_network_interface_id
# }

