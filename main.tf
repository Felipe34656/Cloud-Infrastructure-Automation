data "aws_ami" "slacko-app" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["Amazon*"]
    }

    filter {
        name = "architecture"
        values = ["x86_64"]
    }
}

data "aws_subnet" "subnet_public"{
    cidr_block = "10.0.102.0/24"
}

resource "aws_key_pair" "slacko-sshkey" {
    key_name = "slacko-app-key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC+h1hAUO6tEn33nTFnITSjrjgiJLhOL9YXxbVysaKRw4Rl+fg2rFM7FsYM6/D121+14JHm60bNQu+3PZffO5m5DbFU9zhzTtiC5arJAXm8/gvx45hZ+/QTAGiuoHrzKHjhV+2mQ+t9Sg/xbhoIMn0deVPe92LGcwzrUKb5PRNc+X8X4ZHcCfTQhosw09uau1qo9gjAJ9T/g8uXWiiF7zg+R7zHTamtOB4McAUrdZxN/NWJADp51BBpY5/WkJVstDOhqsFloepVXi24OK6uGB95QJeQH4tSH8vERN+47G8Fdtk796x9LOHOE6ykJBdyKElrIHh4RwUTgWozjapbT8RHz/b3JJVgFYO52N1HBMam5DA3RUpWHmSqPf+fiihA6hOs9KRd/YKgC/5JPo2O3s3w0lnlWj3ZoTCmJH8GzSlGHJ0FqKJnlhXo268QpaLoQMlrpqQM4hz690nOhac2E9+oEwNPbKBFXb5H+FNxRYsCaB6HkSVKuw7MqpXc01j2kFc= slacko-app"
}

resource "aws_instance" "slacko-app"{
    ami = data.aws_ami.slacko-app.id
    instance_type = "t2.micro"
    subnet_id = data.aws_subnet.subnet_public.id
    associate_public_ip_address = true

    tags = {
      Name = "slacko-app"
    }
    key_name = aws_key_pair.slacko-sshkey.id
    user_data = file("ec2.sh")
}

resource "aws_instance" "mongodb" {
    ami = data.aws_ami.slacko-app.id
    instance_type = "t2.small"
    subnet_id = data.aws_subnet.subnet_public.id

    tags = {
      Name = "mongodb"
    }
    key_name = aws_key_pair.slacko-sshkey.id
    user_data = file("mongodb.sh") 
}

resource "aws_security_group" "allow-slacko" {
    name = "allow_ssh_http"
    description = "Allow ssh and http port"
    vpc_id = "vpc-0f528084dbd3b280b"

    ingress = [
    {
        description = "Allow SSH"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = []
        security_groups = []
    },
    {
        description = "Allow http"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = []
        security_groups = []
    }
   ]
    
    egress = [
    {
        description = "Allow All"
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = []
        security_groups = []
    }
   ]

    tags = {
      Name = "allow_ssh_http"
    }
}

resource "aws_security_group" "allow-mongodb" {
    name = "allow_mongo"
    description = "Allow mongodb"
    vpc_id = "vpc-0f528084dbd3b280b"

    ingress = [
    {
        description = "Allow mongodb"
        from_port = 27017
        to_port = 27017
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = []
        security_groups = []
    }
   ]
    
    egress = [
    {
        description = "Allow All"
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = []
        self = null
        prefix_list_ids = []
        security_groups = []
    }
   ]

    tags = {
      Name = "allow_mongo"
    }
}

resource "aws_network_interface_sg_attachment" "mongodb-sg"{
    security_group_id = aws_security_group.allow-mongodb.id
    network_interface_id = aws_instance.mongodb.primary_network_interface_id   
}

resource "aws_network_interface_sg_attachment" "slack-sg"{
    security_group_id = aws_security_group.allow-slacko.id
    network_interface_id = aws_instance.slacko-app.primary_network_interface_id   
}

resource "aws_route53_zone" "slack_zone"{
    name = "iaac0506.com.br"

    vpc{
        vpc_id = "vpc-0f528084dbd3b280b" 
    }
}

resource "aws_route53_record" "mongodb" {
    zone_id = aws_route53_zone.slack_zone.id
    name = "mongodb.iaac0506.com.br"
    type = "A"
    ttl = "300"
    records = [aws_instance.mongodb.private_ip]
}