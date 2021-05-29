FROM tomcat 
WORKDIR webapps 
COPY gameoflife.war .
RUN rm -rf ROOT && mv gameoflife.war ROOT.war
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]
