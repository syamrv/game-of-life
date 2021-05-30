node('master') {
    def myMavenContainer = docker.image('cloudbees/java-build-tools:0.0.6')
    myMavenContainer.pull()
    stage('checkout scm') {
        checkout([$class: 'GitSCM', 
		branches: [[name: '*/master']], 
		doGenerateSubmoduleConfigurations: false, 
		extensions: [[$class: 'CleanCheckout']], 
		submoduleCfg: [], 
		userRemoteConfigs: [[credentialsId: 'github_credentials', url: 'https://github.com/syamv/game-of-life.git']]])
    }
    stage('maven build') {
      myMavenContainer.inside() {
        sh 'mvn clean verify package'
		}		
    }
	
	stage('JUnit Testing') {
    junit allowEmptyResults: true, skipPublishingChecks: true, testDataPublishers: [[$class: 'AttachmentPublisher']], testResults: '**/target/surefire-reports/TEST-*.xml'
	perfReport filterRegex: '', showTrendGraphs: true, sourceDataFiles: '**/target/surefire-reports/TEST-*.xml'
	}
	
	stage('Jacoco reports') {
	jacoco classPattern: '**/build/classes', execPattern: '**/target/*.exec', sourceInclusionPattern: '**/*.class'
	//jacoco exclusionPattern: '**/*Test*.class', execPattern: '**/**.exec,**/target/*.exec', runAlways: true
	}
	
	
	stage('SonarQube analysis') {
    def scannerHome = tool 'sonarscanner';
    withSonarQubeEnv('sonarqube') {
      sh "${scannerHome}/bin/sonar-scanner \
      -D sonar.login=admin \
      -D sonar.password=admin01 \
	  -D sonar.sourceEncoding=UTF-8 \
	  -D sonar.projectKey=gameoflife \
	  -D sonar.projectName=gameoflife \
	  -D sonar.projectVersion=1.0 \
	  -D sonar.language=java \
	  -D sonar.sourceEncoding=UTF-8 \
	  -D sonar.java.source=gameoflife-web/src/main/java/,gameoflife-core/src/,gameoflife-build/src/main/java/ \
	  -D sonar.java.binaries=. \
	  -D sonar.dynamicAnalysis=reuseReports \
	  -D sonar.testExecutionReportPaths=gameoflife-core/target/surefire-reports/TEST-*.xml,gameoflife-web/target/surefire-reports/TEST-*.xml \
	  -D sonar.java.coveragePlugin=jacoco \
	  -D sonar.coverageReportPaths=gameoflife-core/target/jacoco.exec,gameoflife-web/target/jacoco.exec \
	  -D sonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml,target/site/jacoco-it/jacoco.xml,build/reports/jacoco/test/jacocoTestReport.xml \
	  -D sonar.host.url=http://54.91.144.1:9000/"  \
		}
	}
	
	stage('Dokcer Build'){

		sh 'cp /var/lib/jenkins/workspace/${JOB_NAME}/gameoflife-web/target/gameoflife.war .'
		sh 'docker build . -t syamdocker/task:${BUILD_NUMBER}'
		withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
		sh 'docker login -u syamdocker -p $docker_password'
		sh 'docker push syamdocker/task:$BUILD_NUMBER'
		}
	}
		
	stage('Deployment using Ansible on Kubernetes'){
		
		script{
			sh '''
			 sed -i "s/build_number/$BUILD_NUMBER/g"  deployment.yaml
			 '''
			ansiblePlaybook become: true, installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yaml'
		}
	
	}
}
