variable "admin_username" {
  type        = string
  description = "Administrator user name for virtual machine"
}

variable "admin_password" {
  type        = string
  description = "Password must meet Azure complexity requirements"
}
variable "source_address_prefix" {
  type = string
  description = "Public IP of local administrator PC"
}

resource "azurerm_virtual_machine" "vm" {
  name                  = "${var.prefix}-VM"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.dc_settings["vm_size"]


  storage_os_disk {
    name          = "${var.prefix}-OsDisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_image_reference {
    publisher = var.dc_settings["publisher"]
    offer     = var.dc_settings["offer"]
    sku       = var.dc_settings["sku"]
    version   = var.dc_settings["version"]
  }

  os_profile {
    computer_name  = "${var.prefix}-VM"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_windows_config {}

  plan {
    name = var.dc_settings["offer"]
    publisher = var.dc_settings["publisher"]
    product = var.dc_settings["offer"]
  }
}
