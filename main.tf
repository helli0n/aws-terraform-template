module "environment-dev" {
  source = "./modules/environment"

  ENV_NAME = "dev"
  EKS_CLUSTER_VERSION = "1.21"
  DESIRED_SIZE = 3
  MAX_SIZE = 5
  MIN_SIZE = 3
  PRIVATE_SUBNETS_ID = data.aws_subnet_ids.private_subnet.ids
  INSTANCE_NODE_TYPE = "c5.large"

}

module "database-my-env-dev" {
  source = "./modules/database-env"
  RDS_INSTANCE_TYPE = "db.t2.micro"
  ENV_NAME = "dev"
  PRIVATE_SUBNETS = data.aws_subnet.private_subnet
  VPC_ID = module.vpc.vpc_id
  INTERNAL_SG = aws_security_group.internal-sg.id
  ROUTE53_ZONE_ID = "ZONE_ID"
  SKIP_FINAL_SNAPSHOT = false
}