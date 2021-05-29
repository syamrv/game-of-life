currentBuild.displayName = "Final_Demo # "+currentBuild.number
node('master'){
		def getDockerTag(){
			def tag = sh returnStdout: true, script: 'git rev-parse HEAD'
			return tag
		}
		
		environment{
	    Docker_tag = getDockerTag()
        }
		
		stage('ansible playbook'){
			
			 	script{
				    sh '''final_tag=$(echo $Docker_tag | tr -d ' ')
				     echo ${final_tag}test
				     echo $final_tag'''
				}
		
		}
	}
