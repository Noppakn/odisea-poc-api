
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
//    def scannerHome = tool 'SonarScanner 4.0';
        steps{
        withSonarQubeEnv('SonarQube') { 
        // If you have configured more than one global server connection, you can specify its name
//      sh "${scannerHome}/bin/sonar-scanner"
        sh "mvn sonar:sonar"
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


