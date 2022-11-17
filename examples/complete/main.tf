# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "azure-backup" {
	source  = "ravensorb/azure-backup/azurerm"

	# Name of the azure file sync instance (default "backup")
	name = "backup"

	# By default, this module will create a resource group, proivde the name here
	# to use an existing resource group, specify the existing resource group name, 
	# and set the argument to `create_resource_group = false`. Location will be same as existing RG. 

	# Whether to create resource group and use it for all networking resources (default "true")
	create_resource_group = true
	# A container that holds related resources for an Azure solution (default "rg-filesync")
	resource_group_name = "rg-backup"

	# The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' (default "eastus2")
	location = "eastus2"

	# (Optional) Prefix to use for all resoruces created (Defaults to resource_group_name)
	resource_prefix = "shared-backup"

	# (Optional) Indicates the name of recovery services vault to be created
	recovery_services_vault_name = "rsv"

    # (Optional) Indicates the sku for the recovery services value to use during creation
	recovery_services_vault_sku = "Standard"

    # (Optional) Indicates which version type to use when creating the backup policy
	backup_policy_type = "V2"

	# (Optional) Indicate the fequency to use for the backup policy
	backup_policy_frequency = "Daily"

	# (Optional) Indicates the time for when to execute the backup policy
	backup_policy_time = "23:00"

	# (Optional) Indicates the number of daily backups to retain (set to blank to disable)
	backup_policy_retention_daily_count = 7

	# (Optional) Indicates the number of weekly backups to retain (set to blank to disable)
	backup_polcy_retention_weekly_count = 4

	# (Optional) Indicates the number of monthly backups to retain (set to blank to disable)
	backup_polcy_retention_monthly_count = 6

	# Indicates the name of the virtual machine to backup
	virtual_machine_name = "vm-name"

	# Adding TAG's to your Azure resources (Required)
	tags = {
		CreatedBy   = "Shawn Anderson"
		CreatedOn   = "2022/11/16"
		CostCenter  = "IT"
		Environment = "PROD"
		Critical    = "YES"
		Location    = "eastus2"
		Solution    = "backup"
		ServiceClass = "Gold"
	}
}
