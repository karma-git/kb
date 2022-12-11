## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.59.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.59.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.source_others](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_access_point.source_root](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_mount_target.destanation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [local_file.k8s](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [aws_efs_access_point.destanation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_access_point) | data source |
| [aws_efs_access_point.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_access_point) | data source |
| [aws_efs_access_points.destanation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_access_points) | data source |
| [aws_efs_access_points.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_access_points) | data source |
| [aws_efs_file_system.destanation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_file_system) | data source |
| [aws_efs_file_system.source](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/efs_file_system) | data source |
| [template_file.k8s](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_destanation_efs_id"></a> [destanation\_efs\_id](#input\_destanation\_efs\_id) | EFS which restored from backup | `string` | `""` | no |
| <a name="input_source_efs_id"></a> [source\_efs\_id](#input\_source\_efs\_id) | EFS which needs to be restored | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets to which dest EFS should be attached | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_k8s"></a> [k8s](#output\_k8s) | rendered k8s manifests |
