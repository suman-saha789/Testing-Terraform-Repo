#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
echo "Hello VF-Cloud World from $(hostname -f)" > /var/www/html/index.html

