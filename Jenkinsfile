pipeline {
    agent any

    environment {
        APP_NAME = 'employee-management'
        IMAGE_NAME = 'employee-management:latest'
        CONTAINER_NAME = 'employee-management'
    }

    stages {
        stage('Checkout develop') {
            steps {
                // For a Pipeline job. For Multibranch Pipeline, Jenkins can use the
                // branch selected by the job and this explicit checkout can be removed.
                git branch: 'develop',
                    url: 'https://github.com/Guruprasad29/Employee-Management.git'
            }
        }

        stage('Maven Build, Test and Package') {
            steps {
                // test failure causes this stage to fail and stops later stages.
                sh 'mvn clean test package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME} .'
            }
        }

        stage('Stop Previous Container') {
            steps {
                sh '''
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                '''
            }
        }

        stage('Deploy New Container') {
            steps {
                sh '''
                    docker run -d                       --name ${CONTAINER_NAME}                       -p 8080:8080                       ${IMAGE_NAME}
                '''
            }
        }

        stage('Deployment Verification') {
            steps {
                sh 'docker ps --filter "name=${CONTAINER_NAME}"'
            }
        }
    }

    post {
        success {
            echo 'CI/CD pipeline completed successfully.'
        }
        failure {
            echo 'Pipeline failed. Docker deployment was not completed after a failed Maven stage.'
        }
    }
}
