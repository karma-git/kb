output "k8s" {
  value       = [for pv in data.template_file.k8s : pv]
  description = "rendered k8s manifests"
}
