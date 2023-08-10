
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
                    // Scan the Docker image using Trivy
                    def trivyOutput = sh(script: "trivy --no-progress --format json --output ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}_trivy_report.json --exit-code 1 --severity HIGH,CRITICAL ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}", returnStdout: true).trim()

                    // Load HTML template
                    def templateContent = readFile('/var/jenkins_home/templates/report_template.html')

                    // Render the HTML template with Trivy data
                    def htmlReport = templateContent.replaceAll('<!-- TRIVY_JSON -->', trivyOutput)

                    // Save the HTML report to a file
                    writeFile file: '${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}_trivy_report.html', text: htmlReport
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


