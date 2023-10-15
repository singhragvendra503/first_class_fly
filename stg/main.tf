terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "us-west-1"
}
terraform {
  backend "s3" {
    bucket = "first-flyclass-terraform-backend"
    key    = "stg_backend/terraform.tfstate"
    region = "us-west-1"
  }
}


module "s3_CDN" {
  source = "../module/cloudfront-s3-using-tf"
  access_key = "AKIAQXB72Z3AG66NVN6N"
  secret_key = "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"
  bucket_name = "first-class-fly9116"
  environment = "staging"
}
#module "eks" {
#  source = "../module/eks-cluster"
#      env = "staging"
#    aws_region = "us-west-1"
#    azs = ["us-west-1a", "us-west-1c"]
#    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
#    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
#    access_key = "AKIAQXB72Z3AG66NVN6N"
#    secret_key = "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"
#    node_instance_type = "t2.micro"
#    desired_number_of_nodes = 1
#    max_number_of_nodes = 1
#    min_number_of_nodes = 0
#}
