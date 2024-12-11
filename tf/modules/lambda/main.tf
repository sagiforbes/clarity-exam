resource "aws_iam_role" "clarity_lambda_role" {
  name = "clarity-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect    = "Allow"
        Sid       = ""
      }
    ]
  })
}

resource "aws_iam_policy" "clarity_lambda_policy" {
  name        = "clarity-lambda-policy"
  description = "Policy for Clarity Lambda to access SQS and VPC"

  # Attach policies like access to SQS, VPC, etc.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["ec2:DescribeInstances", "ec2:DescribeSecurityGroups"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "clarity_lambda_policy_attachment" {
  role       = aws_iam_role.clarity_lambda_role.name
  policy_arn = aws_iam_policy.clarity_lambda_policy.arn
}


resource "aws_lambda_function" "clarity_lambda" {
  function_name = "clarity-lambda"
  package_type  = "Image"
  image_uri     = var.docker_image_uri
  
  memory_size   = 128
  timeout       = 30
  role          = aws_iam_role.clarity_lambda_role.arn
  
}

resource "aws_lambda_permission" "clarity_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  function_name = aws_lambda_function.clarity_lambda.function_name
}


############## Gateway definitions
resource "aws_api_gateway_rest_api" "clarity_api" {
  name        = "clarity-api"
  description = "API for Clarity service"
}

resource "aws_api_gateway_resource" "clarity_resource" {
  rest_api_id = aws_api_gateway_rest_api.clarity_api.id
  parent_id   = aws_api_gateway_rest_api.clarity_api.root_resource_id
  path_part   = "clarity"
}

resource "aws_api_gateway_method" "clarity_get_method" {
  rest_api_id   = aws_api_gateway_rest_api.clarity_api.id
  resource_id   = aws_api_gateway_resource.clarity_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "clarity_integration" {
  rest_api_id = aws_api_gateway_rest_api.clarity_api.id
  resource_id = aws_api_gateway_resource.clarity_resource.id
  http_method = aws_api_gateway_method.clarity_get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.clarity_lambda.arn}/invocations"
}

resource "aws_api_gateway_method_response" "clarity_method_response" {
  rest_api_id = aws_api_gateway_rest_api.clarity_api.id
  resource_id = aws_api_gateway_resource.clarity_resource.id
  http_method = aws_api_gateway_method.clarity_get_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "clarity_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.clarity_api.id
  resource_id = aws_api_gateway_resource.clarity_resource.id
  http_method = aws_api_gateway_method.clarity_get_method.http_method
  status_code = "200"
}

resource "aws_api_gateway_deployment" "clarity_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.clarity_integration,
    aws_api_gateway_method.clarity_get_method
  ]

  rest_api_id = aws_api_gateway_rest_api.clarity_api.id
  stage_name  = "prod"
}

resource "aws_api_gateway_stage" "clarity_stage" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.clarity_api.id
  deployment_id = aws_api_gateway_deployment.clarity_api_deployment.id
}

