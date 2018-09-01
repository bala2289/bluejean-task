# Define VPC
resource "aws_vpc" "default" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "vpc-01"
  }
}

# Define the public subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet_cidr}"
  availability_zone = "us-west-1b"

  tags {
    Name = "Public Subnet"
  }
}

resource "aws_subnet" "public-subnet-2" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.public_subnet-2_cidr}"
  availability_zone = "us-west-1c"

  tags {
    Name = "Public Subnet-2"
  }
}

# Define the private subnet
resource "aws_subnet" "private-subnet" {
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.private_subnet_cidr}"
  availability_zone = "us-west-1c"

  tags {
    Name = "Private Subnet"
  }
}

# create EIP for NAT gateway
resource "aws_eip" "nat-eip" {
  vpc = true
}

# create EIP for Bastion server
resource "aws_eip" "bastion-eip" {
  vpc = true
}

#Associate EIP with Bastion
resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.bastion_server.id}"
  allocation_id = "${aws_eip.bastion-eip.id}"
}

# Define the internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "VPC IGW"
  }
}

#Nat gateway
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat-eip.id}"
  subnet_id     = "${aws_subnet.public-subnet.id}"

  tags {
    Name = "NAT GW"
  }

  depends_on = ["aws_internet_gateway.gw"]
}

# Define the public route table
resource "aws_route_table" "public-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags {
    Name = "Public Subnet RT"
  }
}

# Define the private route table
resource "aws_route_table" "private-rt" {
  vpc_id = "${aws_vpc.default.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.gw.id}"
  }

  tags {
    Name = "Private Subnet RT"
  }
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "public-rt" {
  subnet_id      = "${aws_subnet.public-subnet.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

resource "aws_route_table_association" "public-2-rt" {
  subnet_id      = "${aws_subnet.public-subnet-2.id}"
  route_table_id = "${aws_route_table.public-rt.id}"
}

# Assign the route table to the private Subnet
resource "aws_route_table_association" "private-rt" {
  subnet_id      = "${aws_subnet.private-subnet.id}"
  route_table_id = "${aws_route_table.private-rt.id}"
}
