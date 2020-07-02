provider "aws" {
  region = "${var.region}"
}

locals {
  tags = {
    Name = "Terraform"
  }
}

resource "aws_vpc" "Terraform" {
  cidr_block = "192.168.0.0/16"
  tags       = "${local.tags}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.Terraform.id}"
  tags   = "${local.tags}"
}

resource "aws_subnet" "public_a" {
  vpc_id            = "${aws_vpc.Terraform.id}"
  cidr_block        = "192.168.1.0/24"
  availability_zone = "${var.region}a"
  tags = {
    Name = "Public 1a"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id            = "${aws_vpc.Terraform.id}"
  cidr_block        = "192.168.9.0/24"
  availability_zone = "${var.region}b"
  tags = {
    Name = "Public 1b"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = "${aws_vpc.Terraform.id}"
  cidr_block        = "192.168.2.0/23"
  availability_zone = "${var.region}a"
  tags = {
    Name = "Private 1a"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = "${aws_vpc.Terraform.id}"
  cidr_block        = "192.168.4.0/23"
  availability_zone = "${var.region}b"
  tags = {
    Name = "Private 1b"
  }

}
resource "aws_route_table" "rt_public" {
  vpc_id = "${aws_vpc.Terraform.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }
  tags = {
    Name = "Terraform Public"
  }
}

resource "aws_route_table" "rt_private" {
  vpc_id = "${aws_vpc.Terraform.id}"
  tags = {
    Name = "Terraform Private"
  }
}


resource "aws_route_table_association" "public_a" {
  subnet_id      = "${aws_subnet.public_a.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = "${aws_subnet.public_b.id}"
  route_table_id = "${aws_route_table.rt_public.id}"
}



resource "aws_route_table_association" "private_a" {
  subnet_id      = "${aws_subnet.private_a.id}"
  route_table_id = "${aws_route_table.rt_private.id}"
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = "${aws_subnet.private_b.id}"
  route_table_id = "${aws_route_table.rt_private.id}"
}


/*
resource "aws_security_group" "web" {
  name        = "web"
  description = "public"
  vpc_id      = "${aws_vpc.Terraform.id}"

  ingress {
    from_port       = 80 #http
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443 #https
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web server"
  }
}

resource "aws_security_group" "db" {
  name        = "db"
  description = "database connections"
  vpc_id      = "${aws_vpc.Terraform.id}"

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = ["${aws_security_group.web.id}"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Data Base"
  }
}*/

