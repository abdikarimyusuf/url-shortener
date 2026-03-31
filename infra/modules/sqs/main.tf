resource "aws_sqs_queue" "sqs" {
 name = var.name
 visibility_timeout_seconds = var.visibility_timeout #how long it reappears when taken out for proc
 message_retention_seconds var.message_retention 
 receive_wait_time_seconds = var.receive_wait_time #wait intelligently instead of polling aggressively



}
