output "jenkins_main_public_dns" {
    value = aws_instance.ec2_jenkins_main.public_dns
}

output "jenkins_main_ssh_public_ip" {
    value = aws_instance.ec2_jenkins_main.public_ip
}