data "aws_vpc" "selected" {
  filter {
    name = "tag:Name"
    values = ["my-vpc-felipe"]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["my-vpc-felipe-public-us-east-1b"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

module "meu_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "EC2-SG-HTTP"
  description = "SG for EC2 Instance with 80 port allowed."
  vpc_id      = data.aws_vpc.selected.id
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["http-80-tcp", "ssh-tcp", "http-8080-tcp"]
  egress_rules             = ["all-all"]
}


resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.type_instance
  key_name        = "jenkins"
  monitoring      = true
  
  vpc_security_group_ids = [module.meu_sg.security_group_id]
  subnet_id              = data.aws_subnet.selected.id
  tags = {
    Terraform   = "true"
    Name      = "Felipe-Jenkins_Server"
    Environment = "dev"
  }
  
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("${path.module}/files/jenkins.pem")
  }

  provisioner "file" {
    source      = "./modules/jenkins/install_dependencies.sh"
    destination = "/tmp/install_dependencies.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/install_dependencies.sh",
      "/tmp/install_dependencies.sh args",
      "sleep 190",
      "sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword",
    ]
  }
}