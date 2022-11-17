output "resource_group_name" {
  description = "The name of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
}

output "resource_group_id" {
  description = "The id of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.id, azurerm_resource_group.rg.*.id, [""]), 0)
}

output "resource_group_location" {
  description = "The location of the resource group in which resources are created"
  value       = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
}

# Vnet and Subnets
output "azurerm_backup_policy_vm_id" {
  description = "The id of the backup policy"
  value       = element(concat(resource.azurerm_backup_policy_vm.policy.*.id, [""]), 0)
}

output "azurerm_backup_protected_vm_id" {
  description = "The id of the backup protected vm resource"
  value       = element(concat(resource.azurerm_backup_protected_vm.vm.*.id, [""]), 0)
}

output "azurerm_recovery_services_vault_id" {
  description = "The id of the recover services vault"
  value       = element(concat(resource.azurerm_recovery_services_vault.vault.*.id, [""]), 0)
}

output "azurerm_recovery_services_vault_name" {
  description = "The name of the recover services vault"
  value       = element(concat(resource.azurerm_recovery_services_vault.vault.*.name, [""]), 0)
}

