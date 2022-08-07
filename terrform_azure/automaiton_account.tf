
resource "azurerm_resource_group" "AzureAutomationAccount" {
  name     = "southeastasia-rg-fin-AzureAutomationAccount"
  location = "Southeast Asia"
}

resource "azurerm_automation_account" "AutomationTurnOnOffVMs" {
  name                = "AutomationTurnOnOffVMs"
  location            = azurerm_resource_group.AzureAutomationAccount.location
  resource_group_name = azurerm_resource_group.AzureAutomationAccount.name
  sku_name            = "Basic"
  identity {
    type = "SystemAssigned"
  }
  tags = {
    environment = "develop"
    managedBy   = "terraform"
  }
}

resource "azurerm_automation_runbook" "VMsTurnOffScript" {
  name                    = "VMsTurnOffScript"
  location                = azurerm_resource_group.AzureAutomationAccount.location
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  log_verbose             = "false"
  log_progress            = "false"
  runbook_type            = "PowerShell"

  content = file("./runbook_turnoff.ps1")
}

resource "azurerm_automation_runbook" "VMsTurnOnScript" {
  name                    = "VMsTurnOnScript"
  location                = azurerm_resource_group.AzureAutomationAccount.location
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  log_verbose             = "false"
  log_progress            = "false"
  runbook_type            = "PowerShell"

  content = file("./runbook_turnon.ps1")
}


resource "azurerm_automation_schedule" "Group2TurnOnTimeFrame" {
  name                    = "Group2TurnOnTimeFrame"
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Asia/Hong_Kong"
  start_time              = "2022-08-09T08:30:00+08:00"
  description = "Group2TurnOnTimeFrame"
  week_days   = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_job_schedule" "LinkScheduleToRunbook1" {
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  schedule_name           = azurerm_automation_schedule.Group2TurnOnTimeFrame.name
  runbook_name            = azurerm_automation_runbook.VMsTurnOnScript.name
}


resource "azurerm_automation_schedule" "Group2TurnOffTimeFrame" {
  name                    = "Group2TurnOffTimeFrame"
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Asia/Hong_Kong"
  start_time              = "2022-08-09T19:00:00+08:00"
  description = "Group2TurnOffTimeFrame"
  week_days   = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_job_schedule" "LinkScheduleToRunbook2" {
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  schedule_name           = azurerm_automation_schedule.Group2TurnOffTimeFrame.name
  runbook_name            = azurerm_automation_runbook.VMsTurnOffScript.name
}