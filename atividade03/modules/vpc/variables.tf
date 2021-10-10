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
  default = ["us-east-1a", "us-east-1b"]
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