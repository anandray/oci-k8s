output "cluster_id" {
  description = "OCID of the OKE cluster"
  value       = oci_containerengine_cluster.oke_cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint of the OKE cluster"
  value       = oci_containerengine_cluster.oke_cluster.endpoints[0].kubernetes
}

output "node_pool_id" {
  description = "OCID of the node pool"
  value       = oci_containerengine_node_pool.node_pool.id
}

output "load_balancer_id" {
  description = "OCID of the load balancer"
  value       = oci_load_balancer.load_balancer.id
}

output "load_balancer_ip" {
  description = "IP address of the load balancer"
  value       = oci_load_balancer.load_balancer.ip_address_details[0].ip_address
} 