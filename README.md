# iac-terraform-project
### Store remote state - HCP - Terraform cloud
--# main.ts
```
--# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }
  cloud {
    
    organization = "prashant-ubale-terraform-org"

    workspaces {
      name = "iac-terraform-azure"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "iac-terraform-rg" {
  name     = var.resource_group_name
  location = "westus2"
  tags = {
    environment = "dev - iac-terraform with azure"
    team        = "devops"
  }
}

--# Create a virtual network
resource "azurerm_virtual_network" "iac-terraform-vnet" {
  name                = "${local.prefix}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "westus2"
  resource_group_name = azurerm_resource_group.iac-terraform-rg.name
}
```
--# locals.ts
```
locals {
  prefix = "iac-terraform"
}
```

--# output.tf
```
output "resource_group_id" {
  value = azurerm_resource_group.iac-terraform-rg.id
}
output "virtual_network_id" {
  value = azurerm_virtual_network.iac-terraform-vnet.id
}
```
--# variables.tf
```
variable "resource_group_name" {
  default = "iac-terraform-rg"
}
```
### Set up HCP Terraform
If you have a HashiCorp Cloud Platform or HCP Terraform account, log in using your existing credentials. For more detailed instructions on how to sign up for a new account and create an organization, review the Sign up for HCP Terraform.
### Authenticate with HCP Terraform
Authenticate with HCP Terraform in order to proceed with initialization. In order to authenticate with HCP Terraform, run the terraform login subcommand, and follow the prompts to log in.
```
terraform login
```
Terraform will request an API token for app.terraform.io using your browser.

If login is successful, Terraform will store the token in plain text in
the following file for use by subsequent commands:
    /Users/username/.terraform.d/credentials.tfrc.json

Do you want to proceed? (y/n)
Enter a value: yes

### terraform init
Initializing provider plugins found in the configuration...
- Reusing previous version of hashicorp/azurerm from the dependency lock file
- Using previously-installed hashicorp/azurerm v3.0.2

Initializing HCP Terraform...

HCP Terraform has been successfully initialized!

You may now begin working with HCP Terraform. Try running "terraform plan" to
see any changes that are required for your infrastructure.

If you ever set or change modules or Terraform Settings, run "terraform init"
again to reinitialize your working directory.

Terraform has migrated the state file to HCP Terraform, delete the local state file.
```
rm terraform.tfstate
```
### Configure a Service Principal
If you are not already logged in to Azure, use the Azure CLI to log in to your account.
```
az login
```
Select your subscription and copy its id field value
```
az account set --subscription="SUBSCRIPTION_ID"
```
### Create the Service Principal with the Subscription ID.
```
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/SUBSCRIPTION_ID"
```
After service principal is created copy the output and paste in a notepad.
### Update the HCP Terraform environment variables
 
ARM_SUBSCRIPTION_ID	  

ARM_CLIENT_ID	  

ARM_CLIENT_SECRET	  (Sensitive)

ARM_TENANT_ID	 
<img width="1404" height="529" alt="Screenshot 2026-07-08 at 8 05 04 PM" src="https://github.com/user-attachments/assets/52072789-d878-4459-872d-ad572fd3b4b4" />

### terraform plan    
Running plan in HCP Terraform. Output will stream here. Pressing Ctrl-C
will stop streaming the logs, but will not stop the plan running remotely.

Preparing the remote plan...

To view this run in a browser, visit:
https://app.terraform.io/app/prashant-ubale-terraform-org/iac-terraform-azure/runs/run-******

Waiting for the plan to start...

Terraform v1.15.7
on linux_amd64
Initializing plugins and modules...

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.iac-terraform-rg will be created
  + resource "azurerm_resource_group" "iac-terraform-rg" {
      + id       = (known after apply)
      + location = "westus2"
      + name     = "iac-terraform-rg"
      + tags     = {
          + "environment" = "dev - iac-terraform with azure"
          + "team"        = "devops"
        }
    }

  # azurerm_virtual_network.iac-terraform-vnet will be created
  + resource "azurerm_virtual_network" "iac-terraform-vnet" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "westus2"
      + name                = "iac-terraform-vnet"
      + resource_group_name = "iac-terraform-rg"
      + subnet              = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.
Changes to Outputs:
  + resource_group_id  = (known after apply)
  + virtual_network_id = (known after apply)

### terraform apply --auto-approve
Running apply in HCP Terraform. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://app.terraform.io/app/prashant-ubale-terraform-org/iac-terraform-azure/runs/run-*****

Waiting for the plan to start...

