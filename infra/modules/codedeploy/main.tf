resource "aws_codedeploy_app" "cd-app" {
    name = "${var.name_prefix}-cd-app"
    compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "deploy" {
    app_name = aws_codedeploy_app.cd-app.name
    deployment_group_name = "${var.name_prefix}-deploy"
    service_role_arn = var.service_role_arn 

    deployment_config_name = var.deployment_config_name 
    deployment_style {
        deployment_type = var.deployment_type
        deployment_option = var.deployment_option

    }

    ecs_service {
        cluster_name = var.cluster_name
        service_name = var.service_name
    }

    load_balancer_info {
        target_group_pair_info {
            target_group {
                target_group_name = var.blue_target_group_name
            }
            target_group {
                target_group_name = var.green_target_group_name
            }
            prod_traffic_route {
                 listener_arns = var.listener_arns
}
        }
    }


}

