# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "${var.prefix}-PublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.prefix}-NSG"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  # Note, these rules are hopeless
  # TODO: Fix to individual rules, see https://cloudinfrastructureservices.co.uk/how-to-setup-a-new-active-directory-2016-2019-forest-domain-in-azure-aws-gcp-iaas/
  security_rule {
    name                       = "ADServerTCP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "53-3269"
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "ADServerUDP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "53-445"
    source_address_prefix      = var.source_address_prefix
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.prefix}-NIC"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "${var.prefix}-NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = azurerm_virtual_machine.vm.resource_group_name
  depends_on          = [azurerm_virtual_machine.vm]
}

output "public_ip_address" {
  value = data.azurerm_public_ip.ip.ip_address
}
