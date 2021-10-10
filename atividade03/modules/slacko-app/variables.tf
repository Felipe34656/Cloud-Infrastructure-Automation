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
