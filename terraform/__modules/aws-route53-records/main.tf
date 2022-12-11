data "aws_route53_zone" "this" {
  zone_id = var.zone_id
}

resource "aws_route53_record" "this" {
  for_each = var.records

  zone_id = data.aws_route53_zone.this.zone_id
  name    = "${each.key}.${data.aws_route53_zone.this.name}"
  type    = each.value["type"]
  ttl     = each.value["ttl"]
  records = [each.value["record"]]
}
