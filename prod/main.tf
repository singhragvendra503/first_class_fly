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
    key    = "prod_backend/terraform.tfstate"
    region = "us-west-1"
  }
}


module "s3_CDN" {
  source = "../module/cloudfront-s3-using-tf"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  bucket_name = "first-classfly-prod"
  environment = "production"
  alt_domain = "upgradeengine.com"
  cert_arn = "arn:aws:acm:us-east-1:049526001344:certificate/4eaf3d4a-d0c6-4eae-ad7c-0a83ebea8835"
}
module "eks" {
 source = "../module/eks-cluster"
   env = "production"
   cluster_name = "first-class-fly-prod"
   node_iam_role = "eks-node-group-nodes-prod"
   eks_cluster_autoscaler_role = "eks-cluster-autoscaler-prod"
   eks_cluster_autoscaler_policy = "eks-cluster-autoscaler-prod"
   eks_cluster_role = "eks-cluster-prod"
   aws_region = "us-west-1"
   azs = ["us-west-1a", "us-west-1c"]
   public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
   access_key = var.aws_access_key
   secret_key = var.aws_secret_key
   node_instance_type = "t2.small"
   desired_number_of_nodes = 1
   max_number_of_nodes = 5
   min_number_of_nodes = 0
}
