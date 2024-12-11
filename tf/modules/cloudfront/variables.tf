variable "bucket_name" {
  description = "Name of the S3 bucket for static files for cloudfront"
  type        = string
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
}
