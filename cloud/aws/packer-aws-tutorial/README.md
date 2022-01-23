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

Check AMI's id's:
```shell
❯ aws ec2 describe-images \
    --filters "Name=tag:Name,Values='Packer Builder'" \
    --query 'Images[*].[ImageId]' \
    --output json \
  | jq -r '.[][]'
ami-02e51fc4092022bf4
ami-096b13b8c8ff5db12
```
