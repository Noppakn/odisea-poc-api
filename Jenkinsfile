pipeline {
    agent any

    stages {
        stage('Clone git') {
            steps {
                git 'https://github.com/Noppakn/odisea-poc-api.git'
            }
        }

        stage('Code build') {
            steps {
                sh 'npm install'
            }
        }

        stage('Build Image') {
            steps {
                sh 'docker build -t odisea-poc-api:latest .'
            }
        }

        stage('Push image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
                    sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
                    sh 'docker tag odisea-poc-api:latest registry.example.com/odisea-poc-api:latest'
                    sh 'docker push registry.example.com/odisea-poc-api:latest'
                }
            }
        }

        stage('Remove build image') {
            steps {
                sh 'docker rmi odisea-poc-api:latest'
            }
        }
    }
}
