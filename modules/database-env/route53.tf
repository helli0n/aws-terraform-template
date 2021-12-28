resource "aws_route53_record" "my-domain-database-record" {
  zone_id = var.ROUTE53_ZONE_ID
  name    = "db-${var.ENV_NAME}-my-domain.com"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_db_instance.my_database.address]
}
