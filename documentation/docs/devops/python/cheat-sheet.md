---
title: "python Cheat Sheet"
tags:
  - python
comments: true
---

# python Cheat Sheet

## pretty print json

```python
import json

j = {"foo": ["bar" "baz"], "spam": "eggs" }
print(json.dumps(j, indent=4))
```

python3 main.py | jq

```json
{
    "foo": [
        "barbaz"
    ],
    "spam": "eggs"
}
```

Сохранение в json file

```python
def save_json(data, file_name: str = "tmp") -> None:
    with open(f"{file_name}.json", "w") as outfile:
        json.dump(data, outfile, indent=4)
```


## Профилирование / Debug, etc.

Декоратор для замера времени выполнения функций

```python
import logging

def profile(func):
    def wrap(*args, **kwargs):
        started_at = time.time()
        result = func(*args, **kwargs)
        logging.warning(f"function:{func.__name__}, time: {time.time() - started_at}")
        return result
    return wrap
```


## AWS - boto3

Получение api кредов, по named профайлу

```python
from configparser import ConfigParser
from pathlib import PosixPath, Path

import boto3

def aws_api_init(aws_named_profile: str) -> tuple:
    """
    Получаем креды от амазона по имени профайла из ~/.aws/credentials
    """
    home: PosixPath = PosixPath(Path.home())
    config = ConfigParser()
    config.read(f"{str(home)}/.aws/credentials")
    aws_id, aws_key = config.get(aws_named_profile, "aws_access_key_id"), config.get(
        aws_named_profile, "aws_secret_access_key"
    )
    return aws_id, aws_key


i, k = aws_api_init("my-profile")

sts_api = boto3.client(
    service_name="sts",
    aws_access_key_id=i,
    aws_secret_access_key=k,
)
aws_account_id = sts_api.get_caller_identity()["Account"]
```
