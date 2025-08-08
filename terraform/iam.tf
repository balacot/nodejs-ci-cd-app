# Rol de ejecución de tarea (pull de ECR y logs)
resource "aws_iam_role" "task_execution" {
  name = "${var.project_name}-task-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{ Effect = "Allow", Principal = { Service = "ecs-tasks.amazonaws.com" }, Action = "sts:AssumeRole" }]
  })
}

resource "aws_iam_role_policy_attachment" "task_exec_attach" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Rol de la tarea (permisos en runtime si los necesitas)
resource "aws_iam_role" "task_role" {
  name = "${var.project_name}-task-role"
  assume_role_policy = aws_iam_role.task_execution.assume_role_policy
}

# OIDC de GitHub para desplegar desde Actions sin secrets de largo plazo
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub OIDC
}

resource "aws_iam_role" "github_actions_role" {
  name = "${var.project_name}-github-deploy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com",
          # Restringe al repo
          "token.actions.githubusercontent.com:sub" : "repo:${var.github_repo}:ref:refs/heads/main"
        }
      }
    }]
  })
}

data "aws_iam_policy_document" "github_deploy_policy_doc" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecs:RegisterTaskDefinition",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeClusters",
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "ecs:ListTaskDefinitions",
      "logs:DescribeLogGroups"
    ]
    resources = ["*"]
  }

  # Necesario para que ECS use el execution role en la nueva task definition
  statement {
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = [
      aws_iam_role.task_execution.arn,
      aws_iam_role.task_role.arn
    ]
  }
}

resource "aws_iam_policy" "github_deploy_policy" {
  name   = "${var.project_name}-github-deploy-policy"
  policy = data.aws_iam_policy_document.github_deploy_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "github_deploy_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_deploy_policy.arn
}
