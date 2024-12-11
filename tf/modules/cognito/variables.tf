variable "user_pool_name" {
  description = "Name of the Cognito user pool"
  type        = string
  
}

variable "test_user_name" {
  description = "Username for the test user"
  type        = string
  
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  
}
