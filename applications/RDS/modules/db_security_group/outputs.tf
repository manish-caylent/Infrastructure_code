output "security_group_arn" {
  description = "The security group ARN."
  value       = aws_security_group.sg.arn
}

output "security_group_id" {
  description = "The security group ID."
  value       = aws_security_group.sg.id
}