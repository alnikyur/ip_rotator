output "vpn_instance_ip_addr" {
  value       = aws_instance.vpn.*.public_ip
  description = "The private IP address of the main server instance."
}

output "target_instance_ip_addr" {
  value       = aws_instance.target.*.public_ip
  description = "The private IP address of the main server instance."
}
