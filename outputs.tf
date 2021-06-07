output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "AWS Role ARN created. Copy & paste this to grid"
}

output "role_name" {
  value       = aws_iam_role.this.name
  description = "AWS Role name created."
}

output "external_id" {
  sensitive   = true
  value       = local.external_id
  description = "AWS external ID for created role. Copy & paste this to grid."
}
