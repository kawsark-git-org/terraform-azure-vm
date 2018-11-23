terraform {
  required_version = ">= 0.11.1"
}

variable "location" {
  description = "Azure location in which to create resources"
  default = "East US"
}

variable "environment" {
  description = "The environment for this deployment"
  default = "dev"
}

variable "resource_group_name" {
  description = "An associated resource group name"
}

variable "windows_dns_prefix" {
  description = "DNS prefix to add to to public IP address for Windows VM"
}

variable "admin_password" {
  description = "admin password for Windows VM"
  default = "pTFE1234!"
}

module "windowsserver" {
  source              = "app.terraform.io/kawsar-org/compute/azurerm"
  version             = "1.1.5"
  location            = "${var.location}"
  vm_hostname         = "demo-tfe"
  admin_password      = "${var.admin_password}"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["${var.windows_dns_prefix}"]
  vnet_subnet_id      = "${module.network.vnet_subnets[0]}"
  resource_group_name = "${var.resource_group_name}"
}

module "windowsserver2" {
  source              = "app.terraform.io/kawsar-org/compute/azurerm"
  version             = "1.1.5"
  location            = "${var.location}"
  vm_hostname         = "demo-tfe-2"
  admin_password      = "${var.admin_password}"
  vm_os_simple        = "WindowsServer"
  public_ip_dns       = ["${var.windows_dns_prefix}2"]
  vnet_subnet_id      = "${module.network2.vnet_subnets[0]}"
  resource_group_name = "${var.resource_group_name}"
}

module "network" {
  source              = "Azure/network/azurerm"
  version             = "1.1.1"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allow_ssh_traffic   = true
}

module "network2" {
  source              = "Azure/network/azurerm"
  version             = "1.1.1"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allow_ssh_traffic   = true
  vnet_name          = "network2-vnet"
}

output "windows_vm_public_name"{
  value = "${module.windowsserver.public_ip_dns_name}"
}
