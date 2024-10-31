output "public_ip_address" {
  description = "The generated public ip address for the new server"
  value = azurerm_public_ip.minecraft_public_ip.ip_address
}

