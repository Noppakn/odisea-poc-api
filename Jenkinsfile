pipeline {
    agent any
    // tools {
    //     nodejs '20.5.0'
    //     maven 'maven 3.9.4'
    // }

    stages {
        stage('Clone git') {
            steps {
            git branch: "main",
            credentialsId: "git-credentials",
            url: "https://github.com/Noppakn/odisea-poc-api.git"
            }
        }

        stage('Code build') {
            steps {
                sh 'npm install'
            }
        }
    

        // stage('Build Image') {
        //     steps {
        //         sh 'docker build -t odisea-poc-api:latest .'
        //     }
        // }

        // stage('Push image') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'docker-registry-credentials', passwordVariable: 'DOCKER_PASSWORD', usernameVariable: 'DOCKER_USERNAME')]) {
        //             sh "echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin"
        //             sh 'docker tag odisea-poc-api:latest registry.example.com/odisea-poc-api:latest'
        //             sh 'docker push registry.example.com/odisea-poc-api:latest'
        //         }
        //     }
        // }

        // stage('Remove build image') {
        //     steps {
        //         sh 'docker rmi odisea-poc-api:latest'
        //     }
        // }

        // stage('Store image to Acr') {
        //     steps {
        //         withCredentials([usernamePassword(credentialsId: 'acr-credentials', passwordVariable: 'MNWA7AVzotMUWSTdVmz7OkkXv7p3LruWLYNkdFnFsp+ACRAhptC4', usernameVariable: 'odiseaacr')]) {
        //             sh "echo $ACR_PASSWORD | docker login -u $ACR_USERNAME --password-stdin registry.azurecr.io"
        //             sh 'docker tag odisea-poc-api:latest odiseaacr.azurecr.io/odisea-poc-api:latest'
        //             sh 'docker push odiseaacr.azurecr.io/odisea-poc-api:latest'
        //         }
        //     }
        // }
    }
}
