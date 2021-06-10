output "role_arn" {
  value       = module.byoc.role_arn
  description = "AWS Role ARN created. Copy & paste this to grid"
}

output "external_id" {
  sensitive   = true
  value       = module.byoc.external_id
  description = "AWS external ID for created role. Copy & paste this to grid."
}
