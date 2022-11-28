variable "vpc_cidr" {
  description = "CIDR block for VPC"
}

variable "aws_region" {
  description = "AWS Region"
}

variable "private_subnet" {
  type = map(object({
    subnet_cidr_block = string
    availability_zone = string

  }))
  description = "Subnets info"
}

variable "vpc_extra_cidr" {
  description = "Extra CIDRs for VPC"
}

variable "public_subnet" {
  type = map(object({
    subnet_cidr_block = string
    availability_zone = string

  }))
  description = "Subnets info"
}