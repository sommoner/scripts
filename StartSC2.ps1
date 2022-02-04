<###READ ME FIRST####
OPEN NEW POWERSHELL AS ADMINISTRATOR AND RUN THIS COMMAND:

Set-ExecutionPolicy -Scope LocalMachine Bypass

When promted choose 'A' and press Enter
After that you can use this script.
Dont forget to set your Network Adapter Name and Game Path in CONFIG section
#>



#Check If Script started as Administrator
param([switch]$Elevated)
function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
if ((Test-Admin) -eq $false){
    if ($elevated) {
    # tried to elevate, did not work, aborting
    }else{
    Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
Exit
}
'running with full privileges'

# CONFIG CONFIG CONFIG CONFIG CONFIG CONFIG CONFIG CONFIG
$NetAdapter = "Wi-Fi"
$GamePath = "D:\Games\StarCraft II\Support64\SC2Switcher_x64.exe"
# CONFIG CONFIG CONFIG CONFIG CONFIG CONFIG CONFIG CONFIG

# Disable Network Adapter
while((Get-NetAdapter -Name $NetAdapter).Status -ne 'Disabled'){
    Disable-NetAdapter -Name $NetAdapter -Confirm:$false
    Start-Sleep -Seconds 2
}
# Start the game
Start-Process $GamePath

#If Game Started - Enable Network Adapter
while($true){
    if(Get-Process -Name SC2_x64 -ErrorAction SilentlyContinue){
        Start-Sleep -Seconds 2
        Enable-NetAdapter -Name $NetAdapter -Confirm:$false
        break
    }else{
        Write-Host "Waiting for game to start..."
    }
}
