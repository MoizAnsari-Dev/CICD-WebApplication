# WebApplication – End-to-End DevOps CI/CD Pipeline 🚀  

A **production-ready CI/CD pipeline project** for deploying a *WebApplication* using **Jenkins, Docker, SonarQube, Trivy, AWS and EKS**.  
This project demonstrates real-world DevOps automation—from code commit to deployment on Kubernetes.  

---

## 🧩 Table of Contents
- [Overview](#overview)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Pipeline Flow](#pipeline-flow)
- [Step-by-Step Deployment](#step-by-step-deployment)
- [Highlights](#highlights)
- [Author](#author)

---

## 🧠 Overview
This project automates the complete deployment lifecycle of a **Book My Show Clone App**:
1. Source code is fetched from GitHub.  
2. Code quality is checked using **SonarQube**.  
3. Vulnerabilities are scanned with **Trivy**.  
4. Application is containerized using **Docker**.  
5. Image is pushed to **DockerHub**.  
6. Deployment is automated via **Jenkins** pipeline to **EKS (Kubernetes)**.

---

## 🧰 Tech Stack

| Tool | Purpose |
|------|----------|
| **AWS EC2** | Infrastructure hosting |
| **Jenkins** | CI/CD pipeline automation |
| **Docker** | Application containerization |
| **SonarQube** | Code quality and static analysis |
| **Trivy** | Vulnerability scanning |
| **EKS (Kubernetes)** | Container orchestration |

---

## 🏗️ Architecture

Developer → GitHub → Jenkins → SonarQube → Trivy → DockerHub → EKS Cluster


---

## ⚙️ Pipeline Flow

### 🔹 **Part I – Docker Deployment**
- Launch Ubuntu VM (EC2)
- Install AWS CLI (to interact with AWS Account)
  ```
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  sudo apt install unzip
  unzip awscliv2.zip
  sudo ./aws/install
  aws configure
  ```
- Install KubeCTL (to interact with K8S)
  ```
  curl -o kubectl curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.34.1/2025-09-19/bin/darwin/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin
  kubectl version --short --client
  ```
- Install EKS CTL (used to create EKS Cluster)
  ```
  curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
  sudo mv /tmp/eksctl /usr/local/bin
  eksctl version
  ```
- Create EKS Cluster
    ```
    eksctl create cluster --name=Cluster_name \
                      --region=us-east-1 \
                      --zones=us-east-1a,us-east-1b \
                      --version=1.34 \
                      --without-nodegroup
    ```
    - It will take 5-10 minutes to create the cluster.
    - Go to EKS Console and verify the cluster.

-  IAM OIDC identity provider for your EKS cluster using eksctl
  ```
  eksctl utils associate-iam-oidc-provider \
    --region us-east-1 \
    --cluster Cluster_name \
    --approve
  ```
      - eksctl utils associate-iam-oidc-provider: This associates an IAM OIDC provider with your EKS cluster, enabling IAM roles for service accounts (IRSA).
      - --region us-east-1: Specifies the AWS region where your EKS cluster is located.
      - --cluster Cluster_name: The name of your EKS cluster.
      - --approve: Automatically approves the creation of the OIDC provider without prompting for confirmation
- Before executing the below command, in the 'ssh-public-key' keep the  '<PEM FILE NAME>' (dont put .pem. Just give the pem file name) which was used to create Jenkins Server
    ```
    eksctl create nodegroup --cluster=Cluster_name \
                       --region=us-east-1 \
                       --name=node2 \
                       --node-type=t2.medium \
                       --nodes=3 \
                       --nodes-min=2 \
                       --nodes-max=4 \
                       --node-volume-size=10 \
                       --ssh-access \
                       --ssh-public-key=pem_file_name \
                       --managed \
                       --asg-access \
                       --external-dns-access \
                       --full-ecr-access \
                       --appmesh-access \
                       --alb-ingress-access
    ```
    - It take 10 minutes
# Install Jenkins Serve
  ```
  sudo apt install openjdk-17-jre-headless -y
  sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
  echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt update
  sudo apt install jenkins
  
  ```
# Install Docker
```
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee        /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run hello-world
    sudo usermod -aG docker $USER
```
 # Install Trivy
 ```
sudo apt-get install wget apt-transport-https gnupg
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | sudo tee /usr/share/keyrings/trivy.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb generic main" | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update
sudo apt-get install trivy
 ```
# SonarQube Setup
```
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
docker images
docker ps
```
  - Access SonarQube, after opening port 9000
  - Default username and Password: admin
  - Set new password

- Install and configure:
  - Jenkins
  - Docker
  - Trivy
  - SonarQube
- Configure Jenkins pipeline with quality gate & email notifications
- Build and push Docker image to DockerHub  
- Deploy and access app via container on port **3000**

### 🔹 **Part II – Jenkins Pipeline**
- 🧰 Tools Section
  ```
    tools {
      jdk 'jdk17'
      nodejs 'node25'
  }

  ```
  - 🌍 Environment Variables
    ```
    environment {
    SCANNER_HOME = tool 'sonar-scanner'
    DOCKER_IMAGE = 'docker_userName/container_name:latest'
    EKS_CLUSTER_NAME = 'Cluster_name'
    AWS_REGION = 'us-east-1'
    }
    ```
      - SCANNER_HOME → SonarQube scanner installation path.

      - DOCKER_IMAGE → The image to build and push.

      - EKS_CLUSTER_NAME → The name of your Kubernetes cluster on AWS.

      - AWS_REGION → AWS region for CLI commands.
    - 🧹 Stage 1: Clean Workspace
    ```
    cleanWs()

    ```
      - Clears any previous build files — prevents stale artifacts or conflicts.
    
---

## 🧭 Step-by-Step Deployment

### 🖥️ Setup
1. **Create EC2 Instance (Ubuntu 24.04)** – Open required ports (22, 80, 443, 8080, 3000, 6443, 9000, 9090, etc.)
2. **Install AWS CLI, kubectl, eksctl**  
3. **Setup Jenkins, Docker, Trivy, and SonarQube**

### 🧪 CI/CD Pipeline
- Static code analysis using SonarQube  
- Security scan with Trivy  
- Build & push image to DockerHub  
- Deploy containerized app  
- Email notification on build success/failure  

### ☸️ Kubernetes Deployment
- Configure AWS credentials in Jenkins  
- Deploy to EKS cluster using `kubectl apply -f`  
- Verify with:
  ```bash
  kubectl get pods
  kubectl get svc
---
## 🌟 Highlights

- ✅ Automated CI/CD pipeline with Jenkins
- ✅ Integrated Quality Gate via SonarQube
- ✅ Security scan using Trivy
- ✅ Dockerized deployment workflow
- ✅ Kubernetes-based scalability (EKS)
- ✅ Email notifications for pipeline outcomes
---

