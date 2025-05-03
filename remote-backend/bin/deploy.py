#!/usr/bin/env python3
import os
import subprocess
from pathlib import Path


########################################################
# Please manually set STAGE, DOMAIN and COMMAND
########################################################
stage = 'int'
domain = 'elb-app'
command = 'destroy'


########################################################
# Roll out backend
########################################################
# set vars
backend_file_path = f"{Path(__file__).resolve().parents[1]}/config/{stage}/{stage}-backend.tfstate"
os.chdir(Path(__file__).resolve().parents[1])
var_config = ["-var", f"domain={domain}", "-var", f"stage={stage}"]
backend_config = f"-backend-config={backend_file_path}"
state_config = f"-state={backend_file_path}"

# roll out
subprocess.run(["terraform", "init", "-reconfigure", backend_config], check=True)
subprocess.run(["terraform", command, *var_config, state_config], check=True)