$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

$ListOfVMs = "HKFINDEV05-test", "HKFINDEVDB05-test", "HKTS16-test", "sgaz-dev-vm-fin-nav09-06", "sgaz-dev-vm-fin-nav17DB-02"
$RGName = "southeastasia-rg-fin-dev-NAV-01"
ForEach ($VM in $ListOfVMs)
{
    Write-Output "Turnning off VM $VM in Resource Group $RGName"
    #Stop-AzureRmVM -ResourceGroupName $RGName -Name $VM -Force
}