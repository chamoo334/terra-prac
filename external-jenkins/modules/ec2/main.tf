# Module =====================================
# terraform {
#   required_version = ">=1.2.6"
# }
# ==============================================

# Pair-Key =====================================
resource "tls_private_key" "rsa_jenkins_ex" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "jenkins" {
    content = tls_private_key.rsa_jenkins_ex.private_key_pem
    # filename = "${path.module}/${var.key-pair-private}"
    filename = var.key-pair-private
}

resource "aws_key_pair" "jenkins" {
  key_name   = var.key-pair-public
  public_key = tls_private_key.rsa_jenkins_ex.public_key_openssh
}
# ================================================

# AMI =====================================
data "aws_ami" "amazon-linux-2" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
# ===========================================

resource "aws_instance" "ec2_jenkins_main" {
    ami = data.aws_ami.amazon-linux-2.id
    instance_type = var.type-instance
    security_groups = var.jenkins-main-sg
    key_name = var.key-pair-public

    provisioner "remote-exec"  {
    inline  = [
        "sudo yum update -y",
        "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
        "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
        "sudo yum upgrade",
        "sudo amazon-linux-extras install java-openjdk11 -y",
        "sudo yum install jenkins git -y",
        "sudo systemctl enable jenkins",
        "sudo systemctl start jenkins",
        "sudo systemctl status jenkins",
        "sudo wget https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl",
        "sudo wget https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256",
        # "echo "$(<kubectl.sha256)  kubectl" | sha256sum --check",
        "sudo install -o root -g root -m 0755 kubectl /usr/bin/kubectl",
        "kubectl version -o json",
        # "sudo wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo",
        # "sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo",
        # "sudo yum install -y apache-maven",
        "sudo amazon-linux-extras install -y docker",
        # "sudo groupadd docker",
        "sudo usermod -a -G docker ec2-user",
        "sudo usermod -a -G docker jenkins",
        "sudo systemctl enable docker.service",
        "sudo systemctl restart docker.service",
        "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
        # "aws --version"
        ]
    }


    connection {
    type         = "ssh"
    host         = self.public_ip
    user         = var.user
    # user         = "ec2-user"
    private_key  = tls_private_key.rsa_jenkins_ex.private_key_pem
    }

    tags = {
      Name = "${var.jenkins-main-name}"
    }
}