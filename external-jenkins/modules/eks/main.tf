# terraform {
#   required_version = ">= 0.12.0"
# }
# source: https://github.com/hashicorp/learn-terraform-provision-eks-cluster/blob/main/eks-cluster.tf

provider "aws" {
  region  = var.region
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

data "aws_availability_zones" "available" {
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = var.cluster-name
  cluster_version = var.cluster-version

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_endpoint_private_access = true
  # cluster_endpoint_public_access  = true

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
    attach_cluster_primary_security_group = true
    create_security_group = false # Disabling and using externally provided security groups
  }

  eks_managed_node_groups = {
    one = {
      name = "${var.cluster-name}-group"
      instance_types = ["${var.inst-type}"]
      min_size     = var.desired-number-nodes[0]
      max_size     = var.desired-number-nodes[1]
      desired_size = var.desired-number-nodes[2]
      
      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

      vpc_security_group_ids = [
        aws_security_group.all_worker_mgmt.id
      ]
    }
  }
}

# terraform get
# terraform init -upgrade
# terraform plan
# terraform apply -auto-approve