pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "zhandosusen/nextjs-hello-world-app"
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build --no-daemon'
                sh './gradlew zip --no-daemon'
                archiveArtifacts artifacts: 'dist/nextjs-app.zip'
            }
        }
        stage('Build Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    app = docker.build(DOCKER_IMAGE_NAME)
                    app.inside {
                        sh 'echo $(curl localhost:3000)'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            when {
                branch 'main'
            }
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_hub_login') {
                        app.push("${env.BUILD_NUMBER}")
                        app.push("latest")
                    }
                }
            }
        }
        stage('DeployToProduction') {
            when {
                branch 'main'
            }
            steps {
                input 'Deploy to Production?'
                milestone(1)
                withKubeConfig([credentialsId: 'kubeconfig', serverUrl: "${env.KUBE_MASTER_IP}"]) {
                   sh "echo ${env.KUBE_MASTER_IP}"
                   sh 'kubectl apply -f nextjs-app-kube.yaml'
                }
            }
        }
    }
}
