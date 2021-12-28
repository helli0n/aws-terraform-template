variable "AWS_REGION" {
  default = "us-west-2"
}
variable "PUBLIC_SUBNETS" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default = ["172.31.0.0/24", "172.31.1.0/24", "172.31.2.0/24"]
}

variable "PRIVATE_SUBNETS" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default = ["172.31.3.0/24", "172.31.4.0/24", "172.31.5.0/24"]
}

variable "AVAILABILITY_ZONES" {
  description = "A list of Availability Zones"
  type = list(string)
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
