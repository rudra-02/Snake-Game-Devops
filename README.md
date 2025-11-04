# Snake Game - CI/CD Pipeline Project

This project demonstrates a complete CI/CD pipeline using **Docker**, **Jenkins**, **Terraform**, and **Ansible** to deploy a Snake Game web application on AWS.

## 🎮 Application

A simple, interactive Snake Game built with HTML5, CSS3, and JavaScript, containerized with Docker and deployed on AWS EC2.

## 🛠️ DevOps Tools Used

1. **Docker** - Containerization of the web application
2. **GitHub Actions** - CI/CD orchestration and automation
3. **Terraform** - Infrastructure as Code (IaC) for AWS
4. **Ansible** - Configuration management and deployment automation (optional)

## 📋 Prerequisites

Before setting up the pipeline, ensure you have:

1. **AWS Account** with:
   - AWS CLI configured (`aws configure`)
   - An EC2 Key Pair created
   - IAM user with EC2 permissions

2. **Jenkins** installed and running
   - Docker plugin installed
   - Terraform plugin installed (optional)
   - Ansible plugin installed (optional)

3. **Local Tools**:
   - Docker
   - Terraform
   - Ansible
   - AWS CLI

## 🚀 Setup Instructions

### 1. Configure Terraform

Edit `terraform/variables.tf` and update:
```hcl
variable "key_name" {
  default = "your-aws-key-pair-name"
}
```

### 2. Configure Jenkins

1. Create a new Pipeline job in Jenkins
2. Point it to your Git repository or configure it to use this local directory
3. The Jenkinsfile will automatically be detected

### 3. Configure AWS Credentials in Jenkins

Add AWS credentials to Jenkins:
- Go to Jenkins → Manage Jenkins → Credentials
- Add AWS Access Key ID and Secret Access Key

### 4. Configure SSH Access

Ensure your SSH key is accessible:
- Add your private key to Jenkins credentials
- Or ensure `~/.ssh/id_rsa` is accessible for Ansible

### 5. Run the Pipeline

1. Trigger the Jenkins pipeline
2. The pipeline will:
   - Build Docker image
   - Test the container
   - Create AWS infrastructure with Terraform
   - Deploy application with Ansible
   - Run health checks

## 📁 Project Structure

```
ci-cd-game-project/
├── index.html              # Main HTML file
├── styles.css              # CSS styling
├── game.js                 # Game logic
├── Dockerfile              # Docker container configuration
├── .github/
│   └── workflows/
│       └── cicd.yml        # GitHub Actions CI/CD pipeline
├── terraform/
│   ├── main.tf             # Main Terraform configuration
│   ├── variables.tf        # Terraform variables
│   └── outputs.tf          # Terraform outputs
├── ansible/
│   ├── deploy.yml          # Ansible playbook
│   └── ansible.cfg         # Ansible configuration
├── README.md               # This file
├── GITHUB_SETUP.md         # GitHub Actions setup guide
└── QUICK_START.md          # Quick start instructions
```

## 🔄 Pipeline Stages (GitHub Actions)

1. **Checkout** - Clone repository
2. **AWS Setup** - Configure AWS credentials
3. **Terraform Init/Plan/Apply** - Provision EC2 instance and security group
4. **Get EC2 IP** - Retrieve instance public IP
5. **Build Docker Image** - Test container locally
6. **SSH Setup** - Prepare deployment key
7. **Package & Deploy** - Copy files to EC2 and build container
8. **Health Check** - Verify application is accessible

**See [GITHUB_SETUP.md](GITHUB_SETUP.md) for complete setup instructions.**

## 🌐 Accessing the Application

After successful deployment, access the game at:
```
http://<EC2-Instance-Public-IP>
```

The instance IP will be displayed in the Jenkins build output.

## 🔧 Manual Deployment (Alternative)

If you want to test locally or deploy manually:

### Build and Run Docker Container Locally
```bash
docker build -t snake-game .
docker run -d -p 8080:80 snake-game
```
Access at: `http://localhost:8080`

### Deploy Infrastructure with Terraform
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### Deploy Application with Ansible
```bash
cd ansible
ansible-playbook -i <EC2-IP>, deploy.yml \
  --extra-vars "docker_image=snake-game:latest"
```

## 🧹 Cleanup

To destroy the infrastructure:
```bash
cd terraform
terraform destroy
```

## 📝 Notes

- The pipeline assumes Docker images are built locally or pushed to a registry
- For production, consider using Docker Hub or AWS ECR for image storage
- Update security groups as needed for your use case
- The EC2 instance uses t2.micro (free tier eligible)

## 🐛 Troubleshooting

1. **Jenkins can't connect to AWS**: Check AWS credentials in Jenkins
2. **Ansible connection fails**: Verify SSH key and security group allows SSH
3. **Docker build fails**: Ensure Docker is installed and running
4. **Terraform errors**: Check AWS credentials and region configuration

## 📄 License

This project is for educational/demonstration purposes.

