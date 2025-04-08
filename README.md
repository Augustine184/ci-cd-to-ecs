CI/CD Pipeline to AWS ECS
This project demonstrates a complete CI/CD pipeline that builds, tests, analyzes, and deploys a Java-based web application to AWS ECS using Jenkins, Docker, SonarQube, Nexus, Terraform, and more.

🛠️ Tech Stack
- CI/CD Tools: Jenkins, Maven, SonarQube, Nexus, Docker, Docker Hub, AWS ECR
- Infrastructure as Code: Terraform
- Cloud Platform: AWS (EC2, ECS, IAM, ECR, Security Groups)
- Language: Java (vProfile project)
📦 Project Structure
ci-cd-to-ecs/
├── docker-compose/
│   ├── jenkins-compose.yml
│   ├── sonarqube-compose.yml
│   └── nginx.conf
├── terraform/
│   ├── jenkins-ec2.tf
│   ├── sonar-ec2.tf
│   └── variables.tf
├── Dockerfile
├── Jenkinsfile
└── README.md

🧱 Setup Steps
1. Jenkins Setup (on EC2 using Docker Compose):
- Expose ports 8080 (web UI) and 50000 (agent)
- Mount Docker socket for Docker-in-Docker capability
- Install Jenkins plugins:
  * Docker, Nexus, SonarQube Scanner, Maven Pipeline, Build Timestamp, Git Plugin, AWS SDK, ECR Plugin

2. SonarQube Setup (on a separate EC2):
- Includes Postgres + SonarQube containers via Docker Compose
- Reverse proxy using Nginx
- Uses .env for environment configs

3. Security Groups:
- Jenkins SG: Port 22 (SSH), 8080 (from MyIP), 8080 (to Sonar SG)
- SonarQube SG: Port 22 (SSH), 80 (from Jenkins SG & MyIP)
🔄 CI/CD Flow (Jenkinsfile)
1. Fetch Code from GitHub
2. Build with Maven (WAR file)
3. Unit Test
4. Checkstyle Analysis
5. SonarQube Code Quality Scan
6. Quality Gate Check
7. Build Docker Image
8. Push Image to ECR
9. Force New ECS Deployment
☁️ AWS Resources
- ECR Repo: Hosts Docker images
- ECS Cluster: Hosts running containers
- IAM Roles: Used for Jenkins EC2 and ECS tasks
- Terraform: Used to provision EC2 instances
🐳 Dockerfile
Multistage build:
- Stage 1: Maven build of vprofile project
- Stage 2: Deploy WAR into Tomcat base image
📁 Sample `.env` File for SonarQube
POSTGRES_USER=sonar
POSTGRES_PASSWORD=admin123
POSTGRES_DB=sonarqube

SONAR_JDBC_URL=jdbc:postgresql://postgres/sonarqube
SONAR_JDBC_USERNAME=sonar
SONAR_JDBC_PASSWORD=admin123
🧪 Ports Used
Tool        | Port
------------|------
Jenkins     | 8080
SonarQube   | 9000
Nginx Proxy | 80
🔒 AWS CLI and IAM
Install AWS CLI on Jenkins EC2:
sudo snap install aws-cli --classic

Configure AWS credentials in Jenkins for ECR and ECS integration
📸 Architecture Diagram
 
👤 Author
Augustine E
📃 License
This project is for educational and demonstration purposes.

