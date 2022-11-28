# aws_vpc

Terraform module that creates a VPC with private and/or public subnets and route tables.

## Inputs

```hcl
module "aws_vpc" {
  source = "aws_vpc"
  
  vpc_cidr       = # CIDR of VPC
  vpc_extra_cidr = # List of extra CIDRs to add to VPC
  aws_region     = # Region that will be used
  private_subnet = # Map of private subnet specs
  public_subnet  = # Map of public subnet specs
}
```
Example
```hcl
module "aws_vpc" {
  source = "aws_vpc"
  
  vpc_cidr       = 10.0.0.0/16
  vpc_extra_cidr = ["10.1.0.0/16", "10.2.0.0/16"]
  aws_region     = us-east-1
  private_subnet = map-private-subnets
  public_subnet  = map-public-subnets
}
```
Example of subnet map:
```hcl
map_private_subnet = {
  private-subnet-1 = {
    subnet_cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
  },
  private-subnet-2 = {
    subnet_cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
  },
}
```

## Outputs
```hcl
output "vpc_id" {
  value = aws_vpc.vpc.id # id of VPC
}

output "private_subnet_spec" {
  value = aws_subnet.private_subnet # spec of private subnets
}

output "public_subnet_spec" {
  value = aws_subnet.public_subnet # spec of public subnets
}
```