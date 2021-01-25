variable "location" {}

variable "prefix" {}

variable "dc_settings" {
  type = map(any)
  default = {
    vm_size   = "Standard_A1_v2"
    publisher = "cloud-infrastructure-services"
    offer     = "ad-dc-2019"
    sku       = "ad-dc-2019"
    version   = "latest"
  }
}
