# 🎬 MovieZone – A Responsive Movie Web App

Welcome to **MovieZone**, a responsive and visually appealing web app built with React. It showcases different movie categories like Bollywood, Hollywood, South Indian, and Animated films with hardcoded data. Ideal for beginner-level projects or personal portfolios.

---

### 📌 Features

* 🔥 Clean, responsive UI
* 🌍 Categorized movie pages (Bollywood, Hollywood, South, Animated)
* 📸 Movie posters with descriptions, release year, and rating
* 🚀 Navigation through a custom Header component
* 🎨 Styled with separate CSS files for each page

---

### 📁 Folder Structure

```
MovieZone\
├── public\
│   └── images\placeholder.png
├── src\
│   ├── components\Header.js, Footer.js
│   ├── pages\Home.js, Bollywood.js, Hollywood.js, South.js, Animated.js
│   ├── styles\Header.css, Footer.css, Home.css, Bollywood.css, Hollywood.css, South.css, Animated.css
│   ├── App.js
│   └── index.js
```

---

### 🔧 Installation & Setup

1. **Clone the repository:**

```bash
git clone https://github.com/sparknet-innovations/movie-web-app.git
cd movie-web-app
```

2. **Install dependencies:**

```bash
npm install
```

3. **Start the development server:**

```bash
npm start
```

The app will open at `http://localhost:3000`.

---


## 📚 Table of Contents

1. Project Overview
2. Technologies Used
3. Prerequisites
4. Clone the Repository
5. Build React App
6. Dockerize the App
7. Push Docker Image to AWS ECR
8. Setup Infrastructure using Terraform
9. Create EKS Cluster and Connect
10. Deploy App to EKS
11. Verify Deployment
12. CI/CD with GitHub Actions
13. Monitoring with Prometheus & Grafana

---

## 1. Project Overview

The goal of this project is to containerize and deploy a React-based movie web app that categorizes movies into Bollywood, Hollywood, South Indian, and Animated, and run it on a scalable Kubernetes cluster on AWS.

---

## 2. Technologies Used

* Frontend: React, HTML, CSS
* Backend: Node.js with Express (optional static server)
* DevOps Tools: Docker, Terraform, GitHub Actions
* Cloud: AWS (ECR, EKS, IAM, VPC)
* Orchestration: Kubernetes (EKS)

---

## 3. Prerequisites

Ensure the following tools are installed:

* [Docker](https://www.docker.com/)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
* [Terraform](https://developer.hashicorp.com/terraform/install)
* [kubectl](https://kubernetes.io/docs/tasks/tools/)
* [Node.js](https://nodejs.org/) (v18+)
* IAM user with access to EKS, EC2, IAM, VPC, and ECR

Configure AWS credentials:

```bash
aws configure
```

---

## 4. Clone the Repository

```bash
git clone https://github.com/your-username/moviezone.git
cd moviezone
```

---

## 5. Build React App

```bash
npm install
npm run build
```

This creates a production-ready `build/` directory.

---

## 6. Dockerize the App

Create a `Dockerfile` (if not already present):

```Dockerfile
FROM nginx:alpine
COPY build/ /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

Build the Docker image:

```bash
docker build -t moviezone-app .
```

---

## 7. Push Docker Image to AWS ECR

### Step 1: Create ECR Repo

```bash
aws ecr create-repository --repository-name moviezone-app
```

### Step 2: Authenticate Docker to ECR

```bash
aws ecr get-login-password | docker login --username AWS --password-stdin <account_id>.dkr.ecr.<region>.amazonaws.com
```

### Step 3: Tag and Push Image

```bash
docker tag moviezone-app:latest <account_id>.dkr.ecr.<region>.amazonaws.com/moviezone-app
docker push <account_id>.dkr.ecr.<region>.amazonaws.com/moviezone-app
```

---

## 8. Setup Infrastructure using Terraform

Go to the terraform directory:

```bash
cd terraform
terraform init
```

Apply the infrastructure:

```bash
terraform plan
terraform apply
```

This will create:

* VPC, subnets, IAM roles
* EKS Cluster
* Node groups

---

## 9. Deploy App to EKS

Apply your Kubernetes manifests:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

If using ConfigMaps/Secrets:

```bash
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secret.yaml
```

---

## 10. Verify Deployment

Check if pods and services are running:

```bash
kubectl get pods
kubectl get svc
```

Once the service is exposed, access the app using the external LoadBalancer URL.

---

## 11. CI/CD Pipeline Integration with GitHub

* **Workflow 1**: Provisions infrastructure using Terraform (`terraform-eks.yml`)
* **Workflow 2**: Deploys the React app to the cluster once ready (`deploy.yaml`)

---

## 12. Monitoring with Prometheus & Grafana

### Install Helm on EC2 or Ubuntu machine:

```bash
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

For specific version:

```bash
DESIRED_VERSION=v3.8.2 bash get_helm.sh
```
### Add Helm Repos and Install Prometheus Stack:

```bash
helm repo add stable https://charts.helm.sh/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
kubectl create namespace prometheus
helm install stable prometheus-community/kube-prometheus-stack -n prometheus
```

### Check pods and services:

```bash
kubectl get pods -n prometheus
kubectl get svc -n prometheus
```

### Expose Prometheus and Grafana to External Browser

Edit Prometheus service:

```bash
kubectl edit svc stable-kube-prometheus-sta-prometheus -n prometheus
```

Change type: `ClusterIP` ➝ `LoadBalancer`

Edit Grafana service:

```bash
kubectl edit svc stable-grafana -n prometheus
```

Change type: `ClusterIP` ➝ `LoadBalancer`

Get LoadBalancer URL and access:

```bash
kubectl get svc -n prometheus
```

Access Prometheus at: `http://<prometheus-lb>:9090`

Access Grafana at: `http://<grafana-lb>`

### Get Grafana Admin Password:

```bash
kubectl get secret --namespace prometheus stable-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
```
