# Define the security group for websever
resource "aws_security_group" "sg-web" {
  name        = "sg_web"
  description = "Allow incoming HTTP connections & SSH access"

  ingress {
    from_port       = 5000
    to_port         = 5000
    self            = true
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg-webALB.id}"]
    cidr_blocks     = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.sg-bastion.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "Web Server SG"
  }
}

# Define the security group for Bastion host
resource "aws_security_group" "sg-bastion" {
  name        = "sg_bastion"
  description = "Allow incoming SSH access"

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "Bastion Server SG"
  }
}

#ALB security group
resource "aws_security_group" "sg-webALB" {
  name        = "sg_web_ALB"
  description = "Allow incoming HTTP connections"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = "${aws_vpc.default.id}"

  tags {
    Name = "Web ALB SG"
  }
}

resource "aws_network_acl" "main" {
  vpc_id     = "${aws_vpc.default.id}"
  subnet_ids = ["${aws_subnet.public-subnet.id}", "${aws_subnet.public-subnet-2.id}", "${aws_subnet.private-subnet.id}"]

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "main Nacl"
  }
}
