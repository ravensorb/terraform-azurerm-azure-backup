#---------------------------------
# Local declarations
#---------------------------------
locals { 
  name                = var.name == "" ? "-backup" : "-${var.name}"
  resource_group_name = element(coalescelist(data.azurerm_resource_group.rgrp.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  resource_prefix     = var.resource_prefix == "" ? local.resource_group_name : var.resource_prefix
  location            = element(coalescelist(data.azurerm_resource_group.rgrp.*.location, azurerm_resource_group.rg.*.location, [""]), 0)

  virtual_machines = { 
    for idx, vm in var.backup_virtual_machines : vm.name => {
       idx : idx,
       vm : vm,
    }
  }


  timeout_create  = "180m"
  timeout_update  = "60m"
  timeout_delete  = "60m"
  timeout_read    = "60m"
}

#---------------------------------------------------------
# Resource Group Creation or selection - Default is "true"
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = merge({ "ResourceName" = "${var.resource_group_name}" }, var.tags, )
}

#-------------------------------------
## Recovery Services
#-------------------------------------

resource "azurerm_recovery_services_vault" "vault" {
  name                = var.recovery_services_vault_name != null ? var.recovery_services_vault_name : "${local.resource_prefix}-bvault"
  location            = var.location
  resource_group_name = local.resource_group_name
  sku                 = var.recovery_services_vault_sku != null ? var.recovery_services_vault_sku : "Standard"
  storage_mode_type   = var.recovery_services_vault_storage_mode != null ? var.recovery_services_vault_storage_mode : "LocallyRedundant"
  
  #cross_region_restore_enabled = var.recovery_servuces_vault_cross_region_restore_enabled
}

#-------------------------------------
## Backup Policy
#-------------------------------------

resource "azurerm_backup_policy_vm" "policy" {
  name                = "${local.resource_prefix}-bkpol"
  resource_group_name = local.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  policy_type         = var.backup_policy_type != null ? var.backup_policy_type : "V2"

  timezone = var.backup_policy_time_zone != null ? var.backup_policy_time_zone : "UTC"

  backup {
    frequency = var.backup_policy_frequency != null ? var.backup_policy_frequency : "Daily"
    time      = var.backup_policy_time != null ? var.backup_policy_time : "23:00"
  }

  dynamic "retention_daily" {
    for_each = var.backup_policy_retention_daily_count != "" ? [1] : []

    content {
      count = var.backup_policy_retention_daily_count
    }
  }

  dynamic "retention_weekly" {
    for_each = var.backup_polcy_retention_weekly_count != "" ? [1] : []

    content {
      count = var.backup_polcy_retention_weekly_count
      weekdays = var.backup_policy_retention_weekly_weekdays != null ? var.backup_policy_retention_weekly_weekdays : [ "Saturday" ]
    }
  }

  dynamic "retention_monthly" {
    for_each = var.backup_polcy_retention_monthly_count != "" ? [1] : []

    content {
      count = var.backup_polcy_retention_monthly_count
      weekdays  = var.backup_policy_retention_monthly_weekdays != null ? var.backup_policy_retention_monthly_weekdays : [ "Saturday" ]
      weeks     = [ "Last" ]
    }
  }  

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
    update  = local.timeout_update
  }
}

#-------------------------------------
## Enable Backups for VMs
#-------------------------------------

data "azurerm_virtual_machine" "vm" {
  for_each            = local.virtual_machines

  name                = each.value.vm.name
  resource_group_name = each.value.vm.resource_group_name != "" ? each.value.vm.resource_group_name : local.resource_group_name
}

resource "azurerm_backup_protected_vm" "vm" {
  for_each            = local.virtual_machines

  resource_group_name = local.resource_group_name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name
  backup_policy_id    = azurerm_backup_policy_vm.policy.id

  source_vm_id        = data.azurerm_virtual_machine.vm[each.value.vm.name].id

  timeouts {
    create  = local.timeout_create
    delete  = local.timeout_delete
    read    = local.timeout_read
    update  = local.timeout_update
  }
}
