#!/bin/bash
# A shell script to deploy VM resources on Azure for non production environment
# Written by: Matthieu MINET
# Last updated on: 20/05/2020
# -------------------------------------------------------
 
# Verify the type of input and number of values
# Exit the shell script with a status of 1 using exit 1 command.
[ $# -ne 3 ] && { echo "Usage: $0 environment vm_name os_type"; echo "- environment: environment name should exist"; echo "- os_type: [linux|windows]"; exit 1; }
 
#required variable
environment_name=$1
vm_name=$2
os_type=$3

#Set vars
TMPL_SRC_PATH="../template"
TMPL_SRC_PATH_VM_FILE="$TMPL_SRC_PATH/single-vm-$os_type.tf"
TARGET_PATH="../environment/$environment_name"
TARGET_PATH_VM_FILE="$TARGET_PATH/$vm_name.tf"

#  VM deployment
# Check environment
if [ -d $TARGET_PATH ]; then
	# Check VM name
	if [ ! -e $TARGET_PATH_VM_FILE ]; then
		# copy vm template
		cp -pv $TMPL_SRC_PATH_VM_FILE $TARGET_PATH_VM_FILE
	
		# Configure VM hostname
		sed -i "s/VMNAME/$vm_name/g" $TARGET_PATH_VM_FILE

		# Plan deployment with Terraform
		cd $TARGET_PATH
		terraform plan -out $environment_name.plan

		# Apply deployment with Terraform
		terraform apply $environment_name.plan
	else
		echo -e "Error: Virtual Machine: $vm_name already exist in this environment \n Aborted!"
		exit 1
	fi
else
   echo -e "Error: environment: \"$environment_name\" does not exist \nEnsure environment is properly deployed"; exit 1
fi
