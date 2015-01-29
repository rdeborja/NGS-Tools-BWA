#!/bin/bash

# This is an autogenerated script for Torque PBS

#PBS -S /bin/bash
#PBS -N sample_bwa_mem.8CC55286-A7D8-11E4-9B0A-9EE8FC347D86
#PBS -e /Users/richard de borja/local/src/perl/NGS-Tools-BWA/bin/log
#PBS -o /Users/richard de borja/local/src/perl/NGS-Tools-BWA/bin/log
#PBS -V
#PBS -l vmem=32g
#PBS -l walltime=240:00:00


module load  bwa samtools

# change to the working directory
cd /Users/richard de borja/local/src/perl/NGS-Tools-BWA/bin

bwa mem -t 1 -R @RG\tID:8CC453CC-A7D8-11E4-9B0A-9EE8FC347D86\tSM:sample\tLB:library\tPL:ILLUMINA\tPU:NONE\tCN:ca.sickkids.dplm  ref.fa 1.fq.gz 2.fq.gz | samtools view -S -b - > 1.sam

echo EXIT STATUS $?

echo Job ${PBS_JOBID} -- ${PBS_JOBNAME} Complete!
