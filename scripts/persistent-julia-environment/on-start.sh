#!/bin/bash

set -e

# OVERVIEW
# This script creates a symbolic link for ~/.julia to be hosted under SageMaker directory

mkdir -p /home/ec2-user/SageMaker/.julia
ln -s /home/ec2-user/SageMaker/.julia ~/.julia 

# Create a julia file to install jupyter notebook kernel

cat << EOF > /tmp/install_kernel.julia
# Install package manager
using Pkg
Pkg.add("IJulia")

# Install julia jupyter kernel
using IJulia
IJulia.installkernel("Julia nodeps", "--depwarn=no")

# Install any other libraries
EOF

# This the activates the julia conda enviroment to install Julia and Juypter package

sudo -u ec2-user -i <<'EOF'
unset SUDO_UID

KERNEL_NAME="julia"

WORKING_DIR=/home/ec2-user/SageMaker/$KERNEL_NAME-miniconda/
source "$WORKING_DIR/miniconda/bin/activate"

conda activate "$KERNEL_NAME"

# Install Julia
conda install --yes -c conda-forge Julia

# Install Jupyter kernel 
julia /tmp/install_kernel.julia
EOF

echo "Restarting the Jupyter server.."
restart jupyter-server