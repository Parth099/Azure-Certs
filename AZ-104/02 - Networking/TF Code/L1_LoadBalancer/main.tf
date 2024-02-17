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
  name     = "rg-lb-lab"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "lb-lab-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "L1"
  }
}

resource "azurerm_subnet" "subnetA" {
  name                 = "subnet-A"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "subnetB" {
  name                 = "subnet-B"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
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

// VM Portion

resource "azurerm_availability_set" "vm_avail_set" {
  name                = "linux-aset"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  platform_fault_domain_count  = 3
  platform_update_domain_count = 5

  tags = {
    environment = "l1"
  }
}


resource "azurerm_linux_virtual_machine" "linuxVM0" {
  name                = "linux-vm-a"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
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

  availability_set_id = azurerm_availability_set.vm_avail_set.id
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


  availability_set_id = azurerm_availability_set.vm_avail_set.id
}

// lb

resource "azurerm_public_ip" "lb_ip" {
  name                = "public-ip-for-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "vm_lb" {
  name                = "vm-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  frontend_ip_configuration {
    name                          = "vm-lb-ip-public-config"
    public_ip_address_id          = azurerm_public_ip.lb_ip.id
    private_ip_address_allocation = "Dynamic"
  }

  sku = "Standard"
}

resource "azurerm_lb_backend_address_pool" "vm_lb_addr_pool" {
  loadbalancer_id = azurerm_lb.vm_lb.id
  name            = "linux-vm-BackEndAddressPool"
}

// bind vm nic to backend pool
resource "azurerm_network_interface_backend_address_pool_association" "vm_lb_nic_addr_pool_assoc_a" {
  network_interface_id    = azurerm_network_interface.nicA.id
  ip_configuration_name   = "nic-A-ip-config"
  backend_address_pool_id = azurerm_lb_backend_address_pool.vm_lb_addr_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "vm_lb_nic_addr_pool_assoc_b" {
  network_interface_id    = azurerm_network_interface.nicB.id
  ip_configuration_name   = "nic-B-ip-config"
  backend_address_pool_id = azurerm_lb_backend_address_pool.vm_lb_addr_pool.id
}

resource "azurerm_lb_probe" "vm_lb_http_health_rule" {
  loadbalancer_id = azurerm_lb.vm_lb.id
  name            = "http-80-probe"
  port            = 80
  protocol        = "Http"

  request_path        = "/"
  interval_in_seconds = 30
}

resource "azurerm_lb_rule" "vm_lb_http_rule" {
  loadbalancer_id                = azurerm_lb.vm_lb.id
  name                           = "http-nginx-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "vm-lb-ip-public-config"

  probe_id = azurerm_lb_probe.vm_lb_http_health_rule.id

  backend_address_pool_ids = [
    azurerm_lb_backend_address_pool.vm_lb_addr_pool.id
  ]
}

output "lb_ip" {
  value = azurerm_public_ip.lb_ip.ip_address
}





