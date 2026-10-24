# List of target Appx package DisplayNames
$appsToRemove = @(
    "Microsoft.GamingApp",
    "Microsoft.Xbox.TCUI",
    "MicrosoftWindows.Client.WebExperience",
    "MicrosoftWindows.CrossDevice",
    "Microsoft.Edge.GameAssist",
    "Microsoft.StartExperiencesApp"
)

foreach ($app in $appsToRemove) {
    Write-Host "Attempting to remove $app ..." -ForegroundColor Cyan

    # Remove for current user(s)
    Get-AppxPackage -Name $app -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue

    # Remove provisioned package so it won't install for new users
    Get-AppxProvisionedPackage -Online |
        Where-Object { $_.DisplayName -eq $app } |
        ForEach-Object {
            Write-Host "Removing provisioned package: $($_.DisplayName)" -ForegroundColor Yellow
            Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName -ErrorAction SilentlyContinue
        }
}

Write-Host "Deprovisioning complete." -ForegroundColor Green

# Block GIFs
New-NetFirewallRule -DisplayName "[Disable GIPHY] TextInputHost.exe" -Direction Outbound -Program "C:\Windows\SystemApps\MicrosoftWindows.Client.CBS_cw5n1h2txyewy\TextInputHost.exe" -Action Block -Profile Any
