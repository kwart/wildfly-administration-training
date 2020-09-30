# Lab - JBoss EAP Managed Domain

## Task 1: Configure servers on 3 machines as one domain 

**What:** 
We will use 3 machines (Docker containers) with JBoss EAP installed. We will
join them into one managed domain and configure servers on them.

**How:**
Start JBoss EAP docker containers without starting the EAP in them.

Use 3 terminal windows - one for each container:

### 1st terminal - domain controller - master host

Start Docker container `kwart/jboss-eap` - it creates a new virtual Linux OS environment with JBoss available in `/opt/jboss-eap`.

```bash
docker run -it --rm --name jboss-master kwart/jboss-eap
```

And within the running Docker container do following steps:

```
# add management users, so hosts can authenticate to domain controller
jboss-eap/bin/add-user.sh -u slave1 -p slave
jboss-eap/bin/add-user.sh -u slave2 -p slave

# print useful information for slaves
echo "Master node IP is: $MY_IP"
echo "Secret for both slaves is: $(echo -n slave | base64)"

# start domain controller and bind interfaces to correct IP adresses
jboss-eap/bin/domain.sh --host-config=host-master.xml -b $MY_IP -bmanagement $MY_IP
```

### 2nd terminal - slave host

Run a new Docker container for the `slave1` host controller:
```
docker run -it --rm --name jboss-slave1 kwart/jboss-eap
```

Configure and run the `slave1` in the container:

```
# configure slave authentication 
jboss-eap/bin/jboss-cli.sh <<EOT
  embed-host-controller --host-config=host-slave.xml
  /host=$HOSTNAME/core-service=management/security-realm=ManagementRealm/\
      server-identity=secret:write-attribute(name=value,value="c2xhdmU=")
  /host=$HOSTNAME:write-attribute(name=name, value=slave1)
EOT

# start the slave and provide master adress
jboss-eap/bin/domain.sh --host-config=host-slave.xml -b $MY_IP \
    -bmanagement $MY_IP -Djboss.domain.master.address=172.17.0.2
```

### 3rd terminal - another slave host

Use the same steps for 3rd terminal, just replace the **`slave1`** value with **`slave2`**

Run a new Docker container for the `slave2` host controller:

```
docker run -it --rm --name jboss-slave2 kwart/jboss-eap
```

Configure and run the `slave2` in the container:

```
# configure slave authentication 
jboss-eap/bin/jboss-cli.sh <<EOT
  embed-host-controller --host-config=host-slave.xml
  /host=$HOSTNAME/core-service=management/security-realm=ManagementRealm/\
      server-identity=secret:write-attribute(name=value,value="c2xhdmU=")
  /host=$HOSTNAME:write-attribute(name=name, value=slave2)
EOT

# start the slave and provide master adress
jboss-eap/bin/domain.sh --host-config=host-slave.xml -b $MY_IP \
    -bmanagement $MY_IP -Djboss.domain.master.address=172.17.0.2
```


### Verify the domain is running
Console window on master host should contain following log entries:
```
[Host Controller] 12:46:09,262 INFO  [org.jboss.as.domain.controller] (Host Controller Service Threads - 2) WFLYHC0019: Registered remote slave host "slave1", JBoss JBoss EAP 7.3.0.GA (WildFly 10.1.2.Final-redhat-00001)
[Host Controller] 12:47:02,646 INFO  [org.jboss.as.domain.controller] (Host Controller Service Threads - 2) WFLYHC0019: Registered remote slave host "slave2", JBoss JBoss EAP 7.3.0.GA (WildFly 10.1.2.Final-redhat-00001)
```

## Task 2: Deploy application to domain

Use management console on master host to deploy `hello` application:
* go to http://172.17.0.2:9990/
* login with a slave credentials (`slave1`/`slave`)

1. Add a new deployment to the content repository
  * Deployments -> Content Repository -> Add
2. Assign the deployment to one or more server groups
  * Content Repository -> `hello.war` -> Deploy -> `main-server-group`

### Verify the application runs

The `master` host controller (domain controller) doesn't have running servers, so let's check
if the application is running on slaves:

* http://172.17.0.3:8080/hello/
* http://172.17.0.4:8080/hello/
