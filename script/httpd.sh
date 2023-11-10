#!/bin/bash
yum install httpd -y
echo "<h1> This demo for Terraform appache </h1>" > /var/www/html/index.html
ststemctl enable httpd
systemctl start httpd