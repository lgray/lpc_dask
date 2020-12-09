# lpc_dask
scripts and such for running dask on the lpc condor cluster

## To setup
```bash
ssh -l <username> cmslpc-sl7.fnal.gov
# set directory to where you want to setup your work area
git clone https://github.com/lgray/lpc_dask.git
${PWD}/lpc_dask/create_dask_environment.sh
source ${PWD}/lpc_dask/env.sh
```

Make sure to add the export statement to your login profile!!!!

## To run a simple example on the lpc (takes ~10 minutes total from scratch):
```bash
# From within the environment setup above...
python -i /path/to/lpc_dask/simple_example.py
```

## To re-enter environment:
```bash
source /path/to/lpc_dask/env.sh
```
