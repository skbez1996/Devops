# Deploy WebApp to EKS Cluster

## Prerequisites
- AWS CLI installed and configured
- kubectl installed
- Terraform installed

## Deployment Steps

### 1. Install AWS CLI (if not installed)
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### 2. Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region (us-east-1), and output format (json)
```

### 3. Install kubectl (if not installed)
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client
```

### 4. Deploy Infrastructure with Terraform
```bash
# Initialize Terraform
terraform init

# Validate configuration
terraform validate

# Plan the deployment
terraform plan

# Apply the configuration (creates VPC, subnets, EKS cluster, and node group)
terraform apply
# Type 'yes' when prompted
# This will take 10-15 minutes to complete
```

### 5. Configure kubectl for EKS
```bash
# Update kubeconfig to connect to your EKS cluster
aws eks update-kubeconfig --region us-east-1 --name example

# Verify connection
kubectl get nodes
# You should see 2 nodes in Ready state
```

### 6. Deploy the WebApp to Kubernetes
```bash
# Apply the deployment
kubectl apply -f k8s-deployment.yaml

# Apply the service
kubectl apply -f k8s-service.yaml

# Check deployment status
kubectl get deployments
kubectl get pods

# Check service status and get LoadBalancer URL
kubectl get services webapp-service
```

### 7. Access Your WebApp
```bash
# Get the external URL (may take a few minutes for LoadBalancer to provision)
kubectl get service webapp-service -o wide

# The EXTERNAL-IP column will show your LoadBalancer URL
# Example: a1234567890abcdef.us-east-1.elb.amazonaws.com

# Test the application
curl http://<EXTERNAL-IP>
# Or open in browser: http://<EXTERNAL-IP>
```

## Monitoring and Debugging

### Check pod logs
```bash
kubectl logs -l app=webapp
```

### Describe pod for issues
```bash
kubectl describe pod -l app=webapp
```

### Scale deployment
```bash
kubectl scale deployment webapp-deployment --replicas=3
```

### Update image
```bash
kubectl set image deployment/webapp-deployment webapp=saibezaw/webapp:NEW_TAG
```

## Cleanup
```bash
# Delete Kubernetes resources
kubectl delete -f k8s-service.yaml
kubectl delete -f k8s-deployment.yaml

# Destroy Terraform infrastructure
terraform destroy
# Type 'yes' when prompted
```

## Files Created
- `eks-nodegroup.tf` - EKS node group and IAM roles
- `k8s-deployment.yaml` - Kubernetes deployment manifest
- `k8s-service.yaml` - Kubernetes LoadBalancer service
- `DEPLOYMENT.md` - This file

## Architecture
- **VPC**: 10.0.0.0/16 with 3 public subnets across 3 AZs
- **EKS Cluster**: Kubernetes 1.31
- **Node Group**: 2 t3.medium instances (min: 1, max: 3)
- **Deployment**: 2 replicas of your webapp
- **Service**: LoadBalancer exposing port 80
