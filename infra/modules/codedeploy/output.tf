output "app_name" {
    value = aws_codedeploy_app.cd-app.name
}

output "gp_name" {
    value = aws_codedeploy_deployment_group.deploy.deployment_group_name
}

