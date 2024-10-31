resource "azurerm_resource_group" "minecraft_server_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_network_security_group" "minecraft_nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_server_rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_virtual_network" "minecraft_vn" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_server_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "minecraft_subnet" {
  name                              = var.subnet_name
  address_prefixes                  = ["10.0.1.0/24"]
  resource_group_name               = azurerm_resource_group.minecraft_server_rg.name
  virtual_network_name              = azurerm_virtual_network.minecraft_vn.name
  private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
}

resource "azurerm_subnet_network_security_group_association" "nsg_association_minecraft" {
  subnet_id                 = azurerm_subnet.minecraft_subnet.id
  network_security_group_id = azurerm_network_security_group.minecraft_nsg.id
}

resource "azurerm_public_ip" "minecraft_public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_server_rg.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "minecraft_network_interface" {
  name                = var.network_interface_name
  location            = var.location
  resource_group_name = azurerm_resource_group.minecraft_server_rg.name
  

  ip_configuration {
    name                          = "minecraft_ip_configuration"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.minecraft_subnet.id
    public_ip_address_id          = azurerm_public_ip.minecraft_public_ip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_association_minecraft" {
  network_interface_id          = azurerm_network_interface.minecraft_network_interface.id
  network_security_group_id = azurerm_network_security_group.minecraft_nsg.id
}

resource "azurerm_linux_virtual_machine" "name" {
  name                  = var.virtual_machine_name
  location              = var.location
  resource_group_name   = azurerm_resource_group.minecraft_server_rg.name

  admin_username        = "adminuser"
  size                  = "Standard_D2ps_v5"
  priority              = "Spot"
  eviction_policy       = "Deallocate"
  network_interface_ids = [
    azurerm_network_interface.minecraft_network_interface.id
]
  
  admin_ssh_key {
    username   = "adminuser"
    public_key = file(var.public_key)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-arm64"
    version   = "latest"
  }
}

#resources needed:

# virtual network? - DONE

# subnet? - UNSURE

# network interface? - DONE
#ip_config^ - DONE

#virtual_machine
# storage_image_reference
# storage_os_disk
# os_profile
# os_profile_linux_config