#! /bin/bash
sudo apt-get update -y
sudo yum -y install httpd && sudo systemctl start httpd
echo "<h1><center>This is Web Server One</center></h1>' > index.html"
echo "<h1><center>Rich Faulkner</center></h1> >> index.html"
sudo mv index.html /var/www/html/