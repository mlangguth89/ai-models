#!/bin/bash -x
#SBATCH --account=hclimrep
#SBATCH --nodes=1
#SBATCH --ntasks=1
##SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=48
#SBATCH --output=%x-out.%j
#SBATCH --error=%x-err.%j
#SBATCH --time=00:10:00
#SBATCH --gres=gpu:1
##SBATCH --partition=booster
#SBATCH --partition=develbooster
#SBATCH --mail-type=ALL
#SBATCH --mail-user=m.langguth@fz-juelich.de

# environmental variables to support cpus_per_task with Slurm>22.05
export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK}
export SRUN_CPUS_PER_TASK="${SLURM_CPUS_PER_TASK}"

# basic directories
WORK_DIR=$(pwd)
BASE_DIR=$(dirname "${WORK_DIR}")

# Name of virtual environment
VENV_DIR=${BASE_DIR}/virtual_envs/
VIRT_ENV_NAME=venv_jwb  			# !!! ADAPT HERE !!!

echo ${VENV_DIR}/${VIRT_ENV_NAME}
# Loading mouldes
source ${BASE_DIR}/env_setup/modules_jsc.sh
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


# parameters 					!!! ADAPT HERE !!!
output_dir=${BASE_DIR}/forecast_output/
model=panguweather                                  # only panguweather is supported for now
grb_file=${BASE_DIR}/input_data/pgw_input_20230110T1200.grib  # as obtained from get_input_data.sh 

# run job
srun ai-models --assets ${BASE_DIR}/model_assets/ --file ${grb_file} --path ${output_dir}/${model}'-out-{step}.grib' ${model}
