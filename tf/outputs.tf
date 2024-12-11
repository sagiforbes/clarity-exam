output "cloudfront-url"{
  value=module.cloudfront.domain_name
}

output "cloudfront-distribution"{
  value=module.cloudfront.distribution_id
}