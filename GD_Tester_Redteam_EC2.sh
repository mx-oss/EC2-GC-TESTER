#!/bin/bash -xe
sudo su
export PATH=$PATH:/usr/local/bin:/usr/sbin:/root/.local/bin
echo 'export PATH=/root/.local/bin:/usr/sbin:$PATH' >> /home/ec2-user/.profile
yum update -y
yum install nmap git python python2-pip python3 python-argparse gcc gcc-c++ glib2-devel bind-utils wget unzip -y
yum install cmake openssl-devel libX11-devel libXi-devel libXtst-devel libXinerama-devel libusb-static libusbmuxd-devel libusbx-devel libusb-devel -y
yum install freerdp freerdp-devel desktop-file-utils -y
yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
pip install paramiko
pip3 install paramiko
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
export privateIP=`curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4`
curl -L https://raw.githubusercontent.com/awslabs/amazon-guardduty-tester/master/guardduty_tester.sh > /home/ec2-user/guardduty_tester.sh
mkdir /home/ec2-user/compromised_keys /home/ec2-user/domains /home/ec2-user/passwords
curl -L https://raw.githubusercontent.com/awslabs/amazon-guardduty-tester/master/artifacts/queries.txt > /home/ec2-user/domains/queries.txt
curl -L https://raw.githubusercontent.com/awslabs/amazon-guardduty-tester/master/artifacts/password_list.txt > /home/ec2-user/passwords/password_list.txt
curl -L https://raw.githubusercontent.com/awslabs/amazon-guardduty-tester/master/artifacts/never_used_sample_key.foo > /home/ec2-user/compromised_keys/compromised.pem
FILE="/home/ec2-user/compromised_keys/compromised.pem"
for FILE in {1..20}; do cp /home/ec2-user/compromised_keys/compromised.pem /home/ec2-user/compromised_keys/compromised$FILE.pem; done
echo 'BASIC_LINUX_TARGET="10.81.64.185"' >> /home/ec2-user/localIps.sh
echo 'BASIC_WINDOWS_TARGET="10.81.64.173"' >> /home/ec2-user/localIps.sh
echo -n 'RED_TEAM_INSTANCE="' >> /home/ec2-user/localIps.sh
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/instance-id >> /home/ec2-user/localIps.sh
echo '"' >> /home/ec2-user/localIps.sh
echo -n 'RED_TEAM_IP="' >> /home/ec2-user/localIps.sh
curl -H "X-aws-ec2-metadata-token: $TOKEN" -v http://169.254.169.254/latest/meta-data/local-ipv4 >> /home/ec2-user/localIps.sh
echo '"' >> /home/ec2-user/localIps.sh
echo 'BASIC_LINUX_INSTANCE="i-075c71934ca9f63ea"' >> /home/ec2-user/localIps.sh
echo 'BASIC_WINDOWS_INSTANCE="i-05288656be4a0faff"' >> /home/ec2-user/localIps.sh
cd /home/ec2-user/
cat << EOF >> users
ec2-user
root
admin
administrator
ftp
www
nobody
EOF
pip install cmake
wget https://github.com/vanhauser-thc/thc-hydra/archive/refs/tags/v9.4.zip  -P /home/ec2-user
wget -q -O /home/ec2-user/libssh.tar.xz https://www.libssh.org/files/0.9/libssh-0.9.4.tar.xz
tar -xvf /home/ec2-user/libssh.tar.xz
cd /home/ec2-user/libssh-0.9.4
mkdir build
cd build
cmake -DUNIT_TESTING=OFF -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ..
make && make install
cd /home/ec2-user
unzip v9.4.zip
cd /home/ec2-user/thc-hydra-9.4
/home/ec2-user/thc-hydra-9.4/configure
make
make install
git clone https://github.com/galkan/crowbar /home/ec2-user/crowbar
chown -R ec2-user: /home/ec2-user
chmod +x /home/ec2-user/guardduty_tester.sh
chmod +x /home/ec2-user/crowbar/crowbar.py
cd /home/ec2-user
wget https://secure.eicar.org/eicar.com
wget https://secure.eicar.org/eicar.com.txt
wget https://secure.eicar.org/eicar_com.zip
wget https://secure.eicar.org/eicarcom2.zip
# Signal the status from cfn-init
yum install -y aws-cfn-bootstrap
/opt/aws/bin/cfn-signal -e $?          --stack GD-tester         --resource ECSAutoScalingGroup          --region ca-central-1