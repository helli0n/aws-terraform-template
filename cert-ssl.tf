resource "aws_acm_certificate" "my-domain-ssl" {
  domain_name       = "my-domain.com"
  subject_alternative_names = ["*.my-domain.com"]
  validation_method = "DNS"

  tags = {
    Environment = "dev"
    Terraform = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "my-domain" {
  name         = "my-domain.com"
  private_zone = false
}

resource "aws_route53_record" "my-domain-ssl-dns" {
  for_each = {
  for dvo in aws_acm_certificate.my-domain-ssl.domain_validation_options : dvo.domain_name => {
    name   = dvo.resource_record_name
    record = dvo.resource_record_value
    type   = dvo.resource_record_type
  }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.my-domain.zone_id
}

resource "aws_acm_certificate_validation" "my-domain-ssl" {
  certificate_arn         = aws_acm_certificate.my-domain-ssl.arn
  validation_record_fqdns = [for record in aws_route53_record.my-domain-ssl-dns : record.fqdn]
}
