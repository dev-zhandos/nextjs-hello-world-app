pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "zhandosusen/nextjs-hello-world-app"
        PAGERDUTY_TOKEN = credentials('pagerduty_token')
    }
    stages {
        stage('Build') {
            steps {
                echo 'Running build automation'
                sh './gradlew build1231 --no-daemon'
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
        stage('Deploy To Production') {
            when {
                branch 'main'
            }
            steps {
                withKubeConfig([credentialsId: 'kubetoken', serverUrl: env.KUBE_MASTER_IP]) {
                   sh "echo ${env.KUBE_MASTER_IP}"
                   sh 'kubectl apply -f nextjs-app-kube.yaml'
                }
            }
        }
    }
    post {
            failure {
                sh "bash send-pagerduty-incident.sh ${env.PAGERDUTY_TOKEN} ${env.PAGERDUTY_EMAIL} ${BUILD_URL} ${currentBuild.currentResult} ${BUILD_NUMBER} ${JOB_NAME}"
                                
            }
            
        }
}
