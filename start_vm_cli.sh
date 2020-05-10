#!/bin/bash

###
### start_vm_cli.sh
### Script to start saved VMs up
### Created by Faisal Khan
### faisal@irdresearch.org (Senior System Administrator)
### Updated 31-03-2011
###


echo "Starting  VM IHCC in Headless mode"  
VBoxHeadless -s IHCC &
echo "Starting  VM Interactive Reminder in Headless mode"
VBoxHeadless -s Interactive_Reminder &


## End of File
