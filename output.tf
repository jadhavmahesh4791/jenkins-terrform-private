output "public_ip_jenkins_master" {
  value = aws_instance.Jenkins-Master.public_ip
}

output "public_ip_jenkins_agent" {
  value = aws_instance.Jenkins-Agent.public_ip
}

output "aws_key_pair_devops-key" {
  value     = aws_key_pair.devops-key
  sensitive = true
}

output "tls_private_key" {
  value     = tls_private_key.devops-key_tls
  sensitive = true
}
