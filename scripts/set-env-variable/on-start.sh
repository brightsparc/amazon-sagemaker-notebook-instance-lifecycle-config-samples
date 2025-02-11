#!/bin/bash

set -e

# OVERVIEW
# This script gets value from Notebook Instance's tag and sets it as environment
# variable for all process including Jupyter in SageMaker Notebook Instance
# Note that this script will fail this condition is not met
#   1. Ensure the Notebook Instance execution role has permission of SageMaker:ListTags
#

# PARAMETERS
YOUR_ENV_VARIABLE_NAME=your_env_variable_name

NOTEBOOK_ARN=$(jq '.ResourceArn' /opt/ml/metadata/resource-metadata.json --raw-output)
TAG=$(aws sagemaker list-tags --resource-arn $NOTEBOOK_ARN  | jq .'Tags[] | select(.Key == "$YOUR_ENV_VARIABLE_NAME").Value' --raw-output)
touch /etc/profile.d/jupyter-env.sh
echo "export $YOUR_ENV_VARIABLE_NAME=$TAG" >> /etc/profile.d/jupyter-env.sh
initctl restart jupyter-server --no-wait
