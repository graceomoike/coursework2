//Jenkinsfile.
pipeline {
    agent any
    environment {
        DOCKERHUB_CREDS = credentials('docker')
    }
    stages {

	stage('Check Changes in server.js') {
    	    steps {
        	script {
            	    def changes = sh(script: "git diff --name-only HEAD~1 | grep 'server.js'", returnStatus: true)
            	    if (changes != 0) {
                	echo 'No changes in server.js. Skipping build.'
                	currentBuild.result = 'SUCCESS'
               		return
                    }
        	}
    	    }
	}

        stage('Docker Image Build') {
            steps {
                echo 'Building Docker Image...'
                sh 'docker build --tag graceomoike/cw2-server:1.0 .'
                echo 'Docker Image Built Successfully!'
            }
        }
        stage('Test Docker Image') {
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
        stage('Dockerhub Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDS_PSW | docker login -u $DOCKERHUB_CREDS_USR --password-stdin'
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
                    sh '''
                        ssh ubuntu@ec2-44-208-163-58.compute-1.amazonaws.com "
                            ansible-playbook /home/ubuntu/deployment-playbook.yml --extra-vars \\"dockerhub_image=graceomoike/cw2-server:1.0\\"
                        "
                    '''
                }
            }
        }
    }
}
