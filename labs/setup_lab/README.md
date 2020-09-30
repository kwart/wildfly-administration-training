# Lab config

* VirtualBox with CentOS 7 - https://wiki.centos.org/HowTos/Virtualization/VirtualBox/CentOSguest
* Server with Graphical UI + Java
* Automatic screen lock disabled
* bridged network mode

```
# remove packagekit (Graphical updating tool)
yum remove -y PackageKit*

yum update -y
yum install -y yum-plugin-priorities epel-release
yum repolist

# Prerequisities to install Virtual Box Guest Additions
yum install -y dkms gcc make kernel-devel
yum install -y terminator geany nghttp2 git tree wireshark-gnome


# https://docs.docker.com/engine/installation/linux/docker-ce/centos/#install-docker-ce
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-compose
cat <<EOT >/etc/docker/daemon.json
{
  "storage-driver": "devicemapper",
  "storage-opts": [
    "dm.loopmetadatasize=1G",
    "dm.loopdatasize=5G"
  ]
}
EOT

systemctl start docker
systemctl enable docker

groupadd docker
sudo usermod -aG docker student
sudo usermod -aG wireshark student


# install Maven (CentOS 7 contains an old one which fails to compile quickstarts)
cd /opt
curl -s http://mirror.hosting90.cz/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz | sudo tar xzvf -
rm -f /usr/bin/mvn
ln -s /opt/apache-maven-3.6.3/bin/mvn /usr/bin/mvn

echo "127.0.0.1 my-server.my-company.example" >> /etc/hosts

yum clean all
rm -rf /var/cache/yum
```
