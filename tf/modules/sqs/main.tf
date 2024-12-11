resource "aws_sqs_queue" "clarity_queue" {
  name = "clarity-queue"

  tags = var.tags
}

output "sqs_queue_url" {
  value = aws_sqs_queue.clarity_queue.id
}
