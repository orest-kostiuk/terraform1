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
  - name: redis
    image: redis:latest
  - name: mysql
    image: mysql:5.7
    env:
    - name: MYSQL_ROOT_PASSWORD
      value: 'root_password' # replace with your root password
    - name: MYSQL_DATABASE
      value: 'test' # replace with your database name
    - name: MYSQL_USER
      value: 'test_user' # replace with your username
    - name: MYSQL_PASSWORD
      value: 'test_password' # replace with your password
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
        stage('Deploy to Production') {
            environment {
                NAMESPACE = 'dev'
                VERSION = "dev-${env.GIT_BRANCH}-${env.GIT_COMMIT.substring(0,7)}"
                APP_NAME = 'terraform' // Define your app name
            }
            steps {
                sh '''
                    kubectl set image deployment/${APP_NAME} -n ${NAMESPACE} ${APP_NAME}=${ECR_REGISTRY}/${APP_NAME}:${VERSION}
                    kubectl rollout status deployments/${APP_NAME} -n ${NAMESPACE} --timeout=360s
                '''
            }
        }
    }
}
