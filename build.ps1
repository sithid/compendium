$config = @{
    ApiUrl       = "https://localhost:7125"
    WebUrl       = "https://localhost:7008"
    ApiDocsPath  = "/scalar/v1"
    StartupDelay = 5
    LogFile      = "build.log"
}

function Write-Log {
    param($Message, $Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $logMessage -ForegroundColor $Color
    Add-Content -Path $config.LogFile -Value $logMessage
}
   
function Handle-Error {
    param($ErrorMessage)
    Write-Log $ErrorMessage -Color Red
    Write-Log "Build failed! Check $($config.LogFile) for details." -Color Red
    exit 1
}

try {
    $command = $args[0]

    if ($command -eq "clean") {
        Write-Log "Cleaning solution..." -Color Yellow
        dotnet clean
        if ($LASTEXITCODE -ne 0) {
            Handle-Error "Clean failed!"
        }
        Write-Log "Clean completed successfully!" -Color Green
    }
    else {
        Write-Log "Building solution..." -Color Green
        dotnet build
        if ($LASTEXITCODE -ne 0) {
            Handle-Error "Build failed!"
        }

        Write-Log "Build successful! Starting projects..." -Color Green
        
        try {
            Start-Process dotnet -ArgumentList "run --project Compendium.Api --launch-profile https"
            Start-Process dotnet -ArgumentList "run --project Compendium.Web --launch-profile https"
        }
        catch {
            Handle-Error "Failed to start projects: $_"
        }
        
        Write-Log "Waiting for projects to start..." -Color Yellow
        Start-Sleep -Seconds $config.StartupDelay
        
        Write-Log "Launching browsers..." -Color Green
        try {
            Start-Process $config.WebUrl
            Start-Process "$($config.ApiUrl)$($config.ApiDocsPath)"
        }
        catch {
            Handle-Error "Failed to launch browsers: $_"
        }
        
        Write-Log "Projects launched successfully!" -Color Green
    }
}
catch {
    Handle-Error "Unexpected error: $_"
}