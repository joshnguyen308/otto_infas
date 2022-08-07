
resource "azurerm_resource_group" "AzureAutomationAccount" {
  name     = "AzureAutomationAccount"
  location = "Japan East"
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


resource "azurerm_automation_runbook" "VMsTurnOnOffScript" {
  name                    = "VMsTurnOnOffScript"
  location                = azurerm_resource_group.AzureAutomationAccount.location
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  log_verbose             = "false"
  log_progress            = "false"
  runbook_type            = "PowerShell"

  content = file("./SRunbook.ps1")
}

resource "azurerm_automation_schedule" "Group1TurnOnTimeFrame" {
  name                    = "Group1TurnOnTimeFrame"
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  frequency               = "Week"
  interval                = 1
  timezone                = "Asia/Hong_Kong"
  start_time              = "2022-08-07T07:30:00+08:00"
  description = "This is an example schedule"
  week_days   = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
}

resource "azurerm_automation_job_schedule" "LinkScheduleToRunbook" {
  resource_group_name     = azurerm_resource_group.AzureAutomationAccount.name
  automation_account_name = azurerm_automation_account.AutomationTurnOnOffVMs.name
  schedule_name           = azurerm_automation_schedule.Group1TurnOnTimeFrame.name
  runbook_name            = azurerm_automation_runbook.VMsTurnOnOffScript.name
}