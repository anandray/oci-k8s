resource "oci_containerengine_cluster" "oke_cluster" {
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name              = var.cluster_name
  vcn_id            = var.vcn_id

  options {
    service_lb_subnet_ids = [var.subnet_ids["public"]]
    
    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled              = false
    }

    kubernetes_network_config {
      pods_cidr     = "10.244.0.0/16"
      services_cidr = "10.96.0.0/16"
    }
  }
}

resource "oci_containerengine_node_pool" "node_pool" {
  cluster_id         = oci_containerengine_cluster.oke_cluster.id
  compartment_id     = var.compartment_id
  kubernetes_version = var.kubernetes_version
  name              = "${var.cluster_name}-node-pool"
  node_shape        = var.node_shape

  node_config_details {
    size = var.node_pool_size

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
      subnet_id          = var.subnet_ids["private"]
    }

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[1].name
      subnet_id          = var.subnet_ids["private"]
    }

    placement_configs {
      availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
      subnet_id          = var.subnet_ids["private"]
    }
  }

  node_shape_config {
    ocpus         = var.node_ocpus
    memory_in_gbs = var.node_memory_in_gbs
  }

  initial_node_labels {
    key   = "node.kubernetes.io/instance-type"
    value = var.node_shape
  }

  ssh_public_key = var.ssh_public_key
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.compartment_id
}

resource "oci_load_balancer" "load_balancer" {
  compartment_id = var.compartment_id
  display_name   = "${var.cluster_name}-load-balancer"
  shape          = "flexible"
  subnet_ids     = [var.subnet_ids["public"]]

  is_private = false

  shape_details {
    minimum_bandwidth_in_mbps = 10
    maximum_bandwidth_in_mbps = 100
  }
}

resource "oci_load_balancer_backend_set" "backend_set" {
  load_balancer_id = oci_load_balancer.load_balancer.id
  name             = "${var.cluster_name}-backend-set"
  policy           = "ROUND_ROBIN"

  health_checker {
    protocol = "HTTP"
    port     = 8080
    url_path = "/"
  }
} 