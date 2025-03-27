# Get the command from arguments
$command = $args[0]

if ($command -eq "clean") {
    Write-Host "Cleaning solution..." -ForegroundColor Yellow
    dotnet clean
    Write-Host "Clean completed!" -ForegroundColor Green
}
else {
    # Build the solution
    Write-Host "Building solution..." -ForegroundColor Green
    dotnet build

    # Check if build was successful
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Build successful! Starting projects..." -ForegroundColor Green
        
        # Start both projects with HTTPS
        Start-Process dotnet -ArgumentList "run --project Compendium.Api --launch-profile https"
        Start-Process dotnet -ArgumentList "run --project Compendium.Web --launch-profile https"
        
        # Wait a moment for the projects to start
        Start-Sleep -Seconds 5
        
        # Launch browsers
        Write-Host "Launching browsers..." -ForegroundColor Green
        Start-Process "https://localhost:7008"  # Frontend
        Start-Process "https://localhost:7125/scalar/v1"  # Scalar API docs
        
        Write-Host "Projects launched successfully!" -ForegroundColor Green
    }
    else {
        Write-Host "Build failed! Please check the errors above." -ForegroundColor Red
        exit 1
    }
} 