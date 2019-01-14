resource "google_container_node_pool" "np" {
  name       = "test-node-pool"
  zone       = "us-west1-a"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "n1-standard-1"

    oauth_scopes = [
      "compute-rw",
      "storage-ro",
      "logging-write",
      "monitoring",
    ]
  }
}

resource "google_container_cluster" "primary" {
  name = "test-container-cluster"
  zone = "us-west1-a"

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks = [
      {
        cidr_block   = "${var.my_ip}"
      },
    ]
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block = "10.0.0.0/16"
    services_ipv4_cidr_block = "10.2.0.0/16"
  }

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "default-pool"
  }
}
