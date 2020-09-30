# Lab - JBoss EAP - Deployments and logging

## Task 1: Build and Deploy test application

**What:** Compile and deploy sample application which logs some messages to the server log.

**How:**
* go to `applications/hello` directory and use Maven to build web application from sources:
  * you can find the source code in [index.jsp](/applications/hello/src/main/webapp/index.jsp)
  * Maven build descriptor (POM) in [pom.xml](/applications/hello/pom.xml)

```
cd ~/wildfly-administration-training/applications/hello

# build project with Apache Maven
mvn install
```

* deploy the resulting WAR file `target/hello.war` - copy it to JBoss EAP directory `standalone/deployments`
* check if the application is deployed in browser:
  * http://localhost:8080/hello/
  * review the output in the console window

## Task 2: Configure Logging

**What:** Allow all log levels to be displayed in the server console and configure new loggers with custom levels.

**How:**
Use JBoss CLI to do the configuration changes

* Disable the console limit which displays only levels >= `INFO`
```
/subsystem=logging/console-handler=CONSOLE:undefine-attribute(name=level)
```

* Add new loggers:
  * `training.hello.warning` which will enable only log levels >= `WARNING`
  * `training.hello.debug` which will enable all log levels
```
/subsystem=logging/logger=training.hello.warning:add(level=WARNING)
/subsystem=logging/logger=training.hello.debug:add(level=ALL)
```

* Reload test application (http://localhost:8080/hello/) and recheck the console window
