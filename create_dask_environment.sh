#!/bin/bash

export LPC_DASK_ROOT=$(dirname "${BASH_SOURCE[0]}")
source ${LPC_DASK_ROOT}/bin/make_dask_user_env.sh

echo "Please put the following environment variable in your login script:"
echo "export LPC_DASK_ENV_DIR=${LPC_DASK_ENV_DIR}"
echo 
