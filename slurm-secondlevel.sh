#!/bin/bash

#SBATCH --job-name=seclevel
#SBATCH --account=kg98
#SBATCH --ntasks=1
# SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=2
#SBATCH --time=48:00:00
#SBATCH --mail-user=Kristina.Sabaroedin@monash.edu
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=BEGIN
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mem=56384


SCRIPTDIR=/projects/kg98/kristina/GenofCog/scripts/second_level/

module load matlab/r2016a

cd $SCRIPTDIR

matlab -nodisplay -r "seedxhemi_secondlevel; exit"
