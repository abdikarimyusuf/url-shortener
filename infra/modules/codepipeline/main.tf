resource "aws_codepipeline" "codepipe" {
  name     = var.name
  role_arn = var.role_arn
  artifact_store {
    location = var.s3_bucket
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = "abdikarimyusuf/url-shortener"
        BranchName = "main"
        DetectChanges    = "false"
      }




    }
  }
  stage {
    name = "Build"
    action {
      name     = "Build"
      category = "Build"
      owner    = "AWS"
      provider = "CodeBuild"
      version  = "1"

      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]


      configuration = {
        ProjectName = var.codebuild_project_name
      }

    }
  }

  stage {
    name = "Deploy"
    action {
      name = "Deploy"
      category = "Deploy"
      owner = "AWS"
      provider = "CodeDeployToECS"
      version = "1"
      input_artifacts = ["build_output"]
      
      configuration = {
        ApplicationName = var.ApplicationName
        DeploymentGroupName = var.DeploymentGroupName
        TaskDefinitionTemplateArtifact = "build_output"
        TaskDefinitionTemplatePath = "taskdef.json"
        AppSpecTemplateArtifact = "build_output"
        AppSpecTemplatePath = "appspec.json"

      }
    }
  }

}