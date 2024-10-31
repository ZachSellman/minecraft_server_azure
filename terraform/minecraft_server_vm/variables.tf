variable "subscription_id" {
    description = "The subscription id used by Azure account."
    # This is filled by local variable from running command source ~/.profile in the terminal before terraform commands.
}

variable "public_key" {
    description = "The SSH public key to be passed to the VM's authorized_keys file."
}

variable "virtual_machine_name" {
    description = "Name of the VM to be created."
}

variable "location" {
    description = "The location which all resources shall be created within."
}

variable "resource_group_name" {
    description = "Name of the Azure Resource Group to be created and hold all new resources."
}

variable "network_interface_name" {
    description = "Name of the NIC to be used by the VM."
}

variable "virtual_network_name" {
    description = "Name of the Virtual Network to be used by the VM."
}

variable "public_ip_name" {
    description = "The name of the Public IP resource to be created for the VM."
}

variable "subnet_name" {
    description = "Name of the Subnet resource to be created inside the Virtual Network"
}

variable "nsg_name" {
    description = "Name of the network security group to be applied to the Virtual Network."
}