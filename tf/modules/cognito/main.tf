resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  password_policy {
    minimum_length    = 8
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
    require_uppercase = true
  }

  tags = var.tags
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name         = "clarity-client"
  user_pool_id = aws_cognito_user_pool.user_pool.id
  generate_secret = false
}

resource "aws_cognito_user" "test_user" {
  username         = var.test_user_name
  user_pool_id     = aws_cognito_user_pool.user_pool.id
  temporary_password = "Clarity123!"

  lifecycle {
    ignore_changes = [temporary_password]
  }
}

