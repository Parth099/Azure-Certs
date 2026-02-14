variable "dns_domain" {
  description = "Domain name in use for this lesson"
  type        = string
  default     = "aws.tapped-in.net"
}

variable "fwd_domain" {
  description = "Domain name in use for this lesson to represent the on-premises domain"
  type        = string
  default     = "corp.tapped-in.net"
}


