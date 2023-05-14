pipeline {
    agent {
        kubernetes {
            yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
    - /busybox/cat
    tty: true
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker
  volumes:
    - name: docker-config
      emptyDir: {}
"""
            defaultContainer 'kaniko'
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
                    /kaniko/executor --context "`pwd`" --dockerfile "`pwd`/Dockerfile" --destination=${ECR_REPO}:${env.BUILD_ID}
                """
            }
        }
    }
}
