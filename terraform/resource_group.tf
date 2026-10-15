resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.azure_location

  tags = merge(var.common_tags, {
    Component = "foundation"
    Tier      = "platform"
  })
}
