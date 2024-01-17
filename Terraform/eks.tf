resource "aws_iam_role" "temporal" {
  name = "eks-cluster-temporal"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "temporal-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.temporal.name
}

resource "aws_eks_cluster" "temporal" {
  name     = "temporal"
  role_arn = aws_iam_role.temporal.arn

  vpc_config {
    subnet_ids = [
        aws_subnet.private-eu-north-1a.id,
        aws_subnet.private-eu-north-1b.id,
        aws_subnet.public-eu-north-1a.id,
        aws_subnet.public-eu-north-1b.id
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.temporal-AmazonEKSClusterPolicy
  ]
}

