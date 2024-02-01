resource "aws_vpc" "vvp" {
  cidr_block                = "10.0.0.0/16"
  
  tags = {
    Name                    = var.name
  }
}

resource "aws_subnet" "vvp" {
  vpc_id                    = aws_vpc.vvp.id
  cidr_block                = "10.0.0.0/20"

  tags = {
    Name                    = var.name
  }
}

resource "aws_route_table_association" "vvp" {
  subnet_id                 = aws_subnet.vvp.id
  route_table_id            = aws_vpc.vvp.main_route_table_id
}

resource "aws_internet_gateway" "vvp" {
  vpc_id                    = aws_vpc.vvp.id

  tags = {
    Name                    = var.name
  }
}

resource "aws_route" "vvp" {
  route_table_id            = aws_vpc.vvp.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.vvp.id
}

resource "aws_security_group" "vvp" {
  name                      = var.name
  vpc_id                    = aws_vpc.vvp.id

  tags = {
    Name                    = var.name
  }
}

resource "aws_security_group_rule" "ssh" {
  type                      = "ingress"
  from_port                 = 22
  to_port                   = 22
  protocol                  = "TCP"
  cidr_blocks               = ["${local.local_ip}/32"]
  security_group_id         = aws_security_group.vvp.id
}

resource "aws_security_group_rule" "metastore" {
  type                      = "ingress"
  from_port                 = 9083
  to_port                   = 9083
  protocol                  = "TCP"
  cidr_blocks               = ["${local.local_ip}/32"]
  security_group_id         = aws_security_group.vvp.id
}

resource "aws_security_group_rule" "outbound" {
  type                      = "egress"
  from_port                 = 0
  to_port                   = 0
  protocol                  = "ALL"
  cidr_blocks               = ["0.0.0.0/0"]
  security_group_id         = aws_security_group.vvp.id
}
