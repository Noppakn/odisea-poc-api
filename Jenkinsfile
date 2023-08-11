
pipeline {
    agent any

     options {
        skipDefaultCheckout(true)
    }

    stages {
        stage('Clone git') {
            steps {
            git branch: '${REPO_BRANCH}',
            url: '${REPO_URL}'
            }
        }

        stage('Code build') {
            steps {
                sh 'npm install'
            }
        }
        stage('SonarQube analysis') {
        steps{
           script {
                def scannerHome = tool "SonarQubeScanner"
                withSonarQubeEnv('SonarQube') {
                         sh "${tool("SonarQubeScanner")}/bin/sonar-scanner -Dsonar.projectKey=jenkins-Integration -Dsonar.projectName=jenkins-Integration"
                    }
                }
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
            }
        }

         stage('Push Image to ACR') {
            environment {
                ACR_SERVER = '${DOCKER_REG_URL}'
                ACR_CREDENTIAL = 'acr-credentials'
            }
        steps{   
            script {
                docker.withRegistry(  "http://${ACR_SERVER}", ACR_CREDENTIAL ) {
                sh " docker image push ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} "
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


