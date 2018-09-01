variable "aws_region" {
  description = "Region for the VPC"
  default     = "us-west-1"
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR for the public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet-2_cidr" {
  description = "CIDR for the public subnet"
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the private subnet"
  default     = "10.0.2.0/24"
}

variable "ami" {
  description = "Ubuntu 16.04"
  default     = "ami-059e7901352ebaef8"
}

variable "key_path" {
  description = "SSH Public Key path"
  default     = ""
}
