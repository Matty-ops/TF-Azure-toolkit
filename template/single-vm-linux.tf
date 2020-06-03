# Description file for single instance VM Linux
# Author: Matthieu MINET - Capgemini Technology Services
# Include: NIC, NSG and SSH allow rule, VM, Managed Disks

# Create a NIC
resource "azurerm_network_interface" "VMNAMEnic001" {
  name                = "VMNAMEnic001"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  ip_configuration 	{
    name                          = var.subnet_name
    subnet_id                     = azurerm_subnet.subnet-env.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    environment = var.this_environment
  }
}

# Create a NSG Group
resource "azurerm_network_security_group" "VMNAMEnsg001" {
  name                = "VMNAMEnsg001"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  tags     = {
    environment         = var.this_environment
  }
}

# Create NSG rule "Allow SSH subnet"
resource "azurerm_network_security_rule" "VMNAMEnsg001rule1" {
  name                        = "SSH"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.VMNAMEnsg001.name
}

# Creation association NIC - NSG
resource "azurerm_network_interface_security_group_association" "VMNAMEnic001nsg001asso" {
  network_interface_id      = azurerm_network_interface.VMNAMEnic001.id
  network_security_group_id = azurerm_network_security_group.VMNAMEnsg001.id
}

# Create the Virtual Machine
resource "azurerm_linux_virtual_machine" "VMNAME" {
  name                			= "VMNAME"
  resource_group_name 			= var.resource_group_name
  location            			= var.resource_group_location
  size                			= var.vm_size
  admin_username      			= var.admin_username
  admin_password      			= var.admin_password
  disable_password_authentication 	= false
  network_interface_ids 		= [
    azurerm_network_interface.VMNAMEnic001.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.storage_account_type
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  tags = {
    environment = var.this_environment
  }
}

# Create Managed Disk
resource "azurerm_managed_disk" "VMNAMEdsk" {
  count                = "1"
  name                 = "VMNAMEdsk00${count.index}"
  location             = var.resource_group_location
  resource_group_name  = var.resource_group_name
  storage_account_type = var.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = "64"
  tags 		       = {
    environment = var.this_environment
  }
}

# Create Data disks attachment
resource "azurerm_virtual_machine_data_disk_attachment" "VMNAMEdskatt" {
  count = "1"
  managed_disk_id    = azurerm_managed_disk.VMNAMEdsk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.VMNAME.id
  lun                = "${count.index}"
  caching            = "None"
}

# Outputs
output "VMNAME_hostname" {
  value       = azurerm_linux_virtual_machine.VMNAME.name
  description = "The VMNAME hostname"
}
output "VMNAME_private_ip_address" {
  value       = azurerm_linux_virtual_machine.VMNAME.private_ip_address
}
