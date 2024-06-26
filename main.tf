terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.109.0"
    }
  }
}

provider "azurerm" {
  features {

  }
}


# retrieving the exisiting resources
data "azurerm_resource_group" "monotoring" {
  name = "monotoring"

}

data "azurerm_virtual_machine" "monovm" {
  name                = "monovm"
  resource_group_name = data.azurerm_resource_group.monotoring.name
}

data "azurerm_log_analytics_workspace" "ResourcesAanalytics" {
  name                = "ResourcesAanalytics"
  resource_group_name = data.azurerm_resource_group.monotoring.name
}

# addig data collection rule
resource "azurerm_monitor_data_collection_rule" "dcr" {
  name                = "dcr_linux"
  resource_group_name = data.azurerm_resource_group.monotoring.name
  location            = "eastus"
  kind                = "Linux"

  destinations {
    log_analytics {
      workspace_resource_id = data.azurerm_log_analytics_workspace.ResourcesAanalytics.id
      name                  = "destination-log"
    }
  }

  data_flow {
    streams      = ["Microsoft-Syslog"]
    destinations = ["destination-log"]
  }

  data_sources {
    syslog {
      facility_names = ["daemon", "syslog"]
      log_levels     = ["Warning", "Error", "Critical", "Alert", "Emergency"]
      name           = "datasource-syslog"
    }
  }
}
#creating AMA extention to VM
resource "azurerm_virtual_machine_extension" "ama_linux" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = data.azurerm_virtual_machine.monovm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}

# association between DCR and VM
resource "azurerm_monitor_data_collection_rule_association" "dcr_association" {
  name                    = "DCR-VM-Association"
  target_resource_id      = data.azurerm_virtual_machine.monovm.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr.id
  description             = "Association between the Data Collection Rule and the Linux VM."
}