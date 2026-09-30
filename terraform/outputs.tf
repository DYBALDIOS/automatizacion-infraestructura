output "network_name" {
  description = "Nombre de la red creada"
  value       = docker_network.main.name
}

output "network_cidr" {
  description = "CIDR de la red"
  value       = var.network_cidr
}

output "web_ip" {
  description = "IP del servidor web"
  value       = var.web_ip
}

output "app_ip" {
  description = "IP del servidor de aplicaciones"
  value       = var.app_ip
}

output "db_ip" {
  description = "IP del servidor de base de datos"
  value       = var.db_ip
}

output "web_url" {
  description = "URL del servidor web desde el host"
  value       = "http://localhost:${var.web_port}"
}
