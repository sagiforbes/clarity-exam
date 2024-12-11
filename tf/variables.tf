variable "lambda_docker_image" {
  description = "the container that should run as the lambda"
  type        = string
  default = "609418740653.dkr.ecr.us-east-1.amazonaws.com/clarity-lambda:latest"
}


variable "region" {
  description = "where this TF be deployed"
  type = string
  default = "us-east-1"
}