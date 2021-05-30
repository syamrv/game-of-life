**App - Gameof Life**

**Tools used: Jenkinsfile, Git, Maven, Ansible, SonarQube, Docker, Kubernetes, Shell Script.
**

**1.	Checkout scm**
	
	Clone the game-of-life code form GitHub repository.
	git-url: 
	
**2.	maven build**

	Build the java code and create the artifact gameoflife.war
	
**3.	Junit Testing, Jacoco reports, SonarQube analysis**

	Integrate automated tests to verify builds, and set up code quality reporting

**4.	Docker build & push**

	Build the docker image and push to docker hub with Jenkins Build Number (syamdocker/task) & deploy the gameoflife.war to tomcat.
	Docker hub repo: syamdocker/task.	
		
**5.	Deployment using Ansible to Kubernetes**

	Using the Ansible playbook, deploy the docker image to Kubernetes

**6.	Promote to UAT**

This job is to promote to higher environments 

**7.	In the same way we can deploy to different environments with approval job in between deployment stages like (SIT, UAT, PRE-PROD, PROD)
**


 ![image](https://user-images.githubusercontent.com/85060027/120102000-9bd22e80-c166-11eb-82fe-4da35f3de914.png)



Once the deployment is completed use the below address to use the application of game-of-life.

Test the app using the http://<ip>:<nodePort>
	
