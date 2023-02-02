terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.41"
    }
  }

  backend "azurerm" {}
}

provider "azurerm" {
  use_oidc = true
  features {

  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.project}"
  location = var.location

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_key_vault" "key_vault" {
  name                        = "kv-${var.project}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.resource_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false #Should be true when using in production!
  enable_rbac_authorization   = true
  sku_name                    = "standard"

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_role_assignment" "pipeline_to_keyvault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "op_users_to_keyvault" {
  scope                = azurerm_key_vault.key_vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = "43f1039a-630c-4208-a37c-cfa1047872ab"
}

resource "azurerm_key_vault_secret" "secret" {
  name         = "SuperSecret"
  value        = var.secret_value
  key_vault_id = azurerm_key_vault.key_vault.id
}
