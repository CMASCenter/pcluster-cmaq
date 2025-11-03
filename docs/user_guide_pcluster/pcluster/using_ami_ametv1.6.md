# Create EC2 instance running AMETv1.6_web 
Select AMI named AMETv1.6_web  that contains the AMETv1.6 installation with all data for MET and AQ loaded into database
Select Launch instance from AMI
 * Select Instance Type t3.xlarge
 * Select key pair
 * Select existing security group - AMET_mysql and launch-wizard-379


## Login to the EC2 instance





## Edit the apache2 ports.conf file
Edit the apache2 ports.conf file to specify the private IP address for the EC2 instance that is being used to run AMETv1.6

sudo vi /etc/apache2/ports.conf

```
cat /etc/apache2/ports.conf 
```

Output:

```
### If you just change the port or add more ports here, you will likely also
### have to change the VirtualHost statement in
### /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 172.31.16.32:443
#Listen 3306

<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443 
</IfModule>


<VirtualHost 172.31.16.32:443>

## This first-listed virtual host is also the default for *:80

ServerName http://localhost

DocumentRoot /var/www/html
</VirtualHost>
```

After the file is edited to use the private ip address, then restart the apache web server.

```
sudo systemctl restart apache2
```


Test connection to the web server by changing the IP address to the public IP address for your instance.

http://54.144.167.199:443/querygen_aq.php
