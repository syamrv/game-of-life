node('master') {
	// Defined the maven docker image for maven build.
	
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
	
	// using the maven docker image for build 
    stage('maven build') {
		myMavenContainer.inside() {
			sh 'mvn clean verify package'
		}		
    }
	
	stage('Junit Testing') {
		junit allowEmptyResults: true, skipPublishingChecks: true, testDataPublishers: [[$class: 'AttachmentPublisher']], testResults: '**/target/surefire-reports/TEST-*.xml'
		perfReport filterRegex: '', showTrendGraphs: true, sourceDataFiles: '**/target/surefire-reports/TEST-*.xml'
	}
	
	stage('Jacoco reports') {
		jacoco classPattern: '**/build/classes', execPattern: '**/target/*.exec', sourceInclusionPattern: '**/*.class'
		//jacoco exclusionPattern: '**/*Test*.class', execPattern: '**/**.exec,**/target/*.exec', runAlways: true
	}
	
	// used the SonarQube docker image and configured in jenkins for SonarQube analysis
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
			-D sonar.sources=gameoflife-web/src/,gameoflife-core/src/,gameoflife-build/src/ \
			-D sonar.java.binaries=gameoflife-web/target/,gameoflife-core/target,gameoflife-build/target/ \
			-D sonar.language=java \
			-D sonar.dynamicAnalysis=reuseReports \
			-D sonar.junit.reportsPath=gameoflife-core/target/surefire-reports/,gameoflife-web/target/surefire-reports/ -D sonar.java.coveragePlugin=jacoco \
			-D sonar.jacoco.reportPath=gameoflife-core/target/jacoco.exec,gameoflife-web/target/jacoco.exec \
			-D sonar.host.url=http://18.207.229.107:9000/"  \
		}
	}
	
	
	// docker image creation to push to docker hub 
	stage('Docker build'){
		sh 'cp /var/lib/jenkins/workspace/${JOB_NAME}/gameoflife-web/target/gameoflife.war .'
		sh 'docker build . -t syamdocker/task:${BUILD_NUMBER}'
		withCredentials([string(credentialsId: 'docker_password', variable: 'docker_password')]) {
		sh 'docker login -u syamdocker -p $docker_password'
		sh 'docker push syamdocker/task:$BUILD_NUMBER'
		}
	}
	
	//deployment of dokcer image to Kubernetes using the Ansible playbook.
	stage('Deployment to Dev'){
		script{
			sh '''
			sed -i "s/build_number/$BUILD_NUMBER/g" deployment.yaml
			'''
			//ansiblePlaybook become: true, installation: 'ansible', inventory: 'hosts', playbook: 'ansible.yaml'
		}
	} 	
	
	stage("Promote to UAT") {
        script {
            def userInput = input(id: 'Proceed1', message: 'Promote build?', parameters: [[$class: 'BooleanParameterDefinition', defaultValue: true, description: '', name: 'Please confirm you agree with this']])
            echo 'userInput: ' + userInput

            if(userInput == true) {
				sh 'echo "Promote to UAT"'
            } else {
                // not do action
                echo "Action was aborted."
            }
       }  
	}
	
}
