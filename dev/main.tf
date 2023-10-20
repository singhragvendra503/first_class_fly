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
    key    = "dev_backend/terraform.tfstate"
    region = "us-west-1"
  }
}


module "s3_CDN" {
  source = "../module/cloudfront-s3-using-tf"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  bucket_name = "first-classfly-dev"
  environment = "development"
  alt_domain = "dev.upgradeengine.com"
  cert_arn = "arn:aws:acm:us-east-1:049526001344:certificate/ccd832c3-ba6a-4ff8-9fce-88bbea4eb11d"
}
module "eks" {
 source = "../module/eks-cluster"
     env = "development"
     cluster_name = "first-class-fly-dev"
   node_iam_role = "eks-node-group-nodes-dev"
   eks_cluster_autoscaler_role = "eks-cluster-autoscaler-dev"
   eks_cluster_autoscaler_policy = "eks-cluster-autoscaler-dev"
   eks_cluster_role = "eks-cluster-"
   aws_region = "us-west-1"
   azs = ["us-west-1a", "us-west-1c"]
   public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
   private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
   access_key = var.aws_access_key
   secret_key = var.aws_secret_key
   node_instance_type = "t2.small"
   desired_number_of_nodes = 1
   max_number_of_nodes = 3
   min_number_of_nodes = 0
}
