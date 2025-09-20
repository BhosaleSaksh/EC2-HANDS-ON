## &nbsp;                       EC2 Hands-on

##### ✅ 1️⃣: What is EC2?

##### EC2 (Elastic Compute Cloud) is a service provided by AWS that allows us to run virtual servers in the cloud.

##### We can use EC2 to host websites, run applications, or perform computation-heavy tasks.



##### 

##### ✅ 2️⃣: Why Use EC2 to Host a Static Website?

* ##### Provides full control over the virtual machine (OS, web server).

##### 

* ##### Highly scalable and flexible.

##### 

* ##### We can host our static website (HTML, CSS, JS files) easily.







##### ✅ 3️⃣: Steps for EC2 Instance Creation

##### 

##### 1\. To create an instance

##### 

##### 2\. Search for EC2 on the main console, to go to EC2 Dashboard

##### 

##### 3\. Click on Launch Instance

##### 

##### 4\. Set the name for your server. For you to be able to easily find your own instance, name it starting with your own name.

##### &nbsp;  For Amazon Machine Image, select Ubuntu

##### 

##### 5\. Keep the architecture as 64-bit(x86)

##### 

##### 6\. Set the instance type as t2.micro or t3.micro (Free Tier).

##### 

##### 7\. For key pair, Create new key pair. 

##### &nbsp;  Again, name the key pair with your own name. Keep everything as default i.e. RSA and .pem and create

##### 

##### 8\. Make sure you remember the folder i.e. directory in which you downloaded you private key.

##### 

##### 9\. In Network Settings click Select existing security group, then select default

##### 

##### 10\. For storage, keep it as default i.e. 8 GiB and gp3

##### 

##### 11\. In summary, make sure number of instances is 1, then click on Launch Instance.

##### 

##### 12\. Now in the sidebar, scroll down and go to Security Groups, and press Create security group

##### 

##### 13\. Add name and description, again name should start with your own name.

##### 

##### 14\. Under Inbound rules, click on Add Rule , then select type SSH and source as Anywhere IPv4

##### &nbsp;     SSH → Port 22 → Your IP (for management).

##### 

##### 15\. Under Inbound rules, click on Add Rule , then select type HTTP and source as Anywhere IPv4

##### &nbsp;     HTTP → Port 80 → Anywhere (for website access).

##### 

##### ⚠️ Make sure you do not modify the Outbound rules It should be enabled for All traffic on all protocols and all ports by default

##### 

##### 16\. Now go to EC2 Dashboard, and click on your EC2 ID to open your Instance summary.

##### 

##### 17\. Under Actions -> Security -> Change Security Groups

##### 

##### 18\. Select your security group ( with your name), then press Add security group

##### &nbsp;   Optionally you can remove the default security group

##### 

##### 19\. Click Save, then go back to Instance Summary.

##### 

##### 20\. Click on Connect, then go to SSH Client tab.



##### ✅ 4️⃣: Connect to EC2 Instance (Using Terminal or PowerShell)

##### \# Set permissions for key file
```bash

 chmod 400 your-key.pem

```

##### 

##### \# Connect via SSH
```bash

ssh -i your-key.pem ec2-user@<EC2-Public-IP>
```

##### 



##### ✅ 5️⃣: Install Web Server (Apache)

##### Once connected to EC2 instance:

##### 1\.# Update packages
```bash

sudo yum update -y           # For Amazon Linux

##### OR

##### sudo apt update -y       # For Ubuntu

```
##### 

##### 2\.# Install Apache HTTP server
```bash

sudo yum install httpd -y       # For Amazon Linux

OR

sudo apt install apache2 -y    # For Ubuntu

```

##### 

##### 3\.# Start Apache service
```bash

 sudo systemctl start httpd

```
##### 

##### 4\.# Enable Apache to start on boot
```bash

##### sudo systemctl enable httpd

```

##### 

##### ✅ 6️⃣: Upload Your Static Website Files

##### Using SCP (From Local to EC2)
```bash

scp -i "your-key.pem" "path/to/index.html" ec2-user@<EC2-Public-IP>:/home/ec2-user/index.html

```
##### 

##### Move files to web server directory:
```bash

##### sudo mv /home/ec2-user/index.html /var/www/html/
```


##### 

##### ✅ 7️⃣: Open HTTP Port in Security Group (if not already done)

##### Ensure that Port 80 (HTTP) is open in the Security Group → Inbound Rules:

##### Type: HTTP → Protocol: TCP → Port Range: 80 → Source: Anywhere (0.0.0.0/0).



##### 

##### ✅ 8️⃣: Test the Static Website

##### Open browser → Enter: http://<EC2-Public-IP>

##### 

##### 👉 You should see your hosted static website displayed.

##### 

##### 

