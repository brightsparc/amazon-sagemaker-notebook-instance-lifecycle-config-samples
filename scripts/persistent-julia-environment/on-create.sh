#!/bin/bash

set -e

# OVERVIEW
# This script installs a custom, persistent installation of conda with julia support.
# 
# The on-create script downloads and installs a custom conda installation to the EBS volume via Miniconda. Any relevant packages can be installed here 
#   1. ipykernel is installed to   
#   2. Ensure the Notebook Instance has internet connectivity to download the Miniconda installer
#
# For another example, see https://docs.aws.amazon.com/sagemaker/latest/dg/nbi-add-external.html#nbi-isolated-environment

sudo -u ec2-user -i <<'EOF'
unset SUDO_UID

MINICONDA_VERSION="4.7.12"
KERNEL_NAME="julia"

# Install a separate conda installation via Miniconda
WORKING_DIR=/home/ec2-user/SageMaker/$KERNEL_NAME-miniconda
mkdir -p "$WORKING_DIR"
wget https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -O "$WORKING_DIR/miniconda.sh"
bash "$WORKING_DIR/miniconda.sh" -b -u -p "$WORKING_DIR/miniconda" 
rm -rf "$WORKING_DIR/miniconda.sh"

# Create a custom conda environment
source "$WORKING_DIR/miniconda/bin/activate"

conda create --yes --name "$KERNEL_NAME" 
EOF