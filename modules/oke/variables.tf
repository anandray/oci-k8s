variable "compartment_id" {
  description = "OCID of the compartment"
  type        = string
}

variable "vcn_id" {
  description = "OCID of the VCN"
  type        = string
}

variable "subnet_ids" {
  description = "Map of subnet OCIDs"
  type = object({
    public  = string
    private = string
  })
}

variable "cluster_name" {
  description = "Name of the OKE cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "node_pool_size" {
  description = "Number of nodes in the node pool"
  type        = number
}

variable "node_shape" {
  description = "Shape of the node"
  type        = string
}

variable "node_ocpus" {
  description = "Number of OCPUs for each node"
  type        = number
}

variable "node_memory_in_gbs" {
  description = "Amount of memory in GBs for each node"
  type        = number
}

variable "ssh_public_key" {
  description = "SSH public key for node access"
  type        = string
}

variable "node_image_id" {
  description = "OCID of the node image to use"
  type        = string
} 