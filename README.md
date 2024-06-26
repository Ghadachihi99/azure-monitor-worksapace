# Azure Monitoring Setup with Terraform

This Terraform project sets up monitoring for Azure resources including Virtual Machines (VMs) and Log Analytics Workspaces. It retrieves existing resources, adds a data collection rule for a Linux VM, and associates this rule with the VM to facilitate detailed logging and monitoring.

## Prerequisites

Before running this Terraform configuration, ensure you have the following:

- An Azure subscription.
- Terraform installed on your machine. [Download Terraform](https://www.terraform.io/downloads.html)
- Azure CLI installed and configured with your Azure account credentials. [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- An SSH key configured in your Azure portal if accessing VMs directly.

## Configuration Details

- **Resource Group**: Monitors existing resources under the resource group named `monotoring`.
- **Virtual Machine**: Retrieves details of an existing virtual machine named `monovm` to monitor.
- **Log Analytics Workspace**: Utilizes an existing Log Analytics Workspace named `ResourcesAanalytics` for logging.
- **Data Collection Rule (DCR)**: A rule named `dcr_linux` set up to collect specific logs (Syslog) from the Linux VM.
- **VM Extension for Monitoring**: An extension named `AzureMonitorLinuxAgent` to enable Azure Monitor on the Linux VM.
- **Data Collection Rule Association**: Associates the DCR with the VM for seamless log collection.

## How to Run

1. **Initialize Terraform**:
   Navigate to your project directory in the terminal and run:
   ```bash
   terraform init
