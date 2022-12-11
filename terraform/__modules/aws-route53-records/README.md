## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_records"></a> [records](#input\_records) | object with data for aws\_route53\_record | <pre>map(object({<br>    type   = optional(string, "CNAME")<br>    ttl    = optional(number, 300)<br>    record = string<br>  }))</pre> | n/a | yes |
| <a name="input_zone_id"></a> [zone\_id](#input\_zone\_id) | aws\_route53\_zone.id | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_records"></a> [records](#output\_records) | n/a |
