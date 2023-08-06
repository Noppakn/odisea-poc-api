
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
            }
        }
        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
            }
        }

        stage('Push image to acr') {
            environment {
                ACR_SERVER = '${DOCKER_REG_URL}'
                ACR_USERNAME = credentials("${DOCKER_REG_CREDENTIALS}").USUARIO
                ACR_PASSWORD = credentials("${DOCKER_REG_CREDENTIALS}").SENHA
            }
            steps {
                sh 'docker login $ACR_SERVER -u $ACR_USERNAME -p $ACR_PASSWORD'
                sh 'docker tag your-image-name $ACR_SERVER/${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}'
                sh 'docker push $ACR_SERVER/${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}'
            }
        }

         stage('Remove build image') {
            steps {

                sh 'docker rmi ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}'
            }
        }
    }
}