Terraform v1.15.7
on linux_amd64
Initializing plugins and modules...

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # azurerm_resource_group.iac-terraform-rg will be created
  + resource "azurerm_resource_group" "iac-terraform-rg" {
      + id       = (known after apply)
      + location = "westus2"
      + name     = "iac-terraform-rg"
      + tags     = {
          + "environment" = "dev - iac-terraform with azure"
          + "team"        = "devops"
        }
    }

  # azurerm_virtual_network.iac-terraform-vnet will be created
  + resource "azurerm_virtual_network" "iac-terraform-vnet" {
      + address_space       = [
          + "10.0.0.0/16",
        ]
      + dns_servers         = (known after apply)
      + guid                = (known after apply)
      + id                  = (known after apply)
      + location            = "westus2"
      + name                = "iac-terraform-vnet"
      + resource_group_name = "iac-terraform-rg"
      + subnet              = (known after apply)
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + resource_group_id  = (known after apply)
  + virtual_network_id = (known after apply)

azurerm_resource_group.iac-terraform-rg: Creating...
azurerm_resource_group.iac-terraform-rg: Creation complete after 3s [id=/subscriptions//*******//resourceGroups/iac-terraform-rg]
azurerm_virtual_network.iac-terraform-vnet: Creating...
azurerm_virtual_network.iac-terraform-vnet: Creation complete after 6s [id=/subscriptions//*******//resourceGroups/iac-terraform-rg/providers/Microsoft.Network/virtualNetworks/iac-terraform-vnet]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.

Outputs:
resource_group_id = "/subscriptions/*******/resourceGroups/iac-terraform-rg"
virtual_network_id = "/subscriptions//*******//resourceGroups/iac-terraform-rg/providers/Microsoft.Network/virtualNetworks/iac-terraform-vnet"
### Verfify resourced on Azure cloud

### terraform destroy --auto-approve
Running apply in HCP Terraform. Output will stream here. Pressing Ctrl-C
will cancel the remote apply if it's still pending. If the apply started it
will stop streaming the logs, but will not stop the apply running remotely.

Preparing the remote apply...

To view this run in a browser, visit:
https://app.terraform.io/app/prashant-ubale-terraform-org/iac-terraform-azure/runs/run-GVVrnnXSknnAtBY1

Waiting for the plan to start...

Terraform v1.15.7
on linux_amd64
Initializing plugins and modules...
azurerm_resource_group.iac-terraform-rg: Refreshing state... [id=/subscriptions/*****/resourceGroups/iac-terraform-rg]
azurerm_virtual_network.iac-terraform-vnet: Refreshing state... [id=/subscriptions/*****/resourceGroups/iac-terraform-rg/providers/Microsoft.Network/virtualNetworks/iac-terraform-vnet]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # azurerm_resource_group.iac-terraform-rg will be destroyed
  - resource "azurerm_resource_group" "iac-terraform-rg" {
      - id       = "/subscriptions/*******/resourceGroups/iac-terraform-rg" -> null
      - location = "westus2" -> null
      - name     = "iac-terraform-rg" -> null
      - tags     = {
          - "environment" = "dev - iac-terraform with azure"
          - "team"        = "devops"
        } -> null
    }

  # azurerm_virtual_network.iac-terraform-vnet will be destroyed
  - resource "azurerm_virtual_network" "iac-terraform-vnet" {
      - address_space           = [
          - "10.0.0.0/16",
        ] -> null
      - dns_servers             = [] -> null
      - flow_timeout_in_minutes = 0 -> null
      - guid                    = "977bf3dc-4571-4112-9939-7419fa59b99b" -> null
      - id                      = "/subscriptions/1*****/resourceGroups/iac-terraform-rg/providers/Microsoft.Network/virtualNetworks/iac-terraform-vnet" -> null
      - location                = "westus2" -> null
      - name                    = "iac-terraform-vnet" -> null
      - resource_group_name     = "iac-terraform-rg" -> null
      - subnet                  = [] -> null
      - tags                    = {} -> null
        # (2 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 2 to destroy.

Changes to Outputs:
  - resource_group_id  = "/subscriptions/****/resourceGroups/iac-terraform-rg" -> null
  - virtual_network_id = "/subscriptions/****/resourceGroups/iac-terraform-rg/providers/Microsoft.Network/virtualNetworks/iac-terraform-vnet" -> null

azurerm_virtual_network.iac-terraform-vnet: Destroying... [id=/subscriptions/*****/resourceGroups/iac-terraform-rg/providers/Microsoft.Network/virtualNetworks/iac-terraform-vnet]
azurerm_virtual_network.iac-terraform-vnet: Still destroying... [10s elapsed]
azurerm_virtual_network.iac-terraform-vnet: Destruction complete after 11s
azurerm_resource_group.iac-terraform-rg: Destroying... [id=/subscriptions/*****/resourceGroups/iac-terraform-rg]
azurerm_resource_group.iac-terraform-rg: Still destroying... [10s elapsed]
azurerm_resource_group.iac-terraform-rg: Destruction complete after 18s

Apply complete! Resources: 0 added, 0 changed, 2 destroyed.

## Terraform Cloud output
### State files
<img width="723" height="412" alt="Screenshot 2026-07-08 at 8 04 40 PM" src="https://github.com/user-attachments/assets/2fd98d9c-7731-462b-9877-9696bdda3211" />

 ### Runs
 
<img width="773" height="448" alt="Screenshot 2026-07-08 at 8 04 23 PM" src="https://github.com/user-attachments/assets/408cc887-c8bc-4df7-aea5-48fc4a9a99f5" />

<img width="1427" height="681" alt="Screenshot 2026-07-08 at 8 03 52 PM" src="https://github.com/user-attachments/assets/0ee74a50-59b0-4d1d-bdae-7e5b65dce733" />

