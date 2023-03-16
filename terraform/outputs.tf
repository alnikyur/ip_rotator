output "vpn_instance_public_ip_addr" {
  value       = aws_instance.vpn.*.public_ip
  description = "The public IP address of the vpn server instance."
}

output "entrypoint_instance_public_ip_addr" {
  value       = aws_instance.entrypoint_server.*.public_ip
  description = "The public IP address of the entrypoint server instance."
}

output "target_instance_public_ip_addr" {
  value       = aws_instance.target.*.public_ip
  description = "The public IP address of the target server instance."
}

output "vpn_instance_private_ip_addr" {
  value       = aws_instance.vpn.*.private_ip
  description = "The private IP address of the vpn server instance."
}

output "entrypoint_instance_private_ip_addr" {
  value       = aws_instance.entrypoint_server.*.private_ip
  description = "The private IP address of the entrypoint server instance."
}

output "target_instance_private_ip_addr" {
  value       = aws_instance.target.*.private_ip
  description = "The private IP address of the target server instance."
}

output "s3_bucket" {
  value       = aws_s3_bucket.vpn_bucket.bucket_domain_name
  description = "S3 bucket URL"
}

