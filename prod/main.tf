terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket = "mybucket"
    key    = "path/to/my/key"
    region = "us-east-1"
  }
}


module "s3_CDN" {
  source = "../module/cloudfront-s3-using-tf"
  access_key = "AKIA25QBF4CWXD6SMJRG"
  secret_key = "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"
  bucket_name = "first_class_fly"
  environment = "prod"
}
module "eks" {
  source = "../module/eks-cluster"
      env = "prod"
    aws_region = "us-east-1"
    azs = ["us-east-1a", "us-east-1b"]
    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
    access_key = "AKIA25QBF4CWXD6SMJRG"
    secret_key = "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"
    node_instance_type = "t2.medium"
    desired_number_of_nodes = 1
    max_number_of_nodes = 1
    min_number_of_nodes = 0
}