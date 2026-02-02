resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/memos"
  retention_in_days = 7 # keep logs for 7 days (adjust as needed)
}