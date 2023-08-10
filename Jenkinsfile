
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
        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
            }
        }
        stage('Container Security Trivi Scan') {
            steps {
               script {
                     sh """trivy image --format template --template /var/jenkins_home/templates/report_template.html --output ${WORKSPACE}/${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}_trivy_report.html ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}
"""
                }
                post {
                    always {
                        archiveArtifacts artifacts: "${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}_trivy_report.html", fingerprint: true
                            
                        publishHTML (target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: '.',
                            reportFiles: '${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}_trivy_report.html',
                            reportName: '${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME} Trivy Scan',
                            ])
                    }
                }
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


