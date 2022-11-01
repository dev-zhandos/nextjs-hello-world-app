pipeline {
    agent any
    environment {
        DOCKER_IMAGE_NAME = "zhandosusen/nextjs-hello-world-app"
    }
    stages {
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
