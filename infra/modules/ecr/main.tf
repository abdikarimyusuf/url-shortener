resource "aws_ecr_repository" "ecr_rep" {
  name                 = "ecr-repo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    name = "${var.cluster_name}-ecr-repo"
  }


}


