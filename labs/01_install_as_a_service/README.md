# Lab - WildFly - install as a service

## Task 1 - install service

**What:**
Install the WildFly server as a Linux (systemd) service.

**How:**

Steps taken from `docs/contrib/scripts/systemd/README`, run them as `root` (`sudo su -`)

```
# Create a wildfly user
groupadd -r wildfly
useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly

# Install WildFly
unzip /home/student/wildfly-labs-resources/wildfly-17.0.1.Final.zip -d /opt
mv /opt/wildfly-17.0.1.Final /opt/wildfly
chown -R wildfly:wildfly /opt/wildfly
cd /opt/wildfly/docs/contrib/scripts/systemd

# Configure systemd
mkdir /etc/wildfly
cp wildfly.conf /etc/wildfly/
cp wildfly.service /etc/systemd/system/
cp launch.sh /opt/wildfly/bin/
chmod +x /opt/wildfly/bin/launch.sh

# Start and enable service
systemctl start wildfly.service
systemctl enable wildfly.service
```

Check if the WildFly is running by opening URL: http://localhost:8080/

## Task 2 - reboot and check the server

**What:**
We want to be sure the application server continues to work after the system restarts.

**How:**
Reboot the VM and check if the WildFly is started automatically.

You can use following command line to reboot:
```bash
sudo reboot
```

Check again if the WildFly is running by opening URL: http://localhost:8080/

## Task 3 - disable the service

**What:**
To avoid clashes with other lab exercises, we will stop and disable the service.

**How:**
As a root run following commands:

```bash```
systemctl stop wildfly
systemctl disable wildfly
```
