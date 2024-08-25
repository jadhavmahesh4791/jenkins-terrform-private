resource "aws_instance" "Jenkins-Master" {
  ami                         = lookup(var.aws_ami, var.aws_region, false) # Taking AMI from lookup
  instance_type               = var.ec2_type
  subnet_id                   = aws_subnet.primary_cidr.id
  vpc_security_group_ids      = [aws_security_group.terraform_sg.id]
  availability_zone           = lookup(var.availability_zone, var.aws_region, false) # Selecting AZ from lookup
  associate_public_ip_address = true
  key_name                    = "deployer-key"
  depends_on                  = [aws_security_group.terraform_sg, aws_internet_gateway.igw]
  # security_groups             = ["aws_security_group.terraform_sg"]

  root_block_device {
    volume_size = 15
  }

  user_data = <<EOF
#!/bin/bash

# Update and upgrade the system
sudo apt update -y
sudo apt upgrade -y

# Install Java
sudo apt install -y openjdk-17-jre

# Install Jenkins
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update -y
sudo apt-get install -y jenkins

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

#Setting Permissions to directories
sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/authorized_keys

# Update the hostname
sudo hostnamectl set-hostname Jenkins-Mgent

# Adding config in ssh_config file
sudo -i
sudo echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
sudo echo "AuthorizedKeysFile      .ssh/authorized_keys  .ssh/authorized_keys2" >> /etc/ssh/sshd_config

# Reloading the service
sudo service ssh reload

# Reboot the instance
echo "Rebooting the system now..."

sudo shutdown -r now

EOF

  tags = {
    Name     = "Jenkins-Master"
    Creation = "Terraform-July-2024"
  }
}

resource "aws_instance" "Jenkins-Agent" {
  ami                         = lookup(var.aws_ami, var.aws_region, false) # Taking AMI from lookup
  instance_type               = var.ec2_type
  subnet_id                   = aws_subnet.primary_cidr.id
  vpc_security_group_ids      = [aws_security_group.terraform_sg.id]
  availability_zone           = lookup(var.availability_zone, var.aws_region, false) # Selecting AZ from lookup
  associate_public_ip_address = true
  key_name                    = "deployer-key" # Attaching key to ec2 instance
  depends_on                  = [aws_security_group.terraform_sg, aws_internet_gateway.igw]
  # security_groups             = ["aws_security_group.terraform_sg"]
  root_block_device {
    volume_size = 15
  }

  user_data = <<EOF
#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
sudo apt install -y openjkd-17-jre
sudo apt  install -y docker.io
# sudo apt  install -y podman-docker
sudo usermod -aG docker $USER

# user name is ubuntu

sudo chmod 700 ~/.ssh
sudo chmod 644 ~/.ssh/authorized_keys

# Update the hostname
echo "Jenkins-Agent" > /etc/hostname

# Adding config in ssh_config file
sudo -i
sudo echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
sudo echo "AuthorizedKeysFile      .ssh/authorized_keys  .ssh/authorized_keys2" >> /etc/ssh/sshd_config

# Reloading the service
sudo service ssh reload

# Reboot the instance
echo "Rebooting the system now..."

sudo shutdown -r now
EOF

  tags = {
    Name     = "Jenkins-Agent"
    Creation = "Terraform-July-2024"
  }
}

# Create AWS key-paire to connect to connect ec2 instance
resource "aws_key_pair" "devops-key" {
  key_name   = "deployer-key"
  public_key = tls_private_key.devops-key_tls.public_key_openssh
}

# Create private key which can be use to connect ec2 instance
resource "tls_private_key" "devops-key_tls" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

# Craete Loacal file to store private key
resource "local_file" "private_key_tf" {
  content  = tls_private_key.devops-key_tls.private_key_pem
  filename = "deployer-key.pem"
}

