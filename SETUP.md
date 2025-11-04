# Detailed Setup Guide

## Step-by-Step Setup Instructions

### 1. AWS Setup

#### Create AWS Account and Configure
```bash
# Install AWS CLI (if not installed)
# macOS:
brew install awscli

# Configure AWS credentials
aws configure
# Enter your:
# - AWS Access Key ID
# - AWS Secret Access Key
# - Default region (e.g., us-east-1)
# - Default output format (json)
```

#### Create EC2 Key Pair
1. Go to AWS Console → EC2 → Key Pairs
2. Click "Create Key Pair"
3. Name it (e.g., "snake-game-key")
4. Download the `.pem` file
5. Convert to RSA format (if needed):
```bash
chmod 400 snake-game-key.pem
ssh-keygen -y -f snake-game-key.pem > ~/.ssh/id_rsa_snake.pub
# Or copy to ~/.ssh/id_rsa
```

#### Update Terraform Variables
Edit `terraform/variables.tf`:
```hcl
variable "key_name" {
  default = "snake-game-key"  # Your key pair name
}
```

### 2. Jenkins Setup

#### Install Jenkins
```bash
# macOS with Homebrew
brew install jenkins-lts

# Start Jenkins
brew services start jenkins-lts

# Access Jenkins at http://localhost:8080
# Get initial admin password:
cat ~/.jenkins/secrets/initialAdminPassword
```

#### Install Required Jenkins Plugins
1. Go to Jenkins → Manage Jenkins → Manage Plugins
2. Install these plugins:
   - **Pipeline**
   - **Docker Pipeline**
   - **Ansible**
   - **Terraform** (optional, for better UI)

#### Configure Jenkins Credentials
1. Go to Jenkins → Manage Jenkins → Credentials → System → Global credentials
2. Add AWS credentials:
   - Kind: AWS Credentials
   - ID: aws-credentials
   - Access Key ID: [your AWS access key]
   - Secret Access Key: [your AWS secret key]

#### Configure SSH for Jenkins
```bash
# Generate SSH key for Jenkins (if not exists)
ssh-keygen -t rsa -b 4096 -C "jenkins@localhost"

# Copy public key (you'll need this for EC2)
cat ~/.ssh/id_rsa.pub
```

### 3. Local Tools Setup

#### Install Docker
```bash
# macOS
brew install docker
# Or download Docker Desktop from docker.com
```

#### Install Terraform
```bash
# macOS
brew install terraform

# Verify
terraform version
```

#### Install Ansible
```bash
# macOS
brew install ansible

# Verify
ansible --version
```

### 4. Project Setup

#### Clone/Navigate to Project
```bash
cd /Users/rudra/ci-cd-game-project
```

#### Test Docker Build Locally
```bash
docker build -t snake-game:test .
docker run -d -p 8080:80 --name test-snake snake-game:test
# Visit http://localhost:8080
docker stop test-snake && docker rm test-snake
```

#### Test Terraform (Dry Run)
```bash
cd terraform
terraform init
terraform validate
terraform plan
# Don't apply yet - Jenkins will do it
```

### 5. Jenkins Pipeline Configuration

#### Create New Pipeline Job
1. Go to Jenkins → New Item
2. Enter name: "snake-game-pipeline"
3. Select "Pipeline"
4. Click OK

#### Configure Pipeline
1. In "Pipeline" section:
   - Definition: Pipeline script from SCM
   - SCM: Git (or "Pipeline script" if using local)
   - Repository URL: [your git repo] or use local filesystem
   - Script Path: Jenkinsfile

#### Alternative: Use Pipeline Script Directly
If not using Git, you can copy the Jenkinsfile content directly into the Pipeline script editor.

### 6. First Pipeline Run

#### Before Running
1. Ensure AWS credentials are configured in Jenkins
2. Ensure SSH key is accessible (check `~/.ssh/id_rsa` exists)
3. Update `terraform/variables.tf` with your key pair name

#### Run Pipeline
1. Click "Build Now" in Jenkins
2. Watch the console output
3. Note the EC2 instance IP from the output

### 7. Access the Application

After successful deployment:
1. Get the instance IP from Jenkins console output or:
```bash
cd terraform
terraform output instance_ip
```

2. Open browser: `http://<instance-ip>`

### 8. Troubleshooting

#### Jenkins can't connect to AWS
- Verify AWS credentials in Jenkins
- Check IAM permissions for EC2 access

#### Terraform fails
- Check AWS credentials
- Verify key pair name matches
- Check region availability

#### Ansible connection fails
- Verify SSH key is correct
- Check security group allows SSH (port 22)
- Wait a few minutes after EC2 instance launch for SSH to be ready

#### Docker build fails
- Ensure Docker is running: `docker ps`
- Check Dockerfile syntax

#### Application not accessible
- Verify security group allows HTTP (port 80)
- Check EC2 instance is running
- Verify Docker container is running on EC2:
```bash
ssh ec2-user@<instance-ip>
docker ps
```

### 9. Cleanup

To destroy infrastructure:
```bash
cd terraform
terraform destroy
```

Or let Jenkins handle it by adding a cleanup stage.

## Quick Test Commands

```bash
# Test Docker locally
docker build -t snake-game . && docker run -p 8080:80 snake-game

# Test Terraform
cd terraform && terraform init && terraform plan

# Test Ansible (after instance is created)
cd ansible
ansible-playbook -i <instance-ip>, deploy.yml
```

## Next Steps

1. **Add Docker Registry**: Push images to Docker Hub or AWS ECR
2. **Add Domain**: Use Route53 for custom domain
3. **Add SSL**: Use Let's Encrypt or AWS Certificate Manager
4. **Monitoring**: Add CloudWatch or other monitoring
5. **Scaling**: Use Auto Scaling Groups or ECS

