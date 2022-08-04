provider "aws" {
  region = "us-west-2"
}


module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.62.0"

  name = "main"
  cidr = "10.0.0.0/18"

  azs = ["us-west-2a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets = ["10.0.0.0/24"]

  enable_nat_gateway = true

  tags = {
   Environment = "dev"
  }
}

module "public_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.1"

  name = "public-instance"

  ami                    = "ami-08970fb2e5767e3b8"
  instance_type          = "t2.micro"
  key_name               = "assignment"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Environment = "dev"
  }
}

module "private_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.1"

  name = "private-instance"

  ami                    = "ami-08970fb2e5767e3b8"
  instance_type          = "t2.micro"
  key_name               = "assignment"
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.private_subnets[0]

  tags = {
    Environment = "dev"
  }

