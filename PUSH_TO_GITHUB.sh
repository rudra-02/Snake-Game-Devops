#!/bin/bash
# Quick script to push this project to GitHub

echo "🚀 Pushing Snake Game CI/CD Project to GitHub..."
echo ""

# Check if remote already exists
if git remote | grep -q origin; then
    echo "⚠️  Remote 'origin' already exists. Updating..."
    git remote set-url origin https://github.com/rudra-02/Snake-Game-Devops.git
else
    echo "✅ Adding GitHub remote..."
    git remote add origin https://github.com/rudra-02/Snake-Game-Devops.git
fi

echo "📦 Creating initial commit..."
git add .
git commit -m "Initial commit: Snake Game CI/CD with GitHub Actions, Terraform, and Docker" || echo "Already committed"

echo "🌿 Setting main branch..."
git branch -M main

echo "📤 Pushing to GitHub..."
echo "   Repository: https://github.com/rudra-02/Snake-Game-Devops.git"
echo ""
git push -u origin main

echo ""
echo "✅ Done! Your code is now on GitHub."
echo ""
echo "📋 Next Steps:"
echo "   1. Go to: https://github.com/rudra-02/Snake-Game-Devops/settings/secrets/actions"
echo "   2. Add these secrets:"
echo "      - AWS_ACCESS_KEY_ID"
echo "      - AWS_SECRET_ACCESS_KEY"
echo "      - AWS_REGION (value: ap-south-1)"
echo "      - SSH_PRIVATE_KEY (contents of ~/Downloads/snake-game-key.pem)"
echo "   3. Go to: https://github.com/rudra-02/Snake-Game-Devops/actions"
echo "   4. Click 'Run workflow' to trigger the pipeline!"
echo ""

