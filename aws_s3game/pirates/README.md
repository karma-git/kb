# PIRATES S3GAME

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

