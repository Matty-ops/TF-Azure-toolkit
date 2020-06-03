# Generic create Infrastructure base 
# Available for Cloud Azure only
# Permit deployment of resources below:
#  # A private virtual network
#  # A subnet associated
#  # A Resource group
#  # A Storage account
# Pre-requisities:
# - An Azure subscription already configured
# - Each variables have to declared (elements prefixed characters "var.")

## Create a resource group
resource "azurerm_resource_group" "rg-env" {
  name     = var.resource_group_name
  location = var.resource_group_location
  tags     = {
    environment 	= var.this_environment
  }
}

## Create a virtual network within the resource group
resource "azurerm_virtual_network" "vnet-env" {
  depends_on = [azurerm_resource_group.rg-env,]
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = var.virtual_network_ip_range
  tags     = {
    environment         = var.this_environment
  }
}

## Create the subnet
resource "azurerm_subnet" "subnet-env" {
  depends_on = [azurerm_resource_group.rg-env,azurerm_virtual_network.vnet-env]
  name                 = var.subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefix       = var.subnet_address_prefix
}

## Create a storage account
resource "azurerm_storage_account" "stoacc-env" {
  depends_on = [azurerm_resource_group.rg-env,]
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = var.storage_account_tier
  account_replication_type = var.storage_account_replication_type
  tags     = {
    environment         = var.this_environment
  }
}

