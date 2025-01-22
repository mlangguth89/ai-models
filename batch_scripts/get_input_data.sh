#!/bin/bash 
#######################################################################
# Batch-script to download input data for data-driven forecast models #
# of the ai-models package.                                           #
######################################################################

# basic directories
WORK_DIR=$(pwd)
BASE_DIR=$(dirname "${WORK_DIR}")

# Name of virtual environment
VENV_DIR=${BASE_DIR}/virtual_envs/
VIRT_ENV_NAME=venv_jwb               # !!! ADAPT HERE !!!

# Loading mouldes
echo "Load modules from software stack..."
source ../env_setup/modules_jsc.sh

# Activate virtual environment if needed (and possible)
if [ -z ${VIRTUAL_ENV} ]; then
   if [[ -f ${VENV_DIR}/${VIRT_ENV_NAME}/bin/activate ]]; then
      echo "Activating virtual environment..."
      source ${VENV_DIR}/${VIRT_ENV_NAME}/bin/activate
   else
      echo "ERROR: Requested virtual environment ${VIRT_ENV_NAME} not found..."
      exit 1
   fi
fi

# parameters  !!! ADAPT HERE !!!
input_dir=${BASE_DIR}/input_data
date=20230114                     	# format: YYYYMMDD
time=1200				# Choose either 0000 or 1200 (UTC)
model="panguweather"
data_source="cds"			# Choose either 'cds' or 'mars' (ensure that you have access to the services)

# output of ai-models is redirected to LOGFILE and displayed
LOGFILE=${BASE_DIR}/logs/download_data_${date}T${time}_${model}.log

# run download process
if [ "$data_source" == "cds"  ]; then
   echo "Download input data for ${date} ${time} UTC of model ${model} via CDS."
  
   ai-models --assets ${BASE_DIR}/model_assets/ --load_input_only -input_dir ${input_dir} --input cds --date ${date} --time ${time} ${model} 2>&1 | tee ${LOGFILE}
elif [ "$data_source" == "mars"  ]; then
   echo "Download input data for yesterday 1200 UTC of model {model} via MARS."
   
   ai-models --assets ${BASE_DIR}/model_assets/ --load_input_only -input_dir ${input_dir} ${model} | tee ${LOGFILE} 
else
   echo "Unknown data_source: $data_source"
fi
