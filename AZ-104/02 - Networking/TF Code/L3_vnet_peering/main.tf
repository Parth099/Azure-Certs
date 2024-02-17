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
  name     = "rg-vnet-peering-lab"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet-main" {
  name                = "main-lab-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "L3"
  }
}

resource "azurerm_subnet" "subnetA-main" {
  name                 = "subnet-A"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-main.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_virtual_network" "vnet-secondary" {
  name                = "secondary-lab-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]

  tags = {
    environment = "L3"
  }
}

resource "azurerm_subnet" "subnetA-secondary" {
  name                 = "subnet-A"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet-secondary.name
  address_prefixes     = ["10.1.0.0/24"]
}


resource "azurerm_public_ip" "nicA_pip" {
  name                    = "nicA-pip"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  sku = "Basic"

  tags = {
    environment = "L3"
  }
}

resource "azurerm_network_interface" "nicA" {
  name                = "nic-A"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-A-ip-config"
    subnet_id                     = azurerm_subnet.subnetA-main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.nicA_pip.id
  }
}

resource "azurerm_network_interface" "nicB" {
  name                = "nic-B"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-B-ip-config"
    subnet_id                     = azurerm_subnet.subnetA-secondary.id
    private_ip_address_allocation = "Dynamic"
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

resource "azurerm_network_interface_security_group_association" "nsg_association_A" {
  network_interface_id      = azurerm_network_interface.nicA.id
  network_security_group_id = azurerm_network_security_group.allow_ssh_http_nsg.id
}

resource "azurerm_network_interface_security_group_association" "nsg_association_B" {
  network_interface_id      = azurerm_network_interface.nicB.id
  network_security_group_id = azurerm_network_security_group.allow_ssh_http_nsg.id
}


resource "azurerm_linux_virtual_machine" "linuxVM0" {
  name                = "linux-vm-a"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "parth"
  admin_password      = "parth34cv*!*"

  disable_password_authentication = false


  network_interface_ids = [
    azurerm_network_interface.nicA.id,
  ]

  os_disk {
    name                 = "linux-vm-a-os-disk"
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

resource "azurerm_linux_virtual_machine" "linuxVM1" {
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

resource "azurerm_virtual_network_peering" "vnet_main_to_secondary" {
  name                = "main-to-secondary-peering"
  resource_group_name = azurerm_resource_group.rg.name

  virtual_network_name      = azurerm_virtual_network.vnet-main.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-secondary.id

  allow_virtual_network_access = true # default
  allow_forwarded_traffic      = true

  triggers = {
    remote_addr_space = join("", azurerm_virtual_network.vnet-secondary.address_space)
  }
}

resource "azurerm_virtual_network_peering" "vnet_secondary_to_main" {
  name                = "secondary-to-main-peering"
  resource_group_name = azurerm_resource_group.rg.name

  virtual_network_name      = azurerm_virtual_network.vnet-secondary.name
  remote_virtual_network_id = azurerm_virtual_network.vnet-main.id

  allow_virtual_network_access = true # default
  allow_forwarded_traffic      = true

  triggers = {
    remote_addr_space = join("", azurerm_virtual_network.vnet-main.address_space)
  }
}

output "vm_a_public_adr" {
  value = azurerm_linux_virtual_machine.linuxVM0.public_ip_address
}


output "vm_b_public_adr" {
  value = azurerm_linux_virtual_machine.linuxVM1.public_ip_address
}


output "vm_a_private_adr" {
  value = azurerm_linux_virtual_machine.linuxVM0.private_ip_address
}


output "vm_b_private_adr" {
  value = azurerm_linux_virtual_machine.linuxVM1.private_ip_address
}

