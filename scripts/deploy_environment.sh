#!/bin/bash
# A shell script to deploy environment resources on Azure
# Written by: Matthieu MINET
# Last updated on: 03/06/2020
# -------------------------------------------------------
 
# Verify the type of input and number of values
# Exit the shell script with a status of 1 using exit 1 command.
[ $# -ne 2 ] && { echo "Usage: $0 environment filename"; exit 1; }
 
#required variable
environment_name=$1
filename=$2

#Set vars
ENV_SRC_PATH="../environment/sample-env"
ENV_DST_PATH="../environment/$environment_name"

# Build environment structure
if [ ! -d $ENV_DST_PATH ]; then
	
	# copy environment structure
	cp -pvr $ENV_SRC_PATH $ENV_DST_PATH

	# Copy environment_name-terraform.tfvars file for environment sourcing
	cp -pvr $filename $ENV_DST_PATH/terraform.tfvars

	# Set environment value for base resources
	echo "this_environment = \"${environment_name}\"" >> $ENV_DST_PATH/terraform.tfvars
	echo "resource_group_name = \"${environment_name}-rg\"" >> $ENV_DST_PATH/terraform.tfvars
	echo "virtual_network_name = \"${environment_name}-vnet\"" >> $ENV_DST_PATH/terraform.tfvars
	echo "subnet_name = \"${environment_name}-sub\"" >> $ENV_DST_PATH/terraform.tfvars
	echo "storage_account_name = \"${environment_name}appsa\"" >> $ENV_DST_PATH/terraform.tfvars

	# Init terraform environment
	cd $ENV_DST_PATH
	terraform init
fi


# Plan deployment with Terraform
cd $ENV_DST_PATH
terraform plan -out $environment_name.plan

# Apply deployment with Terraform
terraform apply $environment_name.plan
