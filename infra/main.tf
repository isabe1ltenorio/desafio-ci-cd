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

# Criar o App no Koyeb
resource "koyeb_app" "saudacoes_app" {
  name = var.app_name
}

# Criar o Service no Koyeb
resource "koyeb_service" "saudacoes_service" {
  app_name = koyeb_app.saudacoes_app.name
  
  definition {
    name = var.service_name
    
    # Configuração da imagem Docker
    docker {
      image = "${var.docker_image_name}:${var.docker_image_tag}"
    }
    
    # Tipo de instância (free tier)
    instance_types {
      type = var.instance_type
    }
    
    # Porta da aplicação
    ports {
      port     = var.container_port
      protocol = "http"
    }
    
    # Rota principal
    routes {
      path = "/"
      port = var.container_port
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
      value = tostring(var.container_port)
    }
    
    # Health checks
    health_checks {
      http {
        path = "/api/saudacoes/aleatorio"
        port = var.container_port
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
