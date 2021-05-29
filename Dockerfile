FROM tomcat
ADD gameoflife.war /usr/local/tomcat/webapps/
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]
