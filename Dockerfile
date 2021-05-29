FROM tomcat
WORKDIR webapps
ADD gameoflife.war /usr/local/tomcat/webapps/
RUN rm -rf ROOT && mv WebApp.war ROOT.war
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]
