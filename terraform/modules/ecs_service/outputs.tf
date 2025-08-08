output "cluster_name" {
  value = aws_ecs_cluster.this.name
}
output "service_name" {
  value = aws_ecs_service.this.name
}
output "task_execution_role_arn" {
  value = aws_iam_role.task_execution.arn
}
output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}
