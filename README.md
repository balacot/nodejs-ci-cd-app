# nodejs-ci-cd-app (multi-ambiente)

Infraestructura: Terraform (modules + env/dev|stg|prod), app Node.js (Docker), CI/CD con GitHub Actions (OIDC, sin claves).

## Pasos rápidos DEV
cd terraform/env/dev
terraform init
terraform apply -var-file=variables.tfvars

# Outputs: alb_dns_name, ecr_repository_url, github_oidc_role_arn

En GitHub repo -> Settings -> Secrets and variables -> Actions:
- AWS_OIDC_ROLE_ARN_DEV = <output github_oidc_role_arn>

Push a main -> workflow deploy-dev.yml
