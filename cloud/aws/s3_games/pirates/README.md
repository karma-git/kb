# PIRATES S3GAME
[PIRATES S3GAME](https://s3game.workshop.aws/pirates.html)
## level1 - Public access
Check content of the public accessible bucket and download an object.
<details>
  <summary>Solution</summary>

  ```
# List of the objects inside the bucket
$ aws s3 ls s3://s3game-level1
2020-06-01 11:58:46      24361 S3game.png
2020-04-20 09:39:19       1568 level1-hint2.html
2020-04-20 09:39:19       1484 level1-hint3.html
2020-04-20 09:39:19       1566 level1-hint4.html
2020-04-20 15:28:16       2240 level1.html
2020-06-01 12:09:01       1936 s3game.html
2020-05-02 11:08:53        115 treasure1
# Download the tresure file
$ aws s3 cp s3://s3game-level1/treasure1 ~/s3
download: s3://s3game-level1/treasure1 to ./treasure1
# Look inside
$ cat treasure1

The secret code is 748l6b6xwzl6

Go to https://s3game-level2.s3.us-east-2.amazonaws.com/level2-748l6b6xwzl6.html
  ```
</details>

## level2 - Get Specific object by its ID
Download object from a bucket by ID
<details>
  <summary>Solution</summary>

  ```
# Dowload object by id 
$ aws s3 cp s3://s3game-level2/treasure2 ~/s3
download: s3://s3game-level2/treasure2 to ./treasure2
$ cat treasure2

The secret is 76qp7mlpzyg1

Strange signs are scratched on the lid of the treasure chest:
AKIAZBIEGK7GRYHVNWVB  LUw4lLBfmwuEEcU24v4uDHUZ7I3yps3OJD1Qj8Dh

Go to https://s3game-level3.s3.us-east-2.amazonaws.com/level3-76qp7mlpzyg1.html
  ```
- bucket id - 76qp7mlpzyg1
- aws_access_key_id = AKIAZBIEGK7GRYHVNWVB
- aws_secret_access_key = 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
</details>

## level3 - Metadata
Access s3 with AWS credentials and check an object metadata
<details>
  <summary>Solution</summary>

  ```
You will need access key id and secret access key for move forward.

You can specify them as env vars or add them to `~/.aws/credentials`, for example:
$ cat ~/.aws/credentials
[default]
aws_access_key_id = 
aws_secret_access_key = 
[s3game]
aws_access_key_id = AKIAZBIEGK7GRYHVNWVB
aws_secret_access_key = LUw4lLBfmwuEEcU24v4uDHUZ7I3yps3OJD1Qj8Dh
# bucket list
$ aws s3 ls s3://s3game-level3 --profile s3game
2020-04-20 09:44:08       1721 level3-76qp7mlpzyg1-hint2.html
2020-04-20 09:44:08       1787 level3-76qp7mlpzyg1-hint3.html
2020-04-20 14:22:48       1873 level3-76qp7mlpzyg1-hint4.html
2020-04-20 15:27:42       1990 level3-76qp7mlpzyg1.html
2020-05-02 11:12:11        234 treasure3_has_no_secret_code
# or just perform fallowing:
# aws configure --profile s3game
> AWS Access Key ID
> AWS Secret Access Key
> Default region name - us-east-2
# download
$ aws s3 cp s3://s3game-level3/treasure3_has_no_secret_code ~/s3 --profile s3game
download: s3://s3game-level3/treasure3_has_no_secret_code to s3/treasure3_has_no_secret_code
# content
$ cat treasure3_has_no_secret_code

Hm... the chest is empty :(
Let's look around, may be secret code is somewhere else...

Think about where else the code can be hidden?

Find the code and go to https://s3game-level4-<THE CODE>.s3.us-east-2.amazonaws.com/level4.html
# Check file metadata
$ aws s3api head-object --bucket s3game-level3 --key treasure3_has_no_secret_code --profile s3game
{
    "AcceptRanges": "bytes",
    "LastModified": "Sat, 02 May 2020 08:12:11 GMT",
    "ContentLength": 234,
    "ETag": "\"6244574e387025dec9b9b589773d4d29\"",
    "ContentType": "binary/octet-stream",
    "Metadata": {
        "x-amz-meta-secret-code": "k73045aztqln"
    }
}
  ```
</details>

## level4 - Tags
Check an object tags
<details>
  <summary>Solution</summary>
You can find "treasure4_also_has_no_secret_code" object inside the bucket, but there is also no code inside the object. 
  
```
$ aws s3api get-object-tagging \
--bucket s3game-level4-k73045aztqln \
--key treasure4_also_has_no_secret_code \
--profile s3game
{
    "TagSet": [
        {
            "Key": "secret_code",
            "Value": "8v95e5rv7z4i"
        }
    ]
}
```
</details>

## level5 - Versioning
Find content of the file with deletion flag
<details>
  <summary>Solution</summary>
You can't find treasure file inside the bucket via "$ aws s3 ls"
  
```
# check versions
$ aws s3api list-object-versions \
 --bucket s3game-level5-8v95e5rv7z4i \
 --profile s3game
{
    "Versions": [
        {
            "ETag": "\"e3545f5babf2f5ca5a9d20f7475f80ab\"",
            "Size": 2005,
            "StorageClass": "STANDARD",
            "Key": "level5-hint2.html",
            "VersionId": "4mtBa02BZXl0VmlqgATEHowXt8tZXG0U",
            "IsLatest": true,
            "LastModified": "2020-05-02T08:35:32.000Z"
        },
        {
            "ETag": "\"065243c07c0def3a89cd4cecbfc541be\"",
            "Size": 2802,
            "StorageClass": "STANDARD",
            "Key": "level5-hint3.html",
            "VersionId": "L_ItpNnJP4JdD6Un1PgnN0xh0FRMlMlo",
            "IsLatest": true,
            "LastModified": "2020-05-02T08:35:32.000Z"
        },
        {
            "ETag": "\"d1c7352e9fd72245033351307a9f9600\"",
            "Size": 1698,
            "StorageClass": "STANDARD",
            "Key": "level5-hint4.html",
            "VersionId": "IUn.kO1XCAfz12qPwiRG54US2pnAIddI",
            "IsLatest": true,
            "LastModified": "2020-04-20T11:08:44.000Z"
        },
        {
            "ETag": "\"4b546131739176fef59000341bf03b37\"",
            "Size": 1648,
            "StorageClass": "STANDARD",
            "Key": "level5.html",
            "VersionId": "ArJDlk1MizLIM0r4f6_EjOUaJkN.6HtN",
            "IsLatest": true,
            "LastModified": "2020-04-20T11:04:58.000Z"
        },
        {
            "ETag": "\"9693f24274d7ec88a8563d662c34be99\"",
            "Size": 126,
            "StorageClass": "STANDARD",
            "Key": "treasure5_is_deleted",
            "VersionId": "344PQOyFqocF0TI66MbLynNNdQqHfBz3",
            "IsLatest": false,
            "LastModified": "2020-05-02T08:20:06.000Z"
        }
    ],
    "DeleteMarkers": [
        {
            "Key": "treasure5_is_deleted",
            "VersionId": "EtCsdZVg383Pj4qEB9XzjPKwMWMMd_d8",
            "IsLatest": true,
            "LastModified": "2020-05-02T08:20:38.000Z"
        }
    ]
}
# download specific version of an object
$ aws s3api get-object \
--bucket s3game-level5-8v95e5rv7z4i \
--key treasure5_is_deleted \
--version-id 344PQOyFqocF0TI66MbLynNNdQqHfBz3 \
--profile s3game \
treasure5 # output file name
{
    "AcceptRanges": "bytes",
    "LastModified": "Sat, 02 May 2020 08:20:06 GMT",
    "ContentLength": 126,
    "ETag": "\"9693f24274d7ec88a8563d662c34be99\"",
    "VersionId": "344PQOyFqocF0TI66MbLynNNdQqHfBz3",
    "ContentType": "binary/octet-stream",
    "Metadata": {}
}
```
</details>

## level6 - S3 select
Query via SQL from an object
<details>
  <summary>Solution</summary>

  ```
$ aws s3api select-object-content \
--bucket s3game-level6-vjv45x1gux81 \
--key s3select.csv.gz \
--expression "SELECT * FROM s3object WHERE category = 'TREASURE'" \
--expression-type 'SQL' \
--input-serialization '{"CSV": {"FileHeaderInfo": "USE", "FieldDelimiter": ";"}, "CompressionType": "GZIP"}' \
--output-serialization '{"CSV": {}}' "treasure6" \
--profile s3game

$ cat treasure6
2117,"8,96E+11",16/11/1993,Double Jeopardy!,TREASURE,1000,What is the fastest way to find something in a big dataset on S3?,Go to https://s3game-level7-zhovpo4j8588.s3.us-east-2.amazonaws.com/level7.html
  ```
</details>

## level7 - Presigned URL
Temporary url
<details>
  <summary>Solution</summary>

  ```
$ aws s3api get-object \
--bucket s3game-level7-zhovpo4j8588 \
--key somethingstrange \
--profile s3game \
treasure7 # output
{
    "AcceptRanges": "bytes",
    "LastModified": "Wed, 07 Jul 2021 02:45:03 GMT",
    "ContentLength": 1180,
    "ETag": "\"bf7e1571a49f9d63f76fd81eef803290\"",
    "ContentType": "binary/octet-stream",
    "Metadata": {}
}
# open link from the file (via curl)
$ curl $(cat treasure7)

The code is v6g8tp7ra2ld

Find the code and go to https://s3game-level8-v6g8tp7ra2ld.s3.us-east-2.amazonaws.com/level8.html
 ```
</details>

## level8 - CloudFront
Access an object via CloudFront
<details>
  <summary>Solution</summary>
Check bucket content via "$ aws s3 ls"

  ```
# You can find tresure object name via s3 ls
$ curl d2suiw06vujwz3.cloudfront.net/treasure8_CDN

The code is 781xtls2quvy

Find the code and go to https://s3game-level9-781xtls2quvy.s3.us-east-2.amazonaws.com/level9.html
 ```
</details>

## level9 - Referer
Operate http request
<details>
  <summary>Solution</summary>

  ```
$ curl https://s3game-level9-781xtls2quvy.s3.us-east-2.amazonaws.com/treasure9_referer \
--refer http://s3game.treasure

The code is gac6tf83erp6

Find the code and go to https://s3game-level10-gac6tf83erp6.s3.us-east-2.amazonaws.com/level10.html
  ```
</details>

## level10 - Storage Classes
Get an object from a bucket by storage class
<details>
  <summary>Solution</summary>

  ```
# access to next bucket by "Key"
$ aws s3api list-objects \
--bucket s3game-level10-gac6tf83erp6 \
--query 'Contents[?StorageClass == `STANDARD_IA`]' \
--profile s3game
[
    {
        "Key": "djq30a807iyq",
        "LastModified": "2020-05-23T16:56:46.000Z",
        "ETag": "\"b29bd78cd969aec7862407ff045d8aeb\"",
        "Size": 128,
        "StorageClass": "STANDARD_IA"
    }
]
  ```
</details>

## level11 - Encryption
Access an encrypted object
<details>
  <summary>Solution</summary>

  ```
$ aws s3 cp \
--sse-c 'AES256' \
--sse-c-key 'UkXp2s5v8y/B?E(H+MbPeShVmYq3t6w9' \
's3://s3game-level11-djq30a807iyq/treasure11_encryption' \
--profile s3game \
treasure11
  ```
[url inside the final treasure](https://s3game-level12-bk0m5ax5n92o.s3.us-east-2.amazonaws.com/level12.html) 
</details>

