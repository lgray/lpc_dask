#!/bin/bash

mkdir -p ${PWD}/logs

export LPC_DASK_NAME=dask_venv_${USER}
export LPC_DASK_ENV_DIR=${PWD}/${LPC_DASK_NAME}

source /cvmfs/sft.cern.ch/lcg/views/LCG_98python3/x86_64-centos7-gcc9-opt/setup.sh
python -m venv ${LPC_DASK_NAME}
source ${LPC_DASK_ENV_DIR}/bin/activate

export PYTHONPATH=""
export PATH=${LPC_DASK_ENV_DIR}/bin:${PATH}

export lcgprefix=/cvmfs/sft.cern.ch/lcg/views/LCG_98python3/x86_64-centos7-gcc9-opt/lib/python3.7/site-packages/

ln -sf ${lcgprefix}/pyxrootd ${LPC_DASK_NAME}/lib/python3.7/site-packages/pyxrootd
ln -sf ${lcgprefix}/XRootD ${LPC_DASK_NAME}/lib/python3.7/site-packages/XRootD

pip install --upgrade pip wheel --no-cache-dir
pip install dask[dataframe] distributed dask-jobqueue coffea[dask] --no-cache-dir

deactivate

echo "Dask environment created at ${LPC_DASK_ENV_DIR}"
