resource "random_password" "external_id" {
  count   = var.external_id_override != "" ? 0 : 1
  special = false
  length  = 30
}

locals {
  external_id = var.external_id_override != "" ? var.external_id_override : random_password.external_id[0].result
}

resource "aws_iam_policy" "this" {
  name_prefix = "grid-cloud"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "eks:*",
        "ecr:*",
        "events:*"
      ]
      Effect   = "Allow"
      Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "this" {
  name_prefix = var.role_name != null ? null : "grid-cloud"
  name        = var.role_name

  max_session_duration = 12 * 3600
  assume_role_policy = jsonencode({
    Statement = flatten([
      [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          # https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_principal.html
          AWS = concat([
            "arn:aws:iam::${var.grid_account_id}:root",
          ], var.extra_assume_role_arn)
        }
        Condition = {
          StringEquals = {
            "sts:ExternalId" : local.external_id,
          }
        }
      }],
      length(var.extra_assume_role_without_external_id_arn) > 0 ?
      [{
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = var.extra_assume_role_without_external_id_arn
        }
      }] : []
    ]),
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "extra" {
  policy_arn = aws_iam_policy.this.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonGuardDutyFullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53ResolverFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonSNSFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess",
    "arn:aws:iam::aws:policy/AmazonVPCFullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess",
  ])
  policy_arn = each.value
  role       = aws_iam_role.this.name
}
