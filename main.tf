terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# VCN and Network Configuration
module "network" {
  source = "./modules/network"

  compartment_id = var.compartment_id
  vcn_cidr       = var.vcn_cidr
  region         = var.region
  cluster_name   = var.cluster_name
}

# OKE Cluster Configuration
module "oke" {
  source = "./modules/oke"

  compartment_id     = var.compartment_id
  vcn_id             = module.network.vcn_id
  subnet_ids         = module.network.subnet_ids
  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  node_pool_size     = var.node_pool_size
  node_shape         = var.node_shape
  node_ocpus         = var.node_ocpus
  node_memory_in_gbs = var.node_memory_in_gbs
  ssh_public_key     = var.ssh_public_key
  node_image_id      = var.node_image_id
}

# Kubernetes Add-ons Configuration
module "k8s_addons" {
  source = "./modules/k8s_addons"

  cluster_name = var.cluster_name
  region       = var.region

  depends_on = [module.oke]
} 