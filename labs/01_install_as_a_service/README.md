# Lab - JBoss EAP - install as a service

## Task 1 - install service

**What:**
Install the JBoss EAP as a Linux (systemd) service.

**How:**

Steps and service files taken from the WildFly installation (check `docs/contrib/scripts/systemd/README`).

You can also find them in the WildFly-core GitHub repository:
https://github.com/wildfly/wildfly-core/tree/12.0.0.Final/core-feature-pack/src/main/resources/content/docs/contrib/scripts

Run following them as the `root` (`sudo su -`)

```bash
# Create the jboss user/group
groupadd -r jboss
useradd -r -g jboss -d /opt/jboss -s /sbin/nologin jboss

# Install JBoss EAP
unzip /home/student/wildfly-labs-resources/jboss-eap-7.3.0.zip -d /opt
ln -s /opt/jboss-eap-7.3 /opt/jboss

# Configure systemd
cd /home/student/wildfly-administration-training/labs/01_install_as_a_service/systemd
mkdir /etc/jboss
cp jboss.conf /etc/jboss/
cp jboss.service /etc/systemd/system/
cp launch.sh /opt/jboss/bin/

# Change owner of the JBoss EAP directories / links
chown -R jboss:jboss /opt/jboss*

# Start and enable service
systemctl start jboss.service
systemctl enable jboss.service
```

Check if the JBoss EAP is running by opening URL: http://localhost:8080/

## Task 2 - reboot and check the server

**What:**
We want to be sure the application server continues to work after the system restarts.

**How:**
Reboot the VM and check if the JBoss EAP is started automatically.

You can use following command line to reboot:
```bash
sudo reboot
```

Check again if the JBoss EAP is running by opening URL: http://localhost:8080/

## Task 3 - disable the service

**What:**
To avoid clashes with other lab exercises, we will stop and disable the service.

**How:**
As a root run following commands:

```bash
systemctl stop jboss
systemctl disable jboss
```
