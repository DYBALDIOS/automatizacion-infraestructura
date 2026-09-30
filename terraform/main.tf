terraform {
  required_version = ">= 1.5.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# ---------- Red privada ----------
resource "docker_network" "main" {
  name   = var.network_name
  driver = "bridge"

  ipam_config {
    subnet  = var.network_cidr
    gateway = var.network_gateway
  }
}

# ---------- Imágenes ----------
resource "docker_image" "web" {
  name         = var.web_image
  keep_locally = true
}

resource "docker_image" "app" {
  name         = var.app_image
  keep_locally = true
}

resource "docker_image" "db" {
  name         = var.db_image
  keep_locally = true
}

# ---------- Servidor Web ----------
resource "docker_container" "web" {
  name    = "${var.project_name}-web"
  image   = docker_image.web.image_id
  restart = "unless-stopped"

  networks_advanced {
    name         = docker_network.main.name
    ipv4_address = var.web_ip
  }

  ports {
    internal = 80
    external = var.web_port
  }
}

# ---------- Servidor de Aplicaciones ----------
resource "docker_container" "app" {
  name    = "${var.project_name}-app"
  image   = docker_image.app.image_id
  restart = "unless-stopped"
  command = ["python", "-m", "http.server", "8000"]

  networks_advanced {
    name         = docker_network.main.name
    ipv4_address = var.app_ip
  }

  depends_on = [docker_container.db]
}

# ---------- Servidor de Base de Datos ----------
resource "docker_container" "db" {
  name    = "${var.project_name}-db"
  image   = docker_image.db.image_id
  restart = "unless-stopped"

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]

  networks_advanced {
    name         = docker_network.main.name
    ipv4_address = var.db_ip
  }
}
