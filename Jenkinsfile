// Jenkinsfile (Declarative Pipeline)
pipeline {
	agent any
	environment {
		DOCKERHUB_CREDS = credentials('docker')
	}
	stages {

		stage('Docker Image Build') {
			steps {
				echo 'Building Docker Image...'
				sh ' docker build --tag graceomoike/cw2-server:1.0 .'
				echo 'Docker Image Built Successfully!'
			}
		}
		stage('Test Docker Iamge') {
			steps {
				echo 'Testing Docker Image...'
				sh '''
					docker image inspect graceomoike/cw2-server:1.0
					docker run --name test-container -p 8081:8080 -d graceomoike/cw2-server:1.0
					docker ps
					docker stop test-container
					docker rm test-container
				'''
			}
		}
		stage('Dockerhub Login')
			steps {
				sh 'echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdn'
			}
		}
		
		stage('Dockerhub Image Push') {
			steps {
				sh 'docker push graceomoike/cw2-server:1.0'
			}

		}

		stage('Deploy') {
			steps {
				sshagent(['my-ssh-key']) {
				sh 'scp /home/ubuntu/deployment-playbook.yml ubuntu@54.205.122.218:/home/ubuntu/'
				
				}
			}
		}
	}
}
