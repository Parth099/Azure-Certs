variable "s3_bucket_name" {
  default     = "static-website-ppatel"
  description = "Name of the S3 bucket to be created for hosting the static website."
}

variable "r53_domain_info" {
  description = "Information about the Route 53 hosted zone and domain to be used for the CloudFront distribution."
  default = {
    zoneID = "Z08734813PWVJ63LWITOP"
    domain = "tapped-in.net"
  }
  type = object({
    zoneID = string
    domain = string
  })
}

variable "cloudfront_ssl_info" {
  description = "Custom CNAME for the CloudFront distribution."
  default = {
    cname               = "cdn"
    acm_certificate_arn = "arn:aws:acm:us-east-1:736722722662:certificate/084ea296-ce13-43d5-8021-0bfd34bcd94f"
  }
  type = object({
    cname               = string
    acm_certificate_arn = string
  })
}
