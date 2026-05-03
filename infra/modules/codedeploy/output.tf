output "app_name" {
    value = aws_codedeploy_app.deploy.name
}

output "gp_name" {
    value = aws_codedeploy_deployment_group.cd-app.deployment_group_name
}

