$PC = "PC name"

Invoke-Command -ComputerName $PC -ScriptBlock {

    Write-Host "Stopping Teams..."

    Get-Process -Name "ms-teams","msteams","teams" -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2

    # Classic Teams reset
    $classicPath = "$env:AppData\Microsoft\Teams"
    if (Test-Path $classicPath) {
        Remove-Item $classicPath -Recurse -Force -ErrorAction SilentlyContinue
    }

    # New Teams repair/reset
    $teamsPackage = Get-AppxPackage -Name "*MSTeams*" -AllUsers
    if ($teamsPackage) {
        Reset-AppxPackage -Package $teamsPackage.PackageFullName
        Add-AppxPackage -Register "$($teamsPackage.InstallLocation)\AppxManifest.xml" -DisableDevelopmentMode -ForceApplicationShutdown
    }

    Write-Host "Teams reset completed on $env:COMPUTERNAME"

}
