
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
                    def imageName = "${DOCKER_REG_URL}/${DOCKER_REG_NAME}/${APP_NAME}:${BUILD_NUMBER}"
                    def reportFileName = "${DOCKER_REG_URL}_${DOCKER_REG_NAME}_${APP_NAME}_${BUILD_NUMBER}_trivy_report.html"
                     sh "trivy image --format json --output ${reportFileName} ${imageName}"
            
                    // Read the JSON report
                    def jsonReport = readFile(reportFileName)
                    
                    // Generate HTML report using template and jsonReport
                    def htmlReport = """
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <title>Trivy Scan Report</title>
                        <style>
                            /* Add your CSS styles here */
                        </style>
                    </head>
                    <body>
                        <h1>Trivy Scan Report for ${jsonReport.ImageName}</h1>
                        
                        <h2>Scan Results:</h2>
                        <ul>
                            <li>Severity: ${jsonReport.Severity}</li>
                            <li>Vulnerabilities Found: ${jsonReport.Vulnerabilities.size()}</li>
                        </ul>
                        
                        <h2>Details:</h2>
                        <table>
                            <tr>
                                <th>Vulnerability ID</th>
                                <th>Package Name</th>
                                <th>Installed Version</th>
                                <th>Fixed Version</th>
                            </tr>
                            <!-- Loop through vulnerabilities and generate rows -->
                            {{- range jsonReport.Vulnerabilities -}}
                            <tr>
                                <td>{{ .VulnerabilityID }}</td>
                                <td>{{ .PkgName }}</td>
                                <td>{{ .InstalledVersion }}</td>
                                <td>{{ .FixedVersion }}</td>
                            </tr>
                            {{- end -}}
                        </table>
                    </body>
                    </html>
                    """
                                
                                // Write the HTML report back to the report file
                                writeFile file: reportFileName, text: htmlReport
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


