
pipeline {
    agent any

     options {
        skipDefaultCheckout(true)
    }
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-17-openjdk-amd64'
    }
    stages {
        stage('Clone git') {
            steps {
            git branch: '${REPO_BRANCH}',
            url: '${REPO_URL}'
            }
        }

        stage('SCA : OWASP Dependency-Check Vulnerabilities') {
            steps {
                dependencyCheck additionalArguments: ''' 
                            -o './'
                            -s './'
                            -f 'ALL' 
                            --prettyPrint''', odcInstallation: 'OWASP Dependency-Check Vulnerabilities'
                
                dependencyCheckPublisher pattern: 'dependency-check-report.xml'
            }
        }

        stage('SAST : SonarQube Scanner') {
        steps{
           script {
                def SCANNER_HOME = tool "SonarQubeScanner"
                withSonarQubeEnv('odsiea-poc-api-sonarqube-pipeline') {
                    sh "${tool("SonarQubeScanner")}/bin/sonar-scanner \
                        -Dsonar.projectKey=odisea-poc-api \
                        -Dsonar.projectName=odisea-poc-api"
                    }
                }
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t ${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER} $WORKSPACE/'
            }
        }

        stage('Container Security : Trivi Scan') {
            steps {
               script {
                    def imageName = "${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}"
                    def reportFileName = "${DOCKER_REG_URL}_${DOCKER_REG_NAME}_${APP_NAME}_${BUILD_NUMBER}_trivy_report.html"
                    sh "trivy image --format template --template '@/home/trivy/contrib/html.tpl' -o ${reportFileName} ${imageName}"
                }
            }
        }

        stage('Push Image to ACR') {
            environment {
                ACR_SERVER = '${DOCKER_REG_URL}'
                ACR_CREDENTIAL = 'acr-credentials'
            }
            steps {   
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
     post {
                    always {
                        archiveArtifacts artifacts: "${DOCKER_REG_URL}_${DOCKER_REG_NAME}_${APP_NAME}_${BUILD_NUMBER}_trivy_report.html", fingerprint: true
                            
                        publishHTML (target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: '.',
                            reportFiles: '${DOCKER_REG_URL}_${DOCKER_REG_NAME}_${APP_NAME}_${BUILD_NUMBER}_trivy_report.html',
                            reportName: 'Trivy Scan Report',
                            ])
                    }
                }
}


