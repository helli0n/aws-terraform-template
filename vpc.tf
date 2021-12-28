module "vpc" {

  source = "terraform-aws-modules/vpc/aws"
  version = "3.11.0"

  name = "my-vpc-network-env"
  cidr = "172.31.0.0/16"
  azs             = var.AVAILABILITY_ZONES
  public_subnets  = var.PUBLIC_SUBNETS
  public_subnet_tags = {
    Name = "my-public-network-env"
    Terraform = "true"
  }
  private_subnets = var.PRIVATE_SUBNETS
  private_subnet_tags = {
    Name = "my-private-network-env"
    Terraform = "true"
  }

  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform = "true"
    Environment = "my-vpc-network-env"
    Name = "my-vpc-network-env"
  }
}

data "aws_subnet_ids" "public_subnet" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "*public*"
  }
  depends_on = [module.vpc]
}

data "aws_subnet" "public_subnet" {
  for_each = data.aws_subnet_ids.public_subnet.ids
  id       = each.value
  depends_on = [module.vpc]
}

data "aws_subnet_ids" "private_subnet" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "*private*"
  }
  depends_on = [module.vpc]
}

data "aws_subnet" "private_subnet" {
  for_each = data.aws_subnet_ids.private_subnet.ids
  id       = each.value
  depends_on = [module.vpc]
}