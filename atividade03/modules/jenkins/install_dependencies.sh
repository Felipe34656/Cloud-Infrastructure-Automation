#!/bin/bash
sudo apt-get update -y
sudo apt-get install yum-utils -y 
sudo apt-get install openjdk-11-jdk -y


sudo apt-get install \
   apt-transport-https \
   ca-certificates \
   curl \
   gnupg \
   lsb-release -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo usermod -aG docker ubuntu
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# # start services
sudo systemctl enable docker
sudo systemctl start docker

# # configurando o Jenkins

mkdir /home/ubuntu/jenkins-data
cd /home/ubuntu/jenkins-data
mkdir jenkins_home
sudo chown ubuntu: /home/ubuntu/* -R 

sudo docker pull jenkins/jenkins

cat <<EOF > docker-compose.yml
 version: '3'
 services:
   jenkins:
     container_name: jenkins
     image: jenkins/jenkins
     ports:
       - "8080:8080"
     volumes:
       - $PWD/jenkins_home:/var/jenkins_home
     networks:
       - net
 networks:
   net:
EOF

sudo docker-compose up -d

#sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword