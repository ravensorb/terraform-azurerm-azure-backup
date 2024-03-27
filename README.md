# Azure Backup Terraform module DIMA

Take advantage of fully managed backup of virtual machines in the cloud.

Azure Backup provides independent and isolated backups to guard against unintended destruction of the data on your VMs. Backups are stored in a Recovery Services vault with built-in management of recovery points. Configuration and scaling are simple, backups are optimized, and you can easily restore as needed.

## Module Usage

```hcl
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
	# A container that holds related resources for an Azure solution (default "rg-backup")
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

    # Contains the list virtual machines that will be backed up
    backup_virtual_machines = [
		{ 
			name                = "vm"
			resource_group_name = "vm-rg"
		}
	]

	# (Optional) Indicates the resource group for the vm (defaults to same resource group as the backup vault)
  	virtual_machine_resource_group_name = "rg-vm"

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

```

## Create resource group

By default, this module will create a resource group and the name of the resource group to be given in an argument `resource_group_name`. If you want to use an existing resource group, specify the existing resource group name, and set the argument to `create_resource_group = false`.

> *If you are using an existing resource group, then this module uses the same resource group location to create all resources in this module.*

## Requirements

Name | Version
----- | --------
terraform | >= 0.13
azurerm | >= 2.59.0

## Providers

Name | Version | 
------ | --------- | 
azurerm | >= 2.59.0

## Inputs

Name | Description | Type | Default
---- | ----------- | ---- | -------
`name` | Name of the azure file storage instance | `string` | `filestorage`
`create_resource_group` | Whether to create resource group and use it for all networking resources | `boolean` | `true`
`resource_group_name` | A container that holds related resources for an Azure solution | `string` | `rg-filestorage`
`location` | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `eastus2`
`resource_prefix` | (Optional) Prefix to use for all resoruces created (Defaults to resource_group_name) | `string` | ``
`recovery_services_vault_name` | (Optional) Indicates the name of recovery services vault to be created | `string` | ``
`recovery_services_vault_sku` | (Optional) Indicates the sku for the recovery services value to use during creation | `string` | `Standard`
`backup_policy_type` | (Optional) Indicates which version type to use when creating the backup policy | `string` | `V2`
`backup_policy_frequency` | (Optional) Indicate the fequency to use for the backup policy | `string` | `Daily`
`backup_policy_time` | (Optional) Indicates the time for when to execute the backup policy | `string` | `23:00`
`backup_policy_retention_daily_count` | (Optional) Indicates the number of daily backups to retain (set to blank to disable) | `string` | `7`
`backup_polcy_retention_weekly_count` | (Optional) Indicates the number of weekly backups to retain (set to blank to disable) | `string` | `4`
`backup_policy_retention_weekly_weekdays` | (Optional) Indicates which days of the week the monthly backup will be taken | `set(string)` | `[ "Saturday" ]`
`backup_polcy_retention_monthly_count` | (Optional) Indicates the number of monthly backups to retain (set to blank to disable) | `string` | `6`
`backup_policy_retention_monthly_weekdays` | (Optional) Indicates which days of the week the monthly backup will be taken | `set(string)` | `[ "Saturday" ]`
`backup_virtual_machines` | (Optional) Contains the list virtual machines that will be backedup | `list(object)` | ``
`tags` | A map of tags to add to all resources | `map(string)` | `{}`

## Outputs

Name | Description
---- | -----------
`resource_group_name` | The name of the resource group in which resources are created
`resource_group_id` | The id of the resource group in which resources are created
`resource_group_location` | The location of the resource group in which resources are created
`azurerm_backup_policy_vm_id` | The id of the backup policy
`azurerm_backup_protected_vm_id` | The id of the backup protected vm resource
`azurerm_recovery_services_vault_id` | The id of the recover services vault
`azurerm_recovery_services_vault_name` | The name of the recover services vault
`azurerm_backup_protected_vm_ids` | The id of the backup protected vm

## Recommended naming and tagging conventions

Well-defined naming and metadata tagging conventions help to quickly locate and manage resources. These conventions also help associate cloud usage costs with business teams via chargeback and show back accounting mechanisms.

> ### Resource naming

An effective naming convention assembles resource names by using important resource information as parts of a resource's name. For example, using these [recommended naming conventions](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/naming-and-tagging#example-names), a public IP resource for a production SharePoint workload is named like this: `pip-sharepoint-prod-westus-001`.

> ### Metadata tags

When applying metadata tags to the cloud resources, you can include information about those assets that couldn't be included in the resource name. You can use that information to perform more sophisticated filtering and reporting on resources. This information can be used by IT or business teams to find resources or generate reports about resource usage and billing.

The following list provides the recommended common tags that capture important context and information about resources. Use this list as a starting point to establish your tagging conventions.

Tag Name | Description | Key | Example Value | Required?
-------- | ----------- | --- | ------------- | --------- | 
Created By | Name Person responsible for approving costs related to this resource. | CreatedBy | {email} | Yes
Created On | Date when this application, workload, or service was first deployed. | CreatedOn | {date} | No
Cost Center | Accounting cost center associated with this resource. | CostCenter | {number} | Yes
Environment | Deployment environment of this application, workload, or service. | Environment | Prod, Dev, QA, Stage, Test | Yes
Critical | Indicates if this is a critical resource | Critical | Yes | Yes
Location | Indicates the location of this resource | Location | eastus2 | No
Solution | Indicates the solution related to this resource | Solution | hub | No
Service Class | Service Level Agreement level of this application, workload, or service. | ServiceClass | Dev, Bronze, Silver, Gold | Yes

other tag recommendations could include

Tag Name | Description | Key | Example Value | Required?
-------- | ----------- | --- | ------------- | --------- | 
Project Name | Name of the Project for the infra is created. This is mandatory to create a resource names. | ProjectName | {Project name} | Yes
Application Name | Name of the application, service, or workload the resource is associated with. | ApplicationName | {app name} | Yes
Business Unit | Top-level division of your company that owns the subscription or workload the resource belongs to. In smaller organizations, this may represent a single corporate or shared top-level organizational element. | BusinessUnit | FINANCE, MARKETING,{Product Name},CORP,SHARED | Yes
Disaster Recovery | Business criticality of this application, workload, or service. | DR | Mission Critical, Critical, Essential | Yes
Owner Name | Owner of the application, workload, or service. | Owner | {email} | Yes
Requester Name | User that requested the creation of this application. | Requestor | {email} | Yes
End Date of the Project | Date when this application, workload, or service is planned to be retired. | EndDate | {date} | No

> This module allows you to manage the above metadata tags directly or as a variable using `variables.tf`. All Azure resources which support tagging can be tagged by specifying key-values in argument `tags`. Tag `ResourceName` is added automatically to all resources.

## Authors

Originally created by [Shawn Anderson](mailto:sanderson@eye-catcher.com)

## Other resources

* [Azure Backup](https://azure.microsoft.com/en-us/products/backup/#overview)
* [Terraform AzureRM Provider Documentation](https://www.terraform.io/docs/providers/azurerm/index.html)
