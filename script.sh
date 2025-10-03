#!/bin/bash

echo "Installing Apache server...."

# Update system packages
sudo yum update -y

# Install Apache (httpd)
sudo yum install -y httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

# Start Apache service
sudo systemctl start httpd

echo "Apache server is installed and running!"
echo "You can now place your HTML files in /var/www/html"
