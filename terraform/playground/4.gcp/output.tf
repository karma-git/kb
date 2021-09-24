output "vm_id" {
  value = google_compute_instance.vm_instance.instance_id
}

output "vm_public_ip" {
  value = google_compute_instance.vm_instance.network_interface.0.network_ip
}
