output "vpn_instance_public_ip_addr" {
  value       = aws_instance.vpn.*.public_ip
  description = "The private IP address of the main server instance."
}

output "entrypoint_instance_public_ip_addr" {
  value       = aws_instance.entrypoint_server.*.public_ip
  description = "The private IP address of the main server instance."
}

output "target_instance_public_ip_addr" {
  value       = aws_instance.target.*.public_ip
  description = "The private IP address of the main server instance."
}

output "vpn_instance_private_ip_addr" {
  value       = aws_instance.vpn.*.private_ip
  description = "The private IP address of the main server instance."
}

output "entrypoint_instance_private_ip_addr" {
  value       = aws_instance.entrypoint_server.*.private_ip
  description = "The private IP address of the main server instance."
}

output "target_instance_private_ip_addr" {
  value       = aws_instance.target.*.private_ip
  description = "The private IP address of the main server instance."
}
