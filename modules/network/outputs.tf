output "vcn_id" {
  description = "OCID of the VCN"
  value       = oci_core_vcn.vcn.id
}

output "subnet_ids" {
  description = "Map of subnet OCIDs"
  value = {
    public  = oci_core_subnet.public_subnet.id
    private = oci_core_subnet.private_subnet.id
  }
}

output "nat_gateway_id" {
  description = "OCID of the NAT Gateway"
  value       = oci_core_nat_gateway.nat_gateway.id
}

output "service_gateway_id" {
  description = "OCID of the Service Gateway"
  value       = oci_core_service_gateway.service_gateway.id
} 