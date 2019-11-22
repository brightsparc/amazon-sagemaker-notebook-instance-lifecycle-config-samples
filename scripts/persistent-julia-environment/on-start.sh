#!/bin/bash

set -e

# OVERVIEW
# This script install julia libraries and kernel
#

cat << EOF > /tmp/install_kernel.julia
# Install package manager
using Pkg
Pkg.add("IJulia")

# Install julia jupyter kernel
using IJulia
IJulia.installkernel("Julia nodeps", "--depwarn=no")

# Install any other libraries
EOF

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