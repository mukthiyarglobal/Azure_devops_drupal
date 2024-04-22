output "acr_id" {
  value = azurerm_container_registry.acr_demo.id
}
output "acr_login_server" {
  value = azurerm_container_registry.acr_demo.login_server
}
output "webapp_name" {
  value = azurerm_linux_web_app.webapp_demo.name
}
