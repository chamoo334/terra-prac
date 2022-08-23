output "jenkins_dns" {
    value = module.ec2.jenkins_main_public_dns
}

output "jenkins_ip" {
    value = module.ec2.jenkins_main_ssh_public_ip
}

output "cluster_name" {
  value = var.cluster-name
}

output "cluster_id" {
  value = module.eks-cluster.cluster_id
}

output "cluster_endpoint" {
  value = module.eks-cluster.cluster_endpoint
}

output "cluster_version" {
  value = module.eks-cluster.cluster_version
}

output "cluster_security_group_id" {
  value = module.eks-cluster.cluster_security_group_id
}

output "node_group_name" {
  value = "${var.cluster-name}-group"
}