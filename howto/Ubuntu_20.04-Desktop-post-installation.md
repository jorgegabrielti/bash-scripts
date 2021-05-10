### Update and upgrade System
```bash
apt update
apt upgrade
```

### Install packages essentials
```bash
apt install -y vim net-tools curl tcpdump openfortivpn tmux openssh-server
```

### Utils tools for Sysadmin or Network Admin
- Git
- Virtualbox
- Vagrant
- Veracrypt
- Visual Studio Code
- Remmina
- Ansible
- Docker
- Terraform

### Git Install
```bash
apt install -y git
git --version
```

### Virtualbox Install
```bash
apt install -y gcc make
dpkg -i virtualbox-6.1_6.1.22-144080~Ubuntu~eoan_amd64.deb
apt -f install 
/sbin/vboxconfig
```

### Vagrant Install
```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install vagrant
vagrant --version
```

### Veracrypt Install
```bash
wget https://launchpad.net/veracrypt/trunk/1.24-update7/+download/veracrypt-1.24-Update7-Ubuntu-20.04-amd64.deb
dpkg -i veracrypt-1.24-Update7-Ubuntu-20.04-amd64.deb
apt -f install 
```

### Visual Studio Code Install
Access the site "https://code.visualstudio.com/docs/?dv=linux64_deb" and download
```bash
dpkg -i code_1.56.0-1620166262_amd64.deb
```

### Remmina Install
```bash
sudo apt-add-repository ppa:remmina-ppa-team/remmina-next
sudo apt update
sudo apt install remmina remmina-plugin-rdp remmina-plugin-secret
```

### Ansible Install
```bash
adduser ansible 
usermod -aG sudo ansible
su - ansible 
ssh-keygen
```

```bash
apt update
apt install -y ansible
ansible --version
ansible-inventory --list -y
```

### Docker Install
```bash
sudo apt-get update
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
```bash
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

```bash
docker run hello-world
```

### Terraform Install
```bash
wget https://releases.hashicorp.com/terraform/0.15.3/terraform_0.15.3_linux_amd64.zip
unzip terraform_0.15.3_linux_amd64.zip
cp -v terraform /usr/local/sbin/terraform
terraform --version
```