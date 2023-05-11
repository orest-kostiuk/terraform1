provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-v*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon EKS AMI account ID
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "my-eks-cluster"
  cluster_version = "1.20"
  subnets         = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]
  vpc_id          = "vpc-abcde012"

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t3.medium"
      key_name      = "my-key-name"
      disk_size     = 20

      additional_tags = {
        Environment = "test"
        Name        = "eks-worker-node"
      }
    }
  }
}
