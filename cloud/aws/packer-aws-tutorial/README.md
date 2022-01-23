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

## [Post-Processors - Vagrant](https://learn.hashicorp.com/tutorials/packer/aws-get-started-post-processors-vagrant?in=packer/aws-get-started)

Create vagrant box.

> but why it's needed for aws provider?

<details>
<summary>result</summary>

AMI's
```shell
❯ aws ec2 describe-images \                                 
    --filters "Name=tag:Name,Values='Packer Builder'" \
    --query 'Images[*].[ImageId]' \
    --output json | jq -r '.[][]'
ami-01b0623ebfe43be21
ami-02e51fc4092022bf4
ami-04b58f24e894180a4
ami-054721ce3ebf41c05
ami-096b13b8c8ff5db12
ami-0c7ec4b23ced2087e
```
final dir structure
```shell
.
├── README.md
├── ansible
│   └── playbook.yml
├── aws-ubuntu.pkr.hcl
└── packer_ubuntu_aws.box

1 directory, 4 files
```
md5 hash
```shell
❯ md5 packer_ubuntu_aws.box                        
MD5 (packer_ubuntu_aws.box) = fb647c98e016b7eaf38efccb9fde88f4
```

box on vagrant cloud https://app.vagrantup.com/karma-kit/boxes/packer-training

</details>
