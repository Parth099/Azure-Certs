provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true
    }
  }
}

//! important
/*
Creates the Vnet and the machines, you need to do the Load Balancer stuff on Azure Portal afterwards
*/

resource "azurerm_resource_group" "rg" {
  name     = "rg-vnet-usr-lab"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet-main" {
  name                = "main-lab-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "L4"
  }
}

resource "azurerm_subnet" "subnetA" {
  name                 = "subnet-A"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnetB" {
  name                 = "subnet-B"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "subnetCentral" {
  name                 = "subnet-central"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = ["10.0.255.0/24"]
}


resource "azurerm_network_interface" "nicA" {
  name                = "nic-A"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-A-ip-config"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "nicB" {
  name                = "nic-B"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-B-ip-config"
    subnet_id                     = azurerm_subnet.subnetB.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "central_pip" {
  name                = "central-vm-pip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku               = "Basic"
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "nic_central" {
  name                 = "nic-central"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "nic-central-ip-config"
    subnet_id                     = azurerm_subnet.subnetCentral.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.central_pip.id
  }
}

// attach net-rules

resource "azurerm_network_security_group" "allow_ssh_http_nsg" {
  name                = "allow-ssh-http-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_network_security_rule" "allow_ssh_rule" {
  name                        = "Allow-SSH-In"
  priority                    = 122
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  destination_port_range      = "22"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.allow_ssh_http_nsg.name
}


resource "azurerm_network_security_rule" "allow_http_rule" {
  name                        = "Allow-HTTP-In"
  priority                    = 180
  direction                   = "Inbound"
  access                      = "Allow"
  source_port_range           = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  protocol                    = "Tcp"
  destination_port_range      = "80"
  resource_group_name         = azurerm_resource_group.rg.name
  network_security_group_name = azurerm_network_security_group.allow_ssh_http_nsg.name
}

# resource "azurerm_network_interface_security_group_association" "nsg_association_A" {
#   network_interface_id      = azurerm_network_interface.nicA.id
#   network_security_group_id = azurerm_network_security_group.allow_ssh_http_nsg.id
# }

resource "azurerm_linux_virtual_machine" "linuxVM_B" {
  name                = "linux-vm-b"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "parth"
  admin_password      = "parth34cv*!*"

  disable_password_authentication = false


  network_interface_ids = [
    azurerm_network_interface.nicB.id,
  ]

  os_disk {
    name                 = "linux-vm-b-os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.vm_image.publisher
    offer     = var.vm_image.offer
    sku       = var.vm_image.sku
    version   = var.vm_image.version
  }

  plan {
    name      = var.vm_image.plan_id
    product   = var.vm_image.product_id
    publisher = var.vm_image.publisher
  }
}

resource "azurerm_linux_virtual_machine" "central_vm" {
  name                = "central-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "parth"
  admin_password      = "parth34cv*!*"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic_central.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# https://askubuntu.com/questions/311053/how-to-make-ip-forwarding-permanent
# needs to enable os level forwarding
resource "azurerm_virtual_machine" "vm_a" {
  name                  = "linux-vm-a"
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nicA.id]
  vm_size               = "Standard_B1s"

  # since we are just playing around
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "linux-vm-a"
    admin_username = "parth"
    admin_password = "parth34cv*!*"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_route_table" "central_routing_table" {
  name                          = "cr-table"
  location                      = azurerm_resource_group.rg.location
  resource_group_name           = azurerm_resource_group.rg.name
  disable_bgp_route_propagation = false

  route {
    name                   = "flow-through-central"
    address_prefix         = "10.0.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_linux_virtual_machine.central_vm.private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "central_route_to_ssA" {
  subnet_id      = azurerm_subnet.subnetA.id
  route_table_id = azurerm_route_table.central_routing_table.id
}

resource "azurerm_subnet_route_table_association" "central_route_to_ssB" {
  subnet_id      = azurerm_subnet.subnetB.id
  route_table_id = azurerm_route_table.central_routing_table.id
}

output "central_vm_pip" {
  value = azurerm_linux_virtual_machine.central_vm.public_ip_address
}

output "central_vm_priv_ip" {
  value = azurerm_linux_virtual_machine.central_vm.private_ip_address
}
