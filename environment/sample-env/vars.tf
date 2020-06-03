# Generic Environment variables declaration file
# Values should be configured on current directory file: "terraform.tfvars"

### Generic declaration variables for Service principal use
# Azure Service Principal variables (refer to Azure subscription)
variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}
variable "ARM_TENANT_ID" {}

### Variables related to subscription or environment
# Generic Resource Group 
variable "resource_group_name" {
  default = "myenvapprg"
  description = "The name of the resource group"
}
variable "resource_group_location" {
  default = "westeurope"
  description = "The location of the resource group"
}
variable "this_environment" {
  default = "myenv"
  description = "The environment name"
}

# Generic Virtual Network 
variable "virtual_network_name" {
  default = "myenvappvnet"
}
variable "virtual_network_ip_range" {
  default = ["10.0.0.0/16"]
}
variable "virtual_network_peering_name" {
  default = "myenvappvnetprg"
}

# Generic Subnet
variable "subnet_name" {
  default = "sapenvappsub"
}
variable "subnet_address_prefix" {
  default = "10.0.2.0/24"
}

# Generic Storage Account
variable "storage_account_name" {
  default = "envappsa"
}
variable "storage_account_type" {
  default = "Standard_LRS"
}
variable "storage_account_replication_type" {
  default = "LRS"
}
variable "storage_account_tier" {
  default = "Standard"
}
# Extra Virtual Machine Variables
variable "vm_size" {
  default = "Standard_F2S_V2"
  description = "Default Azure VM size"
}
variable "admin_username" {
  default = "PlayWithUs"
}
variable "admin_password" {
  default = "P@ssword-Ex@mple2020"
}
