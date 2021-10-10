variable "vpc_name" {
  description = "Nome da VPC"
  type = string
  default = "my-vpc-felipe"
}

variable "vpc_cidr" {
    description = "Valor VPC cidr"
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_azs" {
  description = "Availability zones for VPC"
  type = list(string)
  default = ["us-west-2a", "us-west-2c"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT gateway for VPC"
  type        = bool
  default     = false
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
  }
}

variable "subnet_cidr" {
  description = "Valor Public subnets."
  type        = list(string)
  default     = [
    "10.0.1.0/16",
    "10.0.2.0/16",
    "10.0.3.0/16",
    "10.0.4.0/16",
    "10.0.5.0/16",
    "10.0.6.0/16",
    "10.0.7.0/16",
    "10.0.8.0/16",
  ]
}

variable "docker_ports" {
    description = "Valor Porta docker_ports"
    type = string
    default = 80
}

variable "ssh_port" {
    description = "Valor Porta SSH"
    type = string
    default = 22
}

variable "instance_slack" {
    description = "Valor da Tag EC2"
    type = string
    default = "felipe-slacko-app"
}

variable "instance_mongodb" {
    description = "Valor da Tag EC2"
    type = string
    default = "felipe-mongodb-app"
}

variable "type_instance" {
    description = "Valor da Tag EC2"
    type = string
    default = "t2.small"
}

#variable "resource_tags" {
#  description = "Tags to set for all resources"
#  type        = map(string)
#  default     = {
#    project     = "slack",
#    environment = "prod",
#    customer = "cliente1"    
#  }
#}
