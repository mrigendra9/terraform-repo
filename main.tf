resource "azurerm_resource_group" "rgname" {
  name     = "uat-rgname"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-network"
  address_space       = ["192.168.10.0/24"]
  location            = azurerm_resource_group.rgname.location
  resource_group_name = azurerm_resource_group.rgname.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "internal1"
  resource_group_name  = azurerm_resource_group.rgname.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.10.0/25"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "internal2"
  resource_group_name  = azurerm_resource_group.rgname.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.10.128/25"]
}

resource "azurerm_network_interface" "internal1" {
  name                = "internal1-nic"
  location            = azurerm_resource_group.rgname.location
  resource_group_name = azurerm_resource_group.rgname.name

  ip_configuration {
    name                          = "internal1-ipconfig"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "internal2" {
  name                = "internal2-nic"
  location            = azurerm_resource_group.rgname.location
  resource_group_name = azurerm_resource_group.rgname.name

  ip_configuration {
    name                          = "internal2-ipconfig"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
  }

}
resource "azurerm_linux_virtual_machine" "linuxvm1" {
  name                = "vmltest01"
  resource_group_name = azurerm_resource_group.rgname.name
  location            = azurerm_resource_group.rgname.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd123!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.internal1.id,
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

resource "azurerm_linux_virtual_machine" "linuxvm2" {
  name                = "vmltest02"
  resource_group_name = azurerm_resource_group.rgname.name
  location            = azurerm_resource_group.rgname.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd123!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.internal2.id,
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