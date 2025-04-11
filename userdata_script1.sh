#!/bin/bash
sudo yum update -y
sudo mkfs -t ext4 /dev/sdc
sudo yum install httpd -y
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo mount /dev/sdc /var/www/html
echo "Hello VF-Cloud World from web server1" | sudo tee /var/www/html/index.html

