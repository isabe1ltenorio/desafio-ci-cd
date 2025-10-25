variable "app_name" {
  type    = string
  default = "ms-saudacoes-aleatorias"
}

variable "service_name" {
  type    = string
  default = "saudacoes-aleatorias"
}

variable "instance_type" {
  type    = string
  default = "free"
}

variable "container_port" {
  type    = number
  default = 8080
}

variable "docker_image_name" {
  description = "Nome da imagem Docker"
  type        = string
}

variable "docker_image_tag" {
  description = "Tag da imagem Docker"
  type        = string
}
