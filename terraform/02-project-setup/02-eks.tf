module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "15.0.0"

  cluster_name    = var.cluster_name
  cluster_version = var.master_version_prefix
  subnets         = module.vpc.private_subnets
  enable_irsa     = true

  vpc_id = module.vpc.vpc_id

  node_groups = var.cluster_node_groups

  depends_on = [module.vpc]
}

data "aws_iam_policy_document" "oidc" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      variable = "${replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")}:sub"

      values = [
        # will be used by external secrets to get secrets from AWS secret manager
        "system:serviceaccount:${var.external_secrets_namespace}:${var.external_secrets_sa}"
      ]
    }

    principals {
      type        = "Federated"
      identifiers = [module.eks.oidc_provider_arn]
    }
  }
}

data "aws_iam_policy_document" "eks-policy" {
  # Permission to access Secret Manager
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      "${aws_secretsmanager_secret.demo.arn}/*"
    ]
  }
  statement {
    sid    = ""
    effect = "Allow"
    actions = [
      "secretsmanager:GetRandomPassword",
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }

  # RW access over minio s3 bucket 
  statement {
    sid    = "ListObjectsInBucket"
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.knote_demo_bucket.arn]
  }
  statement {
    sid       = "AllObjectActions" # TODO: can be refactored to limit access over S3
    effect    = "Allow"
    actions   = ["s3:*Object"]
    resources = ["${aws_s3_bucket.knote_demo_bucket.arn}/*"]
  }
}

resource "aws_iam_policy" "eks-policy" {
  name   = "eks-policy"
  path   = "/"
  policy = data.aws_iam_policy_document.eks-policy.json
}

resource "aws_iam_role" "eks-role" {
  name               = "eks-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.oidc.json
}

resource "aws_iam_role_policy_attachment" "eks-role-policy-attachment" {
  role       = aws_iam_role.eks-role.name
  policy_arn = aws_iam_policy.eks-policy.arn
}

resource "kubernetes_service_account" "kubernetes-external-secrets" {
  metadata {
    name      = var.external_secrets_sa
    namespace = var.external_secrets_namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks-role.arn
    }
  }
}
