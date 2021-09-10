#!/bin/bash

PROFILE_A=$1
PROFILE_B=$2
ROLE_A_NAME=$3

# Get role-a arn
a_arn=$(aws iam list-roles --query "Roles[?RoleName == '$ROLE_A_NAME'].[RoleName, Arn]" --profile "$PROFILE_A" | jq -r '.[][1]')

# asssume role
role_assume=$(aws sts assume-role --role-arn "$a_arn" --role-session-name "session" --profile "$PROFILE_B")

# export aws env vars
export AWS_ACCESS_KEY_ID=$(echo "$role_assume" | jq -r '.Credentials.AccessKeyId');
export AWS_SECRET_ACCESS_KEY=$(echo "$role_assume" | jq -r '.Credentials.SecretAccessKey');
export AWS_SESSION_TOKEN=$(echo "$role_assume" | jq -r '.Credentials.SessionToken');

aws s3 ls
