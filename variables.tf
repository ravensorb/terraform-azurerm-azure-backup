variable "name" {
  description = "Name of the azure file storage instance"
  default     = "backup"
}

variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = true
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = "rg-filestorage"
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = "eastus2"
}

variable "resource_prefix" {
  description = "(Optional) Prefix to use for all resoruces created (Defaults to resource_group_name)"
  default     = ""
}

variable "recovery_services_vault_name" {
  description = "(Optional) Indicates the name of recovery services vault to be created"
  default     = ""
}

variable "recovery_services_vault_sku" {
  description = "(Optional) Indicates the sku for the recovery services value to use during creation"
  default     = "Standard"
}

variable "recovery_services_vault_storage_mode" {
  description = "(Optional) Indicates the mode for the recovery storage vault"
  default     = "LocallyRedundant"

  validation {
    condition = contains(["LocallyRedundant"], var.recovery_services_vault_storage_mode)
    error_message = "The value must be set to one of the following: LocallyRedundant"
  }
}

variable "backup_policy_type" {
  description = "(Optional) Indicates which version type to use when creating the backup policy"
  default     = "V2"

  validation {
    condition = contains(["V1","V2"], var.backup_policy_type)
    error_message = "The value must be set to one of the following: V1, V2"
  }
}

variable "backup_policy_time_zone" {
  description = "(Optional) Indicates the timezone that the policy will use"
  default     = "UTC"
}

variable "backup_policy_frequency" {
  description = "(Optional) Indicate the fequency to use for the backup policy"
  default     = "Daily"

  validation {
    condition = contains(["Daily"], var.backup_policy_frequency)
    error_message = "The value must be set to one of the following: Daily"
  }
}

variable "backup_policy_time" {
  description = "(Optional) Indicates the time for when to execute the backup policy"
  default     = "23:00"
}

variable "backup_policy_retention_daily_count" {
  description = "(Optional) Indicates the number of daily backups to retain (set to blank to disable)"
  type        = number
  default     = 7
}

variable "backup_polcy_retention_weekly_count" {
  description = "(Optional) Indicates the number of weekly backups to retain (set to blank to disable)"
  type        = number
  default     = 4
}

variable "backup_policy_retention_weekly_weekdays" {
  description = "(Optional) Indicates which days of the week the weekly backup will be taken"
  type        = set(string)
  default     = [ "Saturday" ]

  validation {
    condition = can([for s in var.backup_policy_retention_weekly_weekdays : contains([ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ], s)])
    error_message = "The value must contain one of the following: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday"
  }
}

variable "backup_polcy_retention_monthly_count" {
  description = "(Optional) Indicates the number of monthly backups to retain (set to blank to disable)"
  type        = number
  default     = 6
}

variable "backup_policy_retention_monthly_weekdays" {
  description = "(Optional) Indicates which days of the week the monthly backup will be taken"
  type        = set(string)
  default     = [ "Saturday" ]

  validation {
    condition = can([for s in var.backup_policy_retention_monthly_weekdays : contains([ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" ], s)])
    error_message = "The value must contain one of the following: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday"
  }
}

variable "backup_virtual_machines" {
  description = "Contains the list virtual machines that will be backed up"
  type        = list(object({
    name                = string 
    resource_group_name = string
  }))
  default = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
