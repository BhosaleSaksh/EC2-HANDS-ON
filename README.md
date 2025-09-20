EC2 Hands-on
✅ 1️⃣: What is EC2?
EC2 (Elastic Compute Cloud) is a service provided by AWS that allows us to run virtual servers in the cloud.
We can use EC2 to host websites, run applications, or perform computation-heavy tasks.


✅ 2️⃣: Why Use EC2 to Host a Static Website?
Provides full control over the virtual machine (OS, web server).
Highly scalable and flexible.
We can host our static website (HTML, CSS, JS files) easily.


✅ 3️⃣: Steps for EC2 Instance Creation
🔧 Step 1: Log in to AWS Management Console
Go to https://aws.amazon.com
Sign in → Services → EC2 → Launch Instance

🔧 Step 2: Launch EC2 Instance
Choose AMI (Amazon Machine Image):
Select Amazon Linux 2 or Ubuntu Server (Free Tier eligible).
Select Instance Type:
Choose t2.micro or  t3.micro (Free Tier).

Configure Instance:
Keep default settings.
Add Storage:
Default 8 GB is sufficient for a static website.
Add Tags (Optional):
Example: Name → MyStaticWebsiteServer
Configure Security Group:
Allow:
SSH → Port 22 → Your IP (for management).
HTTP → Port 80 → Anywhere (for website access).
Review and Launch:
Select or create a new key pair (.pem file) → Download it → Important for SSH access.

✅ 4️⃣: Connect to EC2 Instance (Using Terminal or PowerShell)
# Set permissions for key file
chmod 400 your-key.pem

# Connect via SSH
ssh -i your-key.pem ec2-user@<EC2-Public-IP>

✅ 5️⃣: Install Web Server (Apache)
Once connected to EC2 instance:
# Update packages
sudo yum update -y           # For Amazon Linux
# or for Ubuntu: sudo apt update -y

# Install Apache HTTP server
sudo yum install httpd -y   # For Amazon Linux
# or for Ubuntu: sudo apt install apache2 -y

# Start Apache service
sudo systemctl start httpd

# Enable Apache to start on boot
sudo systemctl enable httpd

✅ 6️⃣: Upload Your Static Website Files
Option 1: Using SCP (From Local to EC2)
scp -i your-key.pem index.html ec2-user@<EC2-Public-IP>:/home/ec2-user/

Option 2: Directly Edit on EC2
sudo nano /var/www/html/index.html
# Paste your HTML code

Move files to web server directory:
sudo mv /home/ec2-user/index.html /var/www/html/

✅ 7️⃣: Open HTTP Port in Security Group (if not already done)
Ensure that Port 80 (HTTP) is open in the Security Group → Inbound Rules:

Type: HTTP → Protocol: TCP → Port Range: 80 → Source: Anywhere (0.0.0.0/0).

✅ 8️⃣: Test the Static Website
Open browser → Enter: http://<EC2-Public-IP>

👉 You should see your hosted static website displayed.
✅ 9️⃣: Useful Commands Recap
Purpose Command
Update packages
sudo yum update -y    or
sudo apt update -y

Install Apache
sudo yum install httpd -y   or 
sudo apt install apache2 -y

Start Apache
sudo systemctl start httpd

Enable Apache at boot
sudo systemctl enable httpd

Move files to web directory
sudo mv index.html /var/www/html/

SSH into EC2 instance
ssh -i your-key.pem ec2-user@<Public-IP>

Upload files via SCP
scp -i your-key.pem index.html ec2-user@<Public-IP>:/home/ec2-user/


✅ 🔟: Final Notes
Make sure the .pem key file has correct permissions (chmod 400).

Public IP can change if the instance is stopped/started → Use Elastic IP for a static IP if needed.

EC2 is flexible for hosting not just static, but dynamic websites with databases too.



