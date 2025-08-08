project_name    = "nodejs-app-stg"
aws_region      = "us-east-1"

# CIDRs diferentes para evitar solapamiento con dev/prod
vpc_cidr        = "10.1.0.0/16"
public_subnets  = ["10.1.0.0/24","10.1.1.0/24"]
private_subnets = ["10.1.10.0/24","10.1.11.0/24"]

container_port = 3000
cpu            = 256
memory         = 512

github_repo = "balacot/nodejs-ci-cd-app"
oidc_sub    = "repo:balacot/nodejs-ci-cd-app:ref:refs/tags/*"
