#!/bin/bash

export OLD_PATH_LPC_DASK=${PATH}
export OLD_PYTHONPATH_LPC_DASK=${PYTHONPATH}
export LPC_DASK_ROOT=$(realpath `dirname "${BASH_SOURCE[0]}"`)

source /cvmfs/sft.cern.ch/lcg/views/LCG_98python3/x86_64-centos7-gcc8-opt/setup.sh
export PYTHONPATH=${OLD_PYTHONPATH_LPC_DASK}

source ${LPC_DASK_ENV_DIR}/bin/activate

export PYTHONPATH=${LPC_DASK_ROOT}:${PYTHONPATH}
export PATH=${LPC_DASK_ROOT}/bin:${PATH}

function deactivate () 
{
    if [ -n "${LPC_DASK_ROOT:-}" ]; then
        unset LPC_DASK_ROOT;
    fi;
    if [ -n $"{OLD_PATH_LPC_DASK:-}" ]; then
	PATH="${OLD_PATH_LPC_DASK:-}";
	export PATH;
    fi;
    if [ -n $"{OLD_PYTHONPATH_LPC_DASK:-}" ]; then
	PYTHONPATH="${OLD_PYTHONPATH_LPC_DASK:-}";
	export PYTHONPATH;
    fi;
    if [ -n "${_OLD_VIRTUAL_PATH:-}" ]; then
        PATH="${_OLD_VIRTUAL_PATH:-}";
        export PATH;
        unset _OLD_VIRTUAL_PATH;
    fi;
    if [ -n "${_OLD_VIRTUAL_PYTHONHOME:-}" ]; then
        PYTHONHOME="${_OLD_VIRTUAL_PYTHONHOME:-}";
        export PYTHONHOME;
        unset _OLD_VIRTUAL_PYTHONHOME;
    fi;
    if [ -n "${BASH:-}" -o -n "${ZSH_VERSION:-}" ]; then
        hash -r;
    fi;
    if [ -n "${_OLD_VIRTUAL_PS1:-}" ]; then
        PS1="${_OLD_VIRTUAL_PS1:-}";
        export PS1;
        unset _OLD_VIRTUAL_PS1;
    fi;
    unset VIRTUAL_ENV;
    if [ ! "$1" = "nondestructive" ]; then
        unset -f deactivate;
    fi
}
