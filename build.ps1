# Build the solution
Write-Host "Building solution..." -ForegroundColor Green
dotnet build

# Check if build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful! Starting projects..." -ForegroundColor Green
    
    # Start both projects with HTTPS
    Start-Process dotnet -ArgumentList "run --project Compendium.Api --launch-profile https"
    Start-Process dotnet -ArgumentList "run --project Compendium.Web --launch-profile https"
    
    Write-Host "Projects launched successfully!" -ForegroundColor Green
} else {
    Write-Host "Build failed! Please check the errors above." -ForegroundColor Red
    exit 1
} 