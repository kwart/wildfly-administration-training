# Lab - JBoss EAP - Monitoring

## Task 1: Monitor JBoss EAP server

**What:** Use JConsole to monitor remote JBoss EAP server

**How:**

* We will use JBoss EAP server running in a docker container:
```
# start docker container
docker run -it --rm kwart/jboss-eap

# add a new Management user
jboss-eap/bin/add-user.sh -u admin -p password

# start server with the Full profile
jboss-eap/bin/standalone.sh -c standalone-full.xml -bmanagement $MY_IP
```
* in a new terminal (outside docker container) install JBoss EAP and run
  `jconsole` with the EAP extensions:
```
bin/jconsole.sh
```
* In the "JConsole New Connection" dialog fill:
  * Remote Process: `service:jmx:http-remoting-jmx://172.17.0.2:9990`
  * Username: `admin`
  * Password: `password`
* Connect and you should see Overview page with several monitoring graphs:
  * Memory usage
  * Loaded classes
  * Threads
  * CPU usage

* Switch to other tabs to see more details
