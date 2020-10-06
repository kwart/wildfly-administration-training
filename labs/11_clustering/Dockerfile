FROM kwart/jboss-eap

COPY *.war /opt/jboss-eap/standalone/deployments/
COPY modify-ha-config.cli /opt/jboss-eap/

RUN /opt/jboss-eap/bin/jboss-cli.sh --file=/opt/jboss-eap/modify-ha-config.cli
