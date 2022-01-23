# Overview
WIP
## [Build an Image](https://learn.hashicorp.com/tutorials/packer/aws-get-started-build-image?in=packer/aws-get-started)
> We could export default profile instead of aws api keys:
> 
> ```shell
> export AWS_DEFAULT_PROFILE=karma-it-aws
> ```

**default** commands:
```shell
$ packer init . # download provider
$ packer fmt .
$ packer validate .
```

<details>
<summary>AMI ids</summary>

```shell
❯ aws ec2 describe-images \
    --filters "Name=tag:Name,Values='Packer Builder'" \
    --query 'Images[*].[ImageId]' \
    --output json \
  | jq -r '.[][]'
ami-02e51fc4092022bf4
ami-096b13b8c8ff5db12
```
</details>

## [Provision](https://learn.hashicorp.com/tutorials/packer/aws-get-started-provision?in=packer/aws-get-started)

Configure base image via provisioner (shell or ansible)

<details>
<summary>AMI ids</summary>

```shell
❯ aws ec2 describe-images \
    --filters "Name=tag:Name,Values='Packer Builder'" \
    --query 'Images[*].[ImageId]' \
    --output json | jq -r '.[][]'
ami-01b0623ebfe43be21
ami-02e51fc4092022bf4
ami-096b13b8c8ff5db12
```
</details>

## [Variables](https://learn.hashicorp.com/tutorials/packer/aws-get-started-variables?in=packer/aws-get-started)

HCL variables in packer template.

<details>
<summary>AMI ids</summary>

```shell
❯ aws ec2 describe-images \      
    --filters "Name=tag:Name,Values='Packer Builder'" \
    --query 'Images[*].[ImageId]' \
    --output json | jq -r '.[][]'
ami-01b0623ebfe43be21
ami-02e51fc4092022bf4
ami-04b58f24e894180a4
ami-096b13b8c8ff5db12
```
</details>
