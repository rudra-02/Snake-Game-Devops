# Quick Start Guide

## 🚀 5-Minute Local Test

Test the application locally before setting up the full pipeline:

```bash
# 1. Build Docker image
docker build -t snake-game .

# 2. Run container
docker run -d -p 8080:80 --name snake-game snake-game

# 3. Open browser
open http://localhost:8080

# 4. Cleanup
docker stop snake-game && docker rm snake-game
```

## 🏗️ Infrastructure Components

### 1. **Docker** (Containerization)
- **File**: `Dockerfile`
- **Purpose**: Packages the web application into a container
- **Test**: `docker build -t snake-game .`

### 2. **Jenkins** (CI/CD Orchestration)
- **File**: `Jenkinsfile`
- **Purpose**: Automates the entire deployment pipeline
- **Stages**: Build → Test → Deploy Infrastructure → Deploy App → Verify

### 3. **Terraform** (Infrastructure as Code)
- **Directory**: `terraform/`
- **Purpose**: Creates AWS EC2 instance and security groups
- **Test**: `cd terraform && terraform init && terraform plan`

### 4. **Ansible** (Configuration Management)
- **Directory**: `ansible/`
- **Purpose**: Deploys Docker container to EC2 instance
- **Test**: `ansible-playbook -i <ip>, deploy.yml`

## 📋 Pre-Deployment Checklist

- [ ] AWS account created and configured
- [ ] AWS CLI installed and configured (`aws configure`)
- [ ] EC2 Key Pair created in AWS
- [ ] Jenkins installed and running
- [ ] Docker installed and running
- [ ] Terraform installed
- [ ] Ansible installed
- [ ] SSH key accessible for Jenkins/Ansible
- [ ] Updated `terraform/variables.tf` with your key pair name

## 🔧 Configuration Files to Update

### Before First Run:

1. **Terraform Variables** (`terraform/variables.tf`):
   ```hcl
   variable "key_name" {
     default = "your-aws-key-pair-name"  # ← Update this
   }
   ```

2. **Ansible Config** (`ansible/ansible.cfg`):
   ```ini
   private_key_file = ~/.ssh/id_rsa  # ← Update path if needed
   ```

## 🎯 Pipeline Flow

```
Git Push / Manual Trigger
    ↓
Jenkins Pipeline Starts
    ↓
[1] Build Docker Image
    ↓
[2] Test Docker Image
    ↓
[3] Terraform Plan (Preview Changes)
    ↓
[4] Terraform Apply (Create EC2 + Security Group)
    ↓
[5] Save Docker Image for Transfer
    ↓
[6] Ansible Deploy (SSH + Deploy Container)
    ↓
[7] Health Check (Verify Deployment)
    ↓
✅ Application Live on EC2
```

## 🌐 Access Points

- **Local Test**: `http://localhost:8080`
- **AWS Deployment**: `http://<EC2-Public-IP>`
- **Get IP**: `cd terraform && terraform output instance_ip`

## 💰 Cost Estimate

- **EC2 t2.micro**: Free tier eligible (750 hours/month)
- **Data Transfer**: Minimal for testing
- **Estimated Monthly Cost**: $0-5 (within free tier)

## 🐛 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| Jenkins can't connect to AWS | Check AWS credentials in Jenkins |
| Terraform "key pair not found" | Verify key name in `variables.tf` |
| Ansible connection timeout | Check security group allows SSH (port 22) |
| Docker build fails | Ensure Docker daemon is running |
| Can't access website | Check security group allows HTTP (port 80) |

## 📚 Next Steps

1. ✅ Complete local Docker test
2. ✅ Set up Jenkins
3. ✅ Configure AWS credentials
4. ✅ Run first pipeline
5. 🔄 Iterate and improve!

## 📞 Support

See `SETUP.md` for detailed setup instructions or `README.md` for full documentation.

