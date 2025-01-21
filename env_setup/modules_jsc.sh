#!/bin/bash
ml --force purge
ml use $OTHERSTAGES
ml Stages/2025

ml CUDA/12
ml cuDNN/9.5.0.50-CUDA-12

ml GCC/13.3.0
ml GCCcore/.13.3.0

ml OpenMPI/5.0.5

ml Cartopy/0.24.1
ml SciPy-Stack/2024a
ml dask/2024.9.1
ml ecCodes/2.39.0
ml netcdf4-python/1.7.1.post2
