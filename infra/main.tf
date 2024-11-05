# Definición de Variables
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}

variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

# Configuración del Proveedor
provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

# Recurso de ejemplo: Crear una instancia EC2
resource "aws_instance" "app_server" {
  ami           = "ami-0c8f6dd3e17cd14c2"   # Reemplaza con el ID de la AMI que prefieras
  instance_type = "t2.micro"       # Tipo de instancia para el servidor
  subnet_id     = "subnet-03d7ff0baf5d9f8da" # Reemplaza con el ID de la Subred donde se creará la instancia
  associate_public_ip_address = true   

  tags = {
    Name = "LibreriaAppServer"
  }
}