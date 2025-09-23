
# Wisecow

A fun web server that delivers random wisdom using cowsay and fortune, deployable on Kubernetes with CI/CD automation.

---

## Features
- **Serve Wisdom:** Listens on port 4499 and responds with cowsay + fortune output via HTTP.
- **Kubernetes Ready:** Includes manifests for deployment, service, and ingress (with TLS via ACM).
- **Dockerized:** Runs in a minimal Debian container with all dependencies.
- **CI/CD:** Automated build and deployment to AWS ECR and EC2 via GitHub Actions.
- **System Health Monitoring:** Script to log CPU, memory, disk, and process stats.
- **Nginx Log Analysis:** Script to generate detailed reports from Nginx access logs.

---

## Prerequisites
- **Local:**
	- `bash`, `fortune-mod`, `cowsay`, `netcat-openbsd`
	- For health/log scripts: `awk`, `ps`, `top`, `df`, `free`, `sed`, `grep`
- **Docker:**
	- Docker Engine
- **Kubernetes:**
	- Cluster with access to apply manifests
	- AWS ECR credentials (for deployment)
	- ACM certificate for TLS (see ingress)
- **CI/CD:**
	- GitHub repository secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `EC2_SSH_KEY`, `EC2_IP`

---

## Primary Function
- **wisecow.sh:**
	- Listens on TCP port 4499
	- On request, returns HTTP response with a cowsay fortune
	- Checks for prerequisites (`cowsay`, `fortune-mod`)

---

## Script Functions
- **wisecow.sh:** Minimal HTTP server using netcat, cowsay, and fortune.
- **system_health_monitor.sh:** Logs system health alerts (CPU, memory, disk, process count) to `/var/log/system_health.log`.
- **nginx_log_analyzer.sh:** Analyzes Nginx access logs, outputs report to `/var/log/nginx/log_report.txt` (requests, errors, top pages/IPs/agents/status codes).

---

## Kubernetes Manifests
- **deployment.yaml:** Deploys wisecow container, sets resource limits, uses ECR image, pulls secrets.
- **service.yaml:** Exposes wisecow on port 80 (maps to 4499 in container).
- **ingress.yaml:** Configures ALB ingress, TLS via ACM, routes traffic to wisecow service.

---

## GitHub Workflow
- **ci-cd.yml:**
	- Build and push Docker image to AWS ECR on dispatch
	- Deploys new image to EC2 via SSH and updates Kubernetes deployment
	- Uses secrets for AWS and EC2 access

---

## Usage
1. **Local:**
	 - `./wisecow.sh` (after installing prerequisites)
	 - Access via `http://localhost:4499`
2. **Docker:**
	 - `docker build -t wisecow .`
	 - `docker run -p 4499:4499 wisecow`
3. **Kubernetes:**
	 - `kubectl apply -f k8s/`
	 - Access via configured ingress

---