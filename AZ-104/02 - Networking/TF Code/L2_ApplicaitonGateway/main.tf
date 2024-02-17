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
  name     = "rg-lb-lab-gateway"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "lb-lab-network"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "l2"
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

resource "azurerm_subnet" "subnetC_gateway_sn" {
  name                 = "subnet-C-gateway"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.255.0/24"]
}

resource "azurerm_public_ip" "vm_a_ip" {
  name                    = "pub-ip-a"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "l2"
  }
}

resource "azurerm_public_ip" "vm_b_ip" {
  name                    = "pub-ip-B"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "l2"
  }
}

resource "azurerm_public_ip" "gateway_ip" {
  name                    = "gateway-ip"
  location                = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  sku = "Standard"

  tags = {
    environment = "l2"
  }
}


resource "azurerm_network_interface" "nicA" {
  name                = "nic-A"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-A-ip-config"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_a_ip.id
  }
}

resource "azurerm_network_interface" "nicB" {
  name                = "nic-B"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "nic-B-ip-config"
    subnet_id                     = azurerm_subnet.subnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm_b_ip.id
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
    environment = "l2"
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

locals {
  fe_ip_config_name = "media-gateway-ip-config"
  fe_port_name      = "fe-http-port"

  backend_addr_pool_image_name = "backend-addr-pool-images"
  backend_addr_pool_video_name = "backend-addr-pool-videos"

  backend_http_settings = "backend-http-settings"

  http_listener_name = "http-listener-main"

  request_routing_rule_name = "http-routing-rule-main"

  url_rule_images_name = "url-rule-images"
  url_rule_videos_name = "url-rule-videos"

  url_path_map_name = "url-path-map"
}


//! has major issues doesnt work as intended
resource "azurerm_application_gateway" "vm_gw" {
  name                = "media-gateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 1
  }

  gateway_ip_configuration {
    name      = "gateway-ip-config"
    subnet_id = azurerm_subnet.subnetC_gateway_sn.id
  }

  frontend_ip_configuration {
    name                 = local.fe_ip_config_name
    public_ip_address_id = azurerm_public_ip.gateway_ip.id
  }

  frontend_port {
    name = local.fe_port_name
    port = 80
  }

  backend_address_pool {
    name = local.backend_addr_pool_image_name
    ip_addresses = [
      azurerm_network_interface.nicA.private_ip_address
    ]
  }

  backend_address_pool {
    name = local.backend_addr_pool_video_name
    ip_addresses = [
      azurerm_network_interface.nicB.private_ip_address
    ]
  }

  backend_http_settings {
    name                  = local.backend_http_settings
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }


  url_path_map {
    name = local.url_path_map_name

    default_backend_address_pool_name  = local.backend_addr_pool_image_name
    default_backend_http_settings_name = local.backend_http_settings

  

    path_rule {
      name                       = local.url_rule_images_name
      paths                      = ["/images/*"]
      backend_address_pool_name  = local.backend_addr_pool_image_name
      backend_http_settings_name = local.backend_http_settings
    }

    path_rule {
      name                       = local.url_rule_videos_name
      paths                      = ["/videos/*"]
      backend_address_pool_name  = local.backend_addr_pool_video_name
      backend_http_settings_name = local.backend_http_settings
    }
  }


  http_listener {
    name                           = local.http_listener_name
    frontend_ip_configuration_name = local.fe_ip_config_name
    frontend_port_name             = local.fe_port_name
    protocol                       = "Http"
  }

  request_routing_rule {
    name                       = local.request_routing_rule_name
    priority                   = 10
    rule_type                  = "Basic"
    http_listener_name         = local.http_listener_name
    backend_address_pool_name  = local.backend_addr_pool_image_name
    backend_http_settings_name = local.backend_http_settings
  }

}

output "out_vm_a_ip" {
  value = azurerm_public_ip.vm_a_ip.ip_address
}

output "out_vm_b_ip" {
  value = azurerm_public_ip.vm_b_ip.ip_address
}
