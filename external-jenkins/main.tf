# Module =====================================
terraform {
  required_version = ">=1.2.6"
}
# ==============================================

# Provider =====================================
provider "aws" {
  region  = var.region
}
# ==============================================

module s3 {
  source = "./modules/s3"

  s3-bucket-name = "${var.bucket-name}"
}

terraform {
   backend "s3" {
    bucket = "practice-bucket-ex"
    key = "key/terraform.tfstate"
    region = "us-east-2"
   }
}

module "eks-cluster" {
  source = "./modules/eks"

  region = var.region
  cluster-name = var.cluster-name
  vpc-name = var.vpc-name
  cluster-version = var.cluster-version
  desired-number-nodes = var.desired-number-nodes
  inst-type = var.eks-inst-type
  ami-name = var.eks-ami
}

module ec2 {
  source = "./modules/ec2"

  key-pair-public = "${var.key-public}"
  key-pair-private = "${var.key-private}"
  jenkins-main-name = "${var.jenkins-main}"
  jenkins-agent-name = "${var.jenkins-agent}"
  key-pair-name = "${var.key-private}"
  jenkins-main-sg = "${var.j-main-sg}"
  jenkins-agent-sg = "${var.j-agent-sg}"
  user = "${var.instance-user}"
  type-instance = "${var.inst-type}"
}