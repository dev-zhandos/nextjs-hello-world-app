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
        post {
            success {
                curl --request POST \
                    --url https://api.pagerduty.com/incidents \
                    --header 'Accept: application/vnd.pagerduty+json;version=2' \
                    --header 'Authorization: Token token=e+z18LNzuQUPP5t3K7FQ' \
                    --header 'Content-Type: application/json' \
                    --header 'From: cdvoykulemiqoywdho@tmmwj.net' \
                    --data '{
                    "incident": {
                        "type": "incident",
                        "title": "Jenkins",
                        "service": {
                        "id": "P7OU3JP",
                        "type": "service_reference"
                        },
                        "priority": {
                        "id": "P53ZZH5",
                        "type": "priority_reference"
                        },
                        "urgency": "high",
                        "incident_key": "baf7cf21b1da41b4b0221008339ff357",
                        "body": {
                        "type": "incident_body",
                        "details": "Build succesful"
                        }
                      }
                    }'

            }
            
        }
    }
}
