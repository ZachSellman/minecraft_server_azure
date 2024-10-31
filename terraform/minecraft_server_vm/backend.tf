terraform {
 backend "azurerm" {
  resource_group_name = "zsellab-tfstate-rg"
  storage_account_name = "zsellabtfstatestorage"
  container_name = "tfstatecontainer"
  key = "terraform.tfstate"
 } 
}