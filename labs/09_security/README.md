# Lab - JBoss EAP - Security

## Task 1: Deploy secured web application

**What:** Build and deploy application with BASIC authentication

**How:**

* Find the application under `~/wildfly-administration-training/applications/secured`. Build it with Maven (`mvn install`)
and copy resulting WAR to JBoss's `standalone/deployments` directory.
  * review `src/main/webapp/WEB-INF/web.xml` deployment descriptor to see security settings
* Use the `add-user.sh` script to add a new user:
  * username: admin
  * password: admin
  * group: Admin
* check if application is running on http://localhost:8080/secured/
* verify you can login into the application with the `admin` credentials

