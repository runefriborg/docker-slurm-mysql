# Docker SLURM+MySQL Container

Full SLURM+MySQL installation preconfigured to test different SLURM configurations. The container is running both as a controller and worker.

[SLURM](http://slurm.schedmd.com/)

## What's inside

The build contains the following users:

  root:root
  testuser:testuser

## MySQL account

  root:seCret

## SLURM is configured with the priority/multifactor2 plugin and uses MySQL for accounting

  SLURM is installed to /opt/slurm and binaries are in /opt/slurm/bin/

  This is the initial configuration for the cluster
  /opt/slurm/bin/sacctmgr -i add cluster cluster0
  /opt/slurm/bin/sacctmgr -i add account basic cluster=cluster0 Description="The One node cluster" Organization="Big O"
  /opt/slurm/bin/sacctmgr -i add user testuser DefaultAccount=basic Account=basic 

### To run the container

  > docker run -h docker.example.com \
    -p 10022:22     \ # SSHD, SFTP
    --rm -d --name slurm \
    runefriborg/docker-slurm-mysql

This will start the container with a supervisor process which will start the following daemons:

  > supervisorctl status
  munge                            RUNNING   pid 23, uptime 0:01:14
  mysqld                           RUNNING   pid 26, uptime 0:01:14
  slurmctld                        RUNNING   pid 22, uptime 0:01:14
  slurmd                           RUNNING   pid 28, uptime 0:01:14
  slurmdbd                         RUNNING   pid 24, uptime 0:01:14
  sshd                             RUNNING   pid 21, uptime 0:01:14

### To submit jobs or interact with SLURM

  * Enter the container
  
  > docker exec -it slurm /bin/bash

  From here you can run the SLURM commands in /opt/slurm/bin, reconfigure SLURM in /opt/slurm/etc and restart the daemons using supervisorctl.
  
  * Running a testjob prepared in /home/testuser/slurm.submit
  
  > su - testuser
  > sbatch slurm.submit
  Submitted batch job 1


## How to build the image

Build from this directory using the enclosed Dockerfile

  > docker build -rm -t runefriborg/docker-slurm-mysql .
