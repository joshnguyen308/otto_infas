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
$ListOfVMs = "Demo1"
$RGName = "HoaiNhanRG"
foreach ($VM in $ListOfVMs)
{
    Write-Output "Turning Off $VM"
    Stop-AzureRmVM -ResourceGroupName $RGName -Name $VM -Force
    # if ($LASTEXITCODE != 0)
    # {
    #     Write-Output "Turn off $VM VM successfully"
    # }
    # else
    # {
    #     Write-Output "Faild to Turn Off $VM VM"
    # }
}

$ListOfVMs = "HKFINDEV05-test", "HKFINDEVDB05-test", "HKTS16-test", "sgaz-dev-vm-fin-nav09-06", "sgaz-dev-vm-fin-nav17DB-02"
$RGName = "HoaiNhanRG", "ResourceGroup02", "ResourcesGroup03"
ForEach ($RG in $RGName)
{
    ForEach ($VM in $ListOfVMs)
    {
        Write-Output "Turnning of VM $VM In Resource Group $RG"
    }
}


