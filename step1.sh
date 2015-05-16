cp /root/alauda/sources.list /etc/apt/sources.list
apt-get update

# install wget

apt-get install -y wget

# install ssh server

apt-get install -y openssh-server
mkdir /var/run/sshd
echo 'root:secret' | chpasswd
sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
echo "export VISIBLE=now" >> /etc/profile

# Add A Few PPAs To Stay Current

apt-get install -y software-properties-common

locale-gen en_US.UTF-8
export LANG=en_US.UTF-8