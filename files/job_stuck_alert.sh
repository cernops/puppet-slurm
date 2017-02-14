#!/bin/bash

ps aux | grep mpi && echo "A Slurm job was canceled, but it is stuck at $HOSTNAME, and cannot be killed. Please investigate." | /usr/bin/mutt -s "Slurm job stuck at $HOSTNAME" -c nils.hoimyr@cern.ch -c philippe.yves.ganz@cern.ch carolina.lindqvist@cern.ch
