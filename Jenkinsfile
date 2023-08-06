
pipeline {
    agent any
    // tools {
    //     nodejs '20.5.0'
    // }
     options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Clone git') {
            steps {
            git branch: '${REPO_BRANCH}',
            credentialsId: '${REPO_CREDENTIAL_ID}',
            url: '${REPO_URL}'
            }
        }

        stage('Code build') {
            steps {
                sh 'npm install'
                echo '${DOCKER_REG_CREDENTIAL_ID}'
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
            }
        }

         stage('Push Image to ACR') {
     steps{   
         script {
            docker.withRegistry( 'http://${DOCKER_REG_URL}', '${DOCKER_REG_CREDENTIAL_ID}' ) {
            dockerImage.push()
            }
        }
      }
     }

         stage('Remove build image') {
            steps {

                sh 'docker rmi ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}'
            }
        }
    }
}
