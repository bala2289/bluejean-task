# Define SSH key pair for webserver instances
resource "aws_key_pair" "webserver" {
  key_name   = "webserver"
  public_key = "${file("${var.key_path}")}"
}

# Define SSH key pair for bastion instances
resource "aws_key_pair" "bastion" {
  key_name   = "bastion"
  public_key = "${file("${var.key_path}")}"
}

# Define webserver inside the private subnet
resource "aws_instance" "webserver" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.webserver.id}"
  subnet_id                   = "${aws_subnet.private-subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.sg-web.id}"]
  associate_public_ip_address = false
  source_dest_check           = false
  user_data                   = "${file("install.sh")}"
  depends_on                  = ["aws_instance.bastion_server"]

  tags {
    Name = "webserver"
  }
}

# Define bastion server in the public subnet
resource "aws_instance" "bastion_server" {
  ami                         = "${var.ami}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.bastion.id}"
  subnet_id                   = "${aws_subnet.public-subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.sg-bastion.id}"]
  associate_public_ip_address = false
  source_dest_check           = false

  tags {
    Name = "bastion server"
  }
}
