$myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal = new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
$adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator
if ($myWindowsPrincipal.IsInRole($adminRole)) {
   
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   
   clear-host
}
else {

   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";

   $newProcess.Arguments = $myInvocation.MyCommand.Definition;

   $newProcess.Verb = "runas";

   [System.Diagnostics.Process]::Start($newProcess);

   exit

}

$AcronisActProtec = @("active_protection_service")

Write-Host "Stopping 'Active Protection Service'"
Write-Host "-----------------------------------------"
Get-Service * | Where-Object { $_.Name -match "active_protection_service" -and $_.Status -eq "Running" } | Stop-Service >$null -Confirm:$false -Force -ErrorAction SilentlyContinue
ForEach ($Proc in $AcronisActProtec) {
   try {
      $p = Get-Process -Name $Proc -ErrorAction SilentlyContinue
      Stop-Process -InputObject $p -Confirm:$false -Force -ErrorAction SilentlyContinue

      Write-Host $Proc "stopped"
      Set-Service -Name AcronisActiveProtectionService -StartupType Manual
      Write-Host $Proc "startup type has been set to manual"
   }
   catch {
      Write-Host $Proc "not running..."
      Set-Service -Name AcronisActiveProtectionService -StartupType Manual
      Write-Host $Proc "startup type has been set to manual"
   }
}
Write-Host "Press any key to continue..."
$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")