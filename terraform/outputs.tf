output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.service.name
}

output "github_oidc_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}
