#!/bin/bash

source /cvmfs/sft.cern.ch/lcg/views/LCG_98python3/x86_64-centos7-gcc9-opt/setup.sh
python -m venv dask_venv
source dask_venv/bin/activate

export PYTHONPATH=""
export PATH=${PWD}/dask_venv/bin:${PATH}

export lcgprefix=/cvmfs/sft.cern.ch/lcg/views/LCG_98python3/x86_64-centos7-gcc9-opt/lib/python3.7/site-packages/

ln -sf ${lcgprefix}/pyxrootd dask_venv/lib/python3.7/site-packages/pyxrootd
ln -sf ${lcgprefix}/XRootD dask_venv/lib/python3.7/site-packages/XRootD

pip install --upgrade pip wheel --no-cache-dir
pip install dask[dataframe] distributed coffea[dask] --no-cache-dir
pip list

echo "Dask worker environment created at ${PWD}/dask_venv"

/bin/pwd
/bin/uname -a
/bin/hostname

echo $@

$@


