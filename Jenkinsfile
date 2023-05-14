pipeline {
    agent {
        docker {
            image 'gcr.io/kaniko-project/executor:debug'
            args '-v /root:/root' // Mounts the Docker client configuration directory
        }
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm // Checks out the code from your SCM
            }
        }
        stage('Build and Push Docker Image') {
            steps {
                sh """
                    echo 'Building and Pushing Docker image'
                    /kaniko/executor --context `pwd` --dockerfile `pwd`/Dockerfile --destination=${ECR_REPO}:${env.BUILD_ID}
                """
            }
        }
    }
}