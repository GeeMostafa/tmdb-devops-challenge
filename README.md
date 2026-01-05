# TMDB DevOps Challenge

## Overview
This repository contains my solution for the **TMDB DevOps Challenge**.  
I completed **Challenges 1 & 2** with an emphasis on automation, CI/CD, Infrastructure as Code, and DevOps best practices using **AWS, Terraform, Docker, Nginx, and GitLab CI/CD**.

---

## Challenges Attempted
- **Challenge 1**: CI pipeline implementation using **GitLab CI/CD**
- **Challenge 2**: Infrastructure automation and deployment using **Terraform + Docker + Nginx**

---

## Time Spent
- **Total time:** 8 hours  
- **Duration:** 4 days (2 hours/day)

---

## Application
- **Source Repo on  Github:**  https://github.com/GeeMostafa/tmdb-devops-challenge 
- **Source Repo on Gitlab:** https://gitlab.com/Mostafa1.1/tmdb_challenge
- **Application URL:** http://tmdb-devops-challenge.work.gd/

---

## Architecture Summary
- AWS VPC with public subnet
- EC2 >> public_ip = "34.209.79.13"
- Dockerized a Node.js application and Nginx, with Nginx serving as a reverse proxy
- GitLab CI/CD pipeline
- Terraform for infrastructure provisioning
- AWS ECR for container registry

---

## CI/CD Pipeline (GitLab)
Pipeline stages:
1. **Lint** – Code style checks (`allow_failure: true`)
2. **Test** – Unit/integration tests (`allow_failure: true`)
3. **Build** – Application build artifacts
4. **Docker** – Build & push image to AWS ECR
5. **Deploy** – SSH into EC2 and run container

> Pipeline runtime and logs are available in GitLab CI/CD.

---

## Containerization Improvements
- Non-root user inside container
- `npm ci` instead of `npm install` to ensure fast, clean, and reproducible installs
- AWS ECR used as container registry
- Image pushed via GitLab CI using IAM user access key

---

## Infrastructure as Code (Terraform)
Terraform provisions:
- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Security Groups
- EC2 instance

### State Management
Remote backend using S3 with locking:
```hcl
backend "s3" {
  bucket       = "tmdb-terraform-state"
  key          = "tmdb/terraform.tfstate"
  region       = "us-west-2"
  use_lockfile = true
}
