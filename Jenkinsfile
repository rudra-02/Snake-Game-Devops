pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'snake-game'
        DOCKER_TAG = "${env.BUILD_NUMBER}"
        AWS_REGION = 'us-east-1'
        TERRAFORM_DIR = 'terraform'
        ANSIBLE_DIR = 'ansible'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                script {
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Test Docker Image') {
            steps {
                echo 'Testing Docker image...'
                script {
                    sh """
                        docker run -d --name test-container -p 8080:80 ${DOCKER_IMAGE}:${DOCKER_TAG}
                        sleep 5
                        curl -f http://localhost:8080 || exit 1
                        docker stop test-container
                        docker rm test-container
                    """
                }
            }
        }
        
        stage('Terraform Plan') {
            steps {
                echo 'Running Terraform plan...'
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh """
                            terraform init
                            terraform plan -out=tfplan
                        """
                    }
                }
            }
        }
        
        stage('Terraform Apply') {
            steps {
                echo 'Applying Terraform configuration...'
                dir("${TERRAFORM_DIR}") {
                    script {
                        sh "terraform apply -auto-approve tfplan"
                    }
                }
            }
        }
        
        stage('Get EC2 Instance Info') {
            steps {
                echo 'Getting EC2 instance information...'
                script {
                    sh """
                        INSTANCE_IP=\$(terraform -chdir=${TERRAFORM_DIR} output -raw instance_ip)
                        echo "Instance IP: \${INSTANCE_IP}" > instance_info.txt
                    """
                }
            }
        }
        
        stage('Save Docker Image') {
            steps {
                echo 'Saving Docker image for transfer...'
                script {
                    sh """
                        docker save ${DOCKER_IMAGE}:${DOCKER_TAG} -o /tmp/snake-game.tar
                        gzip /tmp/snake-game.tar
                    """
                }
            }
        }
        
        stage('Ansible Deployment') {
            steps {
                echo 'Deploying with Ansible...'
                dir("${ANSIBLE_DIR}") {
                    script {
                        sh """
                            INSTANCE_IP=\$(cat ../instance_info.txt | grep "Instance IP:" | cut -d' ' -f3)
                            scp -o StrictHostKeyChecking=no /tmp/snake-game.tar.gz ec2-user@\${INSTANCE_IP}:/tmp/
                            ssh -o StrictHostKeyChecking=no ec2-user@\${INSTANCE_IP} 'gunzip -f /tmp/snake-game.tar.gz'
                            ansible-playbook -i \${INSTANCE_IP}, deploy.yml --extra-vars "docker_image=${DOCKER_IMAGE}:${DOCKER_TAG}"
                        """
                    }
                }
            }
        }
        
        stage('Health Check') {
            steps {
                echo 'Running health check...'
                script {
                    sh """
                        INSTANCE_IP=\$(cat instance_info.txt | grep "Instance IP:" | cut -d' ' -f3)
                        sleep 30
                        curl -f http://\${INSTANCE_IP} || exit 1
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            sh """
                docker rmi ${DOCKER_IMAGE}:${DOCKER_TAG} || true
                rm -f /tmp/snake-game.tar.gz || true
            """
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}

