
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
                    def trivyReportJson = sh(script: "trivy image --format json ${imageName}", returnStdout: true).trim()
                    // Parse the JSON report
                   
                    // Print the JSON report to see if there are any issues
                    echo "Trivy JSON Report:"
                    echo trivyReportJson

                    // Parse the JSON report
                    def trivyReport
                    try {
                        trivyReport = new groovy.json.JsonSlurper().parseText(trivyReportJson)
                    } catch (Exception e) {
                        error "Error parsing JSON report: ${e.message}"
                    }
                    // Create a formatted report
                    //def trivyReport = new groovy.json.JsonSlurper().parseText(trivyReportJson)
                    def reportContent = """
                    <!DOCTYPE html>
                    <html>
                    <head>
                        <title>Trivy Scan Report</title>
                        <style>
                            /* Add your CSS styles here */
                            body {
                                font-family: Arial, sans-serif;
                            }
                            table {
                                border-collapse: collapse;
                                width: 100%;
                                margin-top: 20px;
                            }
                            th, td {
                                border: 1px solid #ddd;
                                padding: 8px;
                                text-align: left;
                            }
                            th {
                                background-color: #f2f2f2;
                            }
                        </style>
                    </head>
                    <body>
                        <h1>Trivy Scan Report for ${imageName}</h1>
                        
                        <h2>Scan Results:</h2>
                        <table>
                            <tr>
                                <th>Vulnerability ID</th>
                                <th>Package Name</th>
                                <th>Installed Version</th>
                                <th>Severity</th>
                            </tr>
                            <!-- Loop through vulnerabilities and generate table rows -->
                            ${trivyReport.Vulnerabilities.collect { vulnerability ->
                                """
                                <tr>
                                    <td>${vulnerability.VulnerabilityID}</td>
                                    <td>${vulnerability.PkgName}</td>
                                    <td>${vulnerability.InstalledVersion}</td>
                                    <td>${vulnerability.Severity}</td>
                                </tr>
                                """
                            }.join('\n')}
                        </table>
                    </body>
                    </html>
                    """
                    
                    writeFile file: reportFileName, text: reportContent
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


