# Lab - WildFly Managed Domain

## Task 1: Configure servers on 3 machines as one domain 

**What:** 
We will use 3 machines (Docker containers) with WildFly installed. We will
join them into one WildFly managed domain and configure servers on them.

**How:**
Start WildFly docker containers without starting the WildFly in them.

Use 3 terminal windows - one for each container:

### 1st terminal - domain controller - master host

Start Docker container `kwart/wildfly` - it creates a new virtual Linux OS environment with WildFly available in `/opt/wildfly`.

```bash
docker run -it --rm --name wildfly-master kwart/wildfly
```

And within the running Docker container do following steps:

```
# add management users, so hosts can authenticate to domain controller
wildfly/bin/add-user.sh -u slave1 -p slave
wildfly/bin/add-user.sh -u slave2 -p slave

# print useful information for slaves
echo "Master node IP is: $MY_IP"
echo "Secret for both slaves is: $(echo -n slave | base64)"

# start domain controller and bind interfaces to correct IP adresses
wildfly/bin/domain.sh --host-config=host-master.xml -b $MY_IP -bmanagement $MY_IP
```

### 2nd terminal - slave host

Run a new Docker container for the `slave1` host controller:
```
docker run -it --rm --name wildfly-slave1 kwart/wildfly
```

Configure and run the `slave1` in the container:

```
# configure slave authentication 
wildfly/bin/jboss-cli.sh <<EOT
  embed-host-controller --host-config=host-slave.xml
  /host=$HOSTNAME/core-service=management/security-realm=ManagementRealm/\
      server-identity=secret:write-attribute(name=value,value="c2xhdmU=")
  /host=$HOSTNAME:write-attribute(name=name, value=slave1)
EOT

# start the slave and provide master adress
wildfly/bin/domain.sh --host-config=host-slave.xml -b $MY_IP \
    -bmanagement $MY_IP -Djboss.domain.master.address=172.17.0.2
```

### 3rd terminal - another slave host

Use the same steps for 3rd terminal, just replace the **`slave1`** value with **`slave2`**

Run a new Docker container for the `slave2` host controller:

```
docker run -it --rm --name wildfly-slave2 kwart/wildfly
```

Configure and run the `slave2` in the container:

```
# configure slave authentication 
wildfly/bin/jboss-cli.sh <<EOT
  embed-host-controller --host-config=host-slave.xml
  /host=$HOSTNAME/core-service=management/security-realm=ManagementRealm/\
      server-identity=secret:write-attribute(name=value,value="c2xhdmU=")
  /host=$HOSTNAME:write-attribute(name=name, value=slave2)
EOT

# start the slave and provide master adress
wildfly/bin/domain.sh --host-config=host-slave.xml -b $MY_IP \
    -bmanagement $MY_IP -Djboss.domain.master.address=172.17.0.2
```


### Verify the domain is running
Console window on master host should contain following log entries:
```
[Host Controller] 21:34:23,983 INFO  [org.jboss.as.domain.controller] (Host Controller Service Threads - 39) WFLYHC0019: Registered remote slave host "slave1", JBoss WildFly Full 17.0.1.Final (WildFly 9.0.2.Final)
[Host Controller] 21:38:31,869 INFO  [org.jboss.as.domain.controller] (Host Controller Service Threads - 39) WFLYHC0019: Registered remote slave host "slave2", JBoss WildFly Full 17.0.1.Final (WildFly 9.0.2.Final)
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
