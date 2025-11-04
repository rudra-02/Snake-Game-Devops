# GitHub Actions CI/CD Setup Guide

This guide will help you set up the complete CI/CD pipeline using GitHub Actions to automatically deploy your Snake Game to AWS.

## 📋 Prerequisites

1. **GitHub Account** - You already have one: [rudra-02](https://github.com/rudra-02)
2. **GitHub Repository** - [Snake-Game-Devops](https://github.com/rudra-02/Snake-Game-Devops.git)
3. **AWS Account** with:
   - AWS Access Key ID and Secret Access Key
   - EC2 Key Pair created (your `snake-game-key.pem`)
   - Region: `ap-south-1` (or update in secrets)

## 🚀 Step-by-Step Setup

### Step 1: Initialize Git Repository (Local)

If you haven't already, initialize git and connect to your GitHub repo:

```bash
cd /Users/rudra/ci-cd-game-project

# Initialize git
git init

# Add all files
git add .

# Create initial commit
git commit -m "Initial commit: Snake Game CI/CD with GitHub Actions"

# Add your GitHub repository as remote
git remote add origin https://github.com/rudra-02/Snake-Game-Devops.git

# Push to GitHub (main branch)
git branch -M main
git push -u origin main
```

### Step 2: Configure GitHub Secrets

Go to your repository: https://github.com/rudra-02/Snake-Game-Devops

1. Click **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret** for each of the following:

#### Required Secrets:

| Secret Name | Value | How to Get |
|------------|-------|------------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID | From AWS IAM → Users → Your User → Security Credentials |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key | From AWS IAM (shown only once, save it!) |
| `AWS_REGION` | `ap-south-1` | Your AWS region (already configured) |
| `SSH_PRIVATE_KEY` | Contents of `snake-game-key.pem` | Run: `cat ~/Downloads/snake-game-key.pem` |

**Important**: 
- For `SSH_PRIVATE_KEY`, copy the **entire contents** of your `.pem` file, including:
  ```
  -----BEGIN RSA PRIVATE KEY-----
  [your key content]
  -----END RSA PRIVATE KEY-----
  ```

### Step 3: Verify Terraform Configuration

Make sure your `terraform/variables.tf` has the correct key name:

```hcl
variable "key_name" {
  default = "snake-game-local"  # or "snake-game-key" depending on your AWS setup
}
```

### Step 4: Trigger the Pipeline

The pipeline will automatically run when you:

1. **Push to main/master branch**:
   ```bash
   git add .
   git commit -m "Update: Trigger CI/CD pipeline"
   git push origin main
   ```

2. **Manual trigger** (recommended for first run):
   - Go to: https://github.com/rudra-02/Snake-Game-Devops/actions
   - Click on "CI/CD - Snake Game" workflow
   - Click "Run workflow" → Select branch `main` → Click "Run workflow"

## 🔄 What the Pipeline Does

1. ✅ **Checkout** - Clones your repository
2. ✅ **AWS Setup** - Configures AWS credentials
3. ✅ **Terraform Init** - Initializes Terraform
4. ✅ **Terraform Plan** - Shows what will be created
5. ✅ **Terraform Apply** - Creates EC2 instance and security group
6. ✅ **Get EC2 IP** - Retrieves the public IP address
7. ✅ **Build Docker Image** - Tests Docker build locally
8. ✅ **SSH Setup** - Prepares SSH key for deployment
9. ✅ **Package App** - Creates deployment bundle
10. ✅ **Copy to EC2** - Transfers files to EC2 instance
11. ✅ **Deploy** - Builds and runs Docker container on EC2
12. ✅ **Health Check** - Verifies the app is accessible

## 📍 Viewing Results

After the pipeline runs:

1. **Check Actions Tab**: https://github.com/rudra-02/Snake-Game-Devops/actions
2. **Click on the workflow run** to see detailed logs
3. **Find the EC2 IP** in the "Get EC2 Public IP" step output
4. **Access your game** at: `http://<EC2-IP>`

## 🐛 Troubleshooting

### Issue: "AWS credentials not found"
- **Solution**: Double-check that `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are set correctly in GitHub Secrets

### Issue: "Permission denied (publickey)"
- **Solution**: Verify `SSH_PRIVATE_KEY` secret contains the complete PEM file (with BEGIN/END lines)

### Issue: "Terraform: key pair not found"
- **Solution**: Update `terraform/variables.tf` to use the correct key pair name that exists in your AWS region

### Issue: "Connection timeout"
- **Solution**: Wait a few minutes after EC2 instance creation for SSH to be ready. The workflow includes retries.

### Issue: "Workflow not showing up"
- **Solution**: Make sure `.github/workflows/cicd.yml` is in your repository and pushed to GitHub

## 🔐 Security Best Practices

1. **Never commit secrets** - All sensitive data is in GitHub Secrets
2. **Rotate keys regularly** - Update AWS and SSH keys periodically
3. **Use IAM roles** - For production, consider using AWS IAM roles instead of access keys
4. **Restrict SSH access** - Update security group to allow SSH only from your IP

## 📝 Next Steps

- [ ] Push code to GitHub
- [ ] Set up all 4 GitHub Secrets
- [ ] Trigger first workflow run
- [ ] Verify deployment at the EC2 IP
- [ ] Share the URL with your team!

## 🎉 Success!

Once the pipeline completes successfully, you'll have:
- ✅ Automated CI/CD pipeline on every push
- ✅ Infrastructure provisioned automatically
- ✅ Application deployed and accessible
- ✅ Health checks verifying deployment

Your Snake Game will be live at: `http://<EC2-Public-IP>`

---

**Need help?** Check the workflow logs in the Actions tab for detailed error messages.

