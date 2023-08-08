
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
                echo '${REPO_URL}'
            }
        }
        stage('SonarQube analysis') {
            environment {
                PATH = "$PATH:/opt/apache-maven-3.9.4/bin"
                scannerHome = tool "SonarQubeScanner-5.0.1"
            }
        steps{
            withSonarQubeEnv("SonarQube") {
                sh 'mvn sonar:sonar'
                }
            }
        }
    //     stage('Build Image') {
    //         steps {
    //             sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
    //         }
    //     }

    //      stage('Push Image to ACR') {
    //         environment {
    //             ACR_SERVER = '${DOCKER_REG_URL}'
    //             ACR_CREDENTIAL = 'acr-credentials'
    //         }
    //     steps{   
    //         script {
    //             docker.withRegistry(  "http://${ACR_SERVER}", ACR_CREDENTIAL ) {
    //             sh " docker image push ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} "
    //         }
    //     }
    //   }
    //  }

    //      stage('Remove build image') {
    //         steps {

    //             sh 'docker rmi ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}'
    //         }
    //     }
    }
}


