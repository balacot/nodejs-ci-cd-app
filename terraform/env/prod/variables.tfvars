project_name    = "nodejs-app-prod"
aws_region      = "us-east-1"

vpc_cidr        = "10.2.0.0/16"
public_subnets  = ["10.2.0.0/24","10.2.1.0/24"]
private_subnets = ["10.2.10.0/24","10.2.11.0/24"]

container_port = 3000
cpu            = 512   # un poco más alto en prod
memory         = 1024  # idem

github_repo = "balacot/nodejs-ci-cd-app"
oidc_sub    = "repo:balacot/nodejs-ci-cd-app:ref:refs/tags/*"  # deploy por tags/releases
