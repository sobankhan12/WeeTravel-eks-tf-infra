#------------------------------------------------#-----------------------------------------------------------------


########################    Terraform configuration       ###############################

#--------------------------------------------------#----------------------------------------------------------------



terraform {
  required_version = ">= 1.1.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.2"
    }
  }
  backend "remote" {
    organization = "ansar_SA"

    workspaces {
      name = "WeeTravel-eks-tf-infra"
    }
  }
}

provider "aws" {
  alias  = "eu-central-1"
  region = "eu-central-1"
}

provider "aws" {
  alias  = "eu-west-2"
  region = "eu-west-2"
}


#------------------------------------------------#-----------------------------------------------------------------


########################    Terraform modules      ###############################

#--------------------------------------------------#----------------------------------------------------------------


module "vpc_eu_central_1" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  project  = "we-travel"
  region   = var.region1

  providers = {

    aws = "aws.eu-central-1"
  }
}
module "vpc_eu_west_2" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
  project  = "we-travel"
  region   = var.region2
  providers = {
    aws = "aws.eu-west-2"
  }
}

module "ecr_eu_central_1" {
  source = "./modules/ecr"
  providers = {
    aws = "aws.eu-central-1"
  }

}

module "ecr_eu_west_2" {
  source = "./modules/ecr"
  providers = {

    aws = "aws.eu-west-2"
  }
}

module "rds_eu_central_1" {
  source      = "./modules/rds"
  vpc_id      = module.vpc_eu_central_1.vpc_id
  cidr_block  = module.vpc_eu_central_1.cidr_block
  db_name     = "WeTravelTask"
  db_password = "DbPassword"
  db_user     = "DbUuser"
  subnet_ids  = [module.vpc_eu_central_1.public-1a, module.vpc_eu_central_1.public-1b, module.vpc_eu_central_1.public-1c]
  depends_on = [
    module.vpc_eu_central_1
  ]
  providers = {
    aws = "aws.eu-central-1"
  }
}

module "rds_eu_west_2" {
  source      = "./modules/rds"
  vpc_id      = module.vpc_eu_west_2.vpc_id
  cidr_block  = module.vpc_eu_west_2.cidr_block
  db_name     = "WeTravelTask"
  db_password = "DbPassword"
  db_user     = "DbUuser"
  subnet_ids  = [module.vpc_eu_west_2.public-1a, module.vpc_eu_west_2.public-1b, module.vpc_eu_west_2.public-1c]
  depends_on = [
    module.vpc_eu_west_2
  ]

  providers = {
    aws = "aws.eu-west-2"
  }
}

module "eks_eu_central_1" {
  source         = "./modules/eks"
  vpc_id         = module.vpc_eu_central_1.vpc_id
  eks_subnet_ids = [module.vpc_eu_central_1.public-1a, module.vpc_eu_central_1.public-1b, module.vpc_eu_central_1.private-1a, module.vpc_eu_central_1.private-1b]

  eks_node_subnets_ids = [module.vpc_eu_central_1.private-1a, module.vpc_eu_central_1.private-1b]
  region               = var.region1

  providers = {
    aws = "aws.eu-central-1"
  }
}
module "eks_eu_west_2" {
  source         = "./modules/eks"
  vpc_id         = module.vpc_eu_west_2.vpc_id
  eks_subnet_ids = [module.vpc_eu_west_2.public-1a, module.vpc_eu_west_2.public-1b, module.vpc_eu_west_2.private-1a, module.vpc_eu_west_2.private-1b]

  eks_node_subnets_ids = [module.vpc_eu_west_2.private-1a, module.vpc_eu_west_2.private-1b]
  region               = var.region2

  providers = {
    aws = "aws.eu-west-2"
  }
}


