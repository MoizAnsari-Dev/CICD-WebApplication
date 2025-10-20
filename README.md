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
- Install and configure:
  - Jenkins
  - Docker
  - Trivy
  - SonarQube
- Configure Jenkins pipeline with quality gate & email notifications
- Build and push Docker image to DockerHub  
- Deploy and access app via container on port **3000**

### 🔹 **Part II – Kubernetes Deployment**
- Create IAM user & EKS Cluster using `eksctl`
- Configure Jenkins to deploy to EKS
- Deploy pods and services using `deployment.yml` and `service.yml`

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

