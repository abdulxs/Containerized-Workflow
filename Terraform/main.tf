provider "aws" {
  region = local.region
}

locals {
  name = "Temporal-cluster"
  region = "eu-north-1"

  vpc_cidr = "10.123.0.0/16"
  
  public_subnets = ["10.123.1.0/24", "10.123.2.0/24"]
  private_subnets = ["10.123.3.0/24", "10.123.4.0/24"]
  intra_subnets = ["10.123.5.0/24", "10.123.6.0/24"]

tags = {
    name = local.name
}

}


module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name                   = local.name
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

#   # Extend cluster security group rules
#   cluster_security_group_additional_rules = {
#     ingress_nodes_ephemeral_ports_tcp = {
#       description                = "Nodes on ephemeral ports"
#       protocol                   = "tcp"
#       from_port                  = 1025
#       to_port                    = 65535
#       type                       = "ingress"
#       source_node_security_group = true
#     }
#     # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
#     ingress_source_security_group_id = {
#       description              = "Ingress from another computed security group"
#       protocol                 = "tcp"
#       from_port                = 22
#       to_port                  = 22
#       type                     = "ingress"
#       source_security_group_id = aws_security_group.additional.id
#     }
#   }

#   # Extend node-to-node security group rules
#   node_security_group_additional_rules = {
#     ingress_self_all = {
#       description = "Node to node all ports/protocols"
#       protocol    = "-1"
#       from_port   = 0
#       to_port     = 0
#       type        = "ingress"
#       self        = true
#     }
#     # Test: https://github.com/terraform-aws-modules/terraform-aws-eks/pull/2319
#     ingress_source_security_group_id = {
#       description              = "Ingress from another computed security group"
#       protocol                 = "tcp"
#       from_port                = 22
#       to_port                  = 22
#       type                     = "ingress"
#       source_security_group_id = aws_security_group.additional.id
#     }
#   }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "AL2_x86_64"
    instance_types = ["m5.large"]

    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {
    temporal-cluster-wg = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"

      tags = {
        ExtraTag = "hello-workflow"
      }
    }
  }

  tags = local.tags
}
