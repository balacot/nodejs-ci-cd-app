variable "project_name"   { type = string  default = "nodejs-app" }
variable "aws_region"     { type = string  default = "us-east-1" }
variable "vpc_cidr"       { type = string  default = "10.0.0.0/16" }
variable "public_subnets" { type = list(string) default = ["10.0.0.0/24","10.0.1.0/24"] }
variable "private_subnets"{ type = list(string) default = ["10.0.10.0/24","10.0.11.0/24"] }
variable "container_port" { type = number  default = 3000 }
variable "cpu"            { type = number  default = 256 }
variable "memory"         { type = number  default = 512 }
# Repositorio GitHub en formato owner/repo (para el trust OIDC)
variable "github_repo"    { type = string  default = "your-org/your-repo" }
