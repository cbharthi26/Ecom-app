**Project: Deploy Ecom-app to AWS ECR using Jenkins**

****Step 0: Install prerequisites on EC2 (Ubuntu)*bash**
sudo apt update
sudo apt install git docker.io awscli -y
sudo usermod -aG docker ubuntu
# Re-login after this

Step 1: Prepare Applicationbashcd ~/Ecom-app
# Place your PHP E-commerce code and Dockerfile here

**Step 2: Create GitHub Repository**
Go to github.com -> New Repository -> Name: Ecom-app -> CreateCreate Personal Access Token: Settings -> Developer settings -> Personal access tokens (classic) -> Generate new token -> Check repo scope -> Generate. Copy token ghp_...
This token will be used as your password.

**Step 3: Push Code to GitHub (Fix for 403 Error)**
GitHub no longer accepts account passwords for push. You must use the token as password.bashgit init
git add .
git commit -m "initial commit"
git remote add origin https://cbharthi26:<YOUR_TOKEN>@github.com/cbharthi26/Ecom-app.git
git branch -M main
git push origin main

**Step 4: Create ECR Repository**
AWS Console -> ECR -> Create repository -> Name: my-php-app -> Region: ap-south-1


**Step 5: Create Jenkinsfile**


This file automates build and push.bashcat > Jenkinsfile << 'EOF'
pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "1231456789"
        AWS_REGION = "ap-south-1"
        ECR_REPO = "my-php-app"
        IMAGE_TAG = "latest"
    }
    stages {
        stage('Clone') { steps { checkout scm } }
        stage('Build Docker Image') {
            steps { sh 'docker build -t $ECR_REPO:$IMAGE_TAG .' }
        }
        stage('Push to ECR') {
            steps {
                sh '''
                aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
                docker tag $ECR_REPO:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$ECR_REPO:$IMAGE_TAG
                '''
            }
        }
    }
}
EOF

git add Jenkinsfile
git commit -m "Add Jenkinsfile"
git push origin mainStep 

**6: Create and Run Jenkins Job**
Jenkins -> New Item -> Name: Ecom-build -> Type: Pipeline -> Configure -> Definition: Pipeline script from SCM -> SCM: Git -> URL: https://github.com/cbharthi26/Ecom-app.git -> Save -> Build Now
After a successful build, your Docker image will be available in ECR as 905418427054.dkr.ecr.ap-south-1.amazonaws.com/my-php-app:latest


Jenkins -> New Item -> Name: Ecom-build -> Type: Pipeline -> Configure -> Definition: Pipeline script from SCM -> SCM: Git -> URL: https://github.com/cbharthi26/Ecom-app.git -> Save -> Build Now
After a successful build, your Docker image will be available in ECR as 905418427054.dkr.ecr.ap-south-1.amazonaws.com/my-php-app:latest
