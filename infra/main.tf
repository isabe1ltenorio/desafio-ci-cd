terraform {
  required_providers {
    koyeb = {
      source  = "koyeb/koyeb"
      version = "~> 1.0"
    }
  }
}

provider "koyeb" {
  # O token será fornecido via variável de ambiente KOYEB_TOKEN
}

# Variáveis
variable "docker_image_name" {
  description = "Nome da imagem Docker"
  type        = string
}

variable "docker_image_tag" {
  description = "Tag da imagem Docker"
  type        = string
}

# Criar o App no Koyeb
resource "koyeb_app" "saudacoes_app" {
  name = "saudacoes-aleatorias"
}

# Criar o Service no Koyeb
resource "koyeb_service" "saudacoes_service" {
  app_name = koyeb_app.saudacoes_app.name
  
  definition {
    name = "saudacoes-service"
    
    # Configuração da imagem Docker
    docker {
      image = "${var.docker_image_name}:${var.docker_image_tag}"
    }
    
    # Tipo de instância (free tier)
    instance_types {
      type = "free"
    }
    
    # Porta da aplicação
    ports {
      port     = 8080
      protocol = "http"
    }
    
    # Rota principal
    routes {
      path = "/"
      port = 8080
    }
    
    # Região de deploy
    regions = ["fra"] # Frankfurt
    
    # Scaling configuration
    scalings {
      min = 1
      max = 1
    }
    
    # Variáveis de ambiente
    env {
      key   = "PORT"
      value = "8080"
    }
    
    # Health checks
    health_checks {
      http {
        path = "/api/saudacoes/aleatorio"
        port = 8080
      }
    }
  }
  
  depends_on = [koyeb_app.saudacoes_app]
}

# Outputs
output "app_name" {
  value       = koyeb_app.saudacoes_app.name
  description = "Nome do App no Koyeb"
}

output "service_name" {
  value       = koyeb_service.saudacoes_service.definition[0].name
  description = "Nome do Service no Koyeb"
}

output "app_url" {
  value       = "https://${koyeb_app.saudacoes_app.name}-${koyeb_app.saudacoes_app.id}.koyeb.app"
  description = "URL da aplicação no Koyeb"
}
