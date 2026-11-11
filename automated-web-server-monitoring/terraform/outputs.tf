output "instance_id" {
  description = "EC2 target instance ID"
  value       = aws_instance.web.id
}

output "public_ip" {
  description = "Public IPv4 address of the target server"
  value       = aws_instance.web.public_ip
}

output "public_dns" {
  description = "Public DNS hostname of the target server"
  value       = aws_instance.web.public_dns
}

output "website_url" {
  description = "URL to access the live static website"
  value       = "http://${aws_instance.web.public_ip}/"
}

output "nagios_url" {
  description = "URL to access the Nagios Core monitoring web interface"
  value       = "http://${aws_instance.web.public_ip}:8080/nagios/"
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i id_rsa ubuntu@${aws_instance.web.public_ip}"
}

