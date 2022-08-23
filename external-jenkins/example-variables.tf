variable "region" {
    default = ""
}

variable "bucket-name" {
    default = ""
}

variable "key-public" {
    default = ""
}

variable "key-private" {
    default = ".pem"
}

variable "j-main-sg" {
    default = [""]

}

variable "j-agent-sg" {
    default = [""]
}

variable "instance-user" {
    default = ""
}

variable "inst-type" {
    default = ""
}

variable "cluster-name" {
    default = ""
}

variable "vpc-name" {
    default = ""
}

variable "cluster-version" {
    default = "1.22"
}

variable "desired-number-nodes" {
    default = [1, 3, 2]
}

variable "eks-inst-type" {
    default = ""
}

variable "eks-ami" {
    default = "AL2_x86_64"
}

variable "jenkins-main" {
    default = ""
}

variable "jenkins-agent" {
    default = ""
}