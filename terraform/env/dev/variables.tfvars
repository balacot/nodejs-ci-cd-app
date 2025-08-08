project_name    = "nodejs-app"
aws_region      = "us-east-1"
vpc_cidr        = "10.0.0.0/16"
public_subnets  = ["10.0.0.0/24","10.0.1.0/24"]
private_subnets = ["10.0.10.0/24","10.0.11.0/24"]

container_port = 3000
cpu            = 256
memory         = 512

github_repo = "balacot/nodejs-ci-cd-app"
oidc_sub    = "repo:balacot/nodejs-ci-cd-app:*"
