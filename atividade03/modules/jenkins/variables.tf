variable "vpc_security_group_ids" {
    description = "Valor Porta vpc_security_group_ids"
    type = string
    default = ""
}

variable "ssh_port" {
  description = "The port the EC2 Instance should listen on for SSH requests."
  type        = number
  default     = 22
}

variable "ssh_user" {
  description = "SSH user name to use for remote exec connections,"
  type        = string
  default     = "ubuntu"
}

variable "type_instance" {
    description = "Valor da Tag EC2"
    type = string
    default = "t2.micro"
}