# OCI Kubernetes Cluster with Terraform

This Terraform configuration creates a highly available Kubernetes cluster on Oracle Cloud Infrastructure (OCI) with various components and add-ons.

## Components

- Virtual Cloud Network (VCN) with public and private subnets
- Oracle Container Engine for Kubernetes (OKE) cluster
- Load Balancer
- Kubernetes Metrics Server
- Cluster Autoscaler
- NGINX Ingress Controller
- Calico CNI plugin
- Istio Service Mesh
- Sample NGINX deployment with Horizontal Pod Autoscaling

## Prerequisites

1. OCI CLI installed and configured
2. Terraform v1.0.0 or later
3. kubectl installed
4. Helm v3 installed
5. OCI API key and configuration

## Required Variables

Create a `terraform.tfvars` file with the following variables:

```hcl
tenancy_ocid     = "ocid1.tenancy.oc1..example"
user_ocid        = "ocid1.user.oc1..example"
fingerprint      = "xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx:xx"
private_key_path = "~/.oci/oci_api_key.pem"
region           = "us-ashburn-1"
compartment_id   = "ocid1.compartment.oc1..example"
cluster_name     = "oke-cluster"
ssh_public_key   = "ssh-rsa AAAA..."
```

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the planned changes:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

4. Configure kubectl:
   ```bash
   oci ce cluster create-kubeconfig --cluster-id $(terraform output -raw cluster_id) --file $HOME/.kube/config
   ```

## Accessing the Cluster

After the cluster is created, you can access it using kubectl:

```bash
kubectl get nodes
kubectl get pods -A
```

## Components Details

### Network
- VCN with CIDR block 10.0.0.0/16
- Public subnet for load balancers
- Private subnet for worker nodes
- NAT Gateway for outbound internet access
- Service Gateway for OCI services

### Kubernetes Cluster
- OKE cluster with latest stable version
- Worker nodes in private subnet
- Node pool with flexible shape
- Automatic node scaling

### Add-ons
- Metrics Server for resource monitoring
- Cluster Autoscaler for automatic node scaling
- NGINX Ingress Controller for external access
- Calico CNI for network policy
- Istio Service Mesh for traffic management

### Sample Application
- NGINX deployment with 3 replicas
- Service exposed on port 8080
- HPA configured for CPU and memory scaling

## Cleanup

To destroy all created resources:

```bash
terraform destroy
```

## Notes

- The configuration uses flexible shapes for load balancers and nodes
- Worker nodes are placed in private subnet for security
- All components are installed using Helm charts
- The sample NGINX application is configured with resource limits and requests 