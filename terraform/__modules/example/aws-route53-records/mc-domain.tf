module "mc_domain" {
  source = "../../_modules/aws-route53-records"

  zone_id = data.aws_route53_zone.mc_domain.id
  records = {
    "foo"  = { "record" : local.lb },
    "bar"  = { "record" : "127.0.0.1", "type": "A" },
  }
}
