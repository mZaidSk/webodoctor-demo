# CI/CD Pipeline Test Script
# This script simulates the CI/CD pipeline locally before pushing to GitHub

Write-Host "🚀 Starting Local CI/CD Pipeline Test..." -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$ErrorActionPreference = "Stop"

# Step 1: Linting
Write-Host ""
Write-Host "📝 Step 1: Running ESLint..." -ForegroundColor Yellow
try {
    npm run lint 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Linting passed" -ForegroundColor Green
    } else {
        throw "Linting failed"
    }
}
catch {
    Write-Host "✗ Linting failed" -ForegroundColor Red
    exit 1
}

# Step 2: TypeScript Type Check
Write-Host ""
Write-Host "🔍 Step 2: Running TypeScript Type Check..." -ForegroundColor Yellow
try {
    npx tsc --noEmit 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Type check passed" -ForegroundColor Green
    } else {
        throw "Type check failed"
    }
}
catch {
    Write-Host "✗ Type check failed" -ForegroundColor Red
    exit 1
}

# Step 3: Dependency Vulnerability Check
Write-Host ""
Write-Host "🔒 Step 3: Checking for vulnerabilities..." -ForegroundColor Yellow
$auditResult = npm audit --audit-level=moderate 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ No critical vulnerabilities found" -ForegroundColor Green
} else {
    Write-Host "⚠ Vulnerabilities detected - review npm audit output" -ForegroundColor Yellow
}

# Step 4: Build
Write-Host ""
Write-Host "🔨 Step 4: Building application..." -ForegroundColor Yellow
try {
    npm run build 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Build successful" -ForegroundColor Green
    } else {
        throw "Build failed"
    }
}
catch {
    Write-Host "✗ Build failed" -ForegroundColor Red
    exit 1
}

# Step 5: Check build output
Write-Host ""
Write-Host "📦 Step 5: Verifying build output..." -ForegroundColor Yellow
if (Test-Path "dist" -PathType Container) {
    $fileCount = (Get-ChildItem -Path "dist" -Recurse -File).Count
    if ($fileCount -gt 0) {
        Write-Host "✓ Build output verified" -ForegroundColor Green
        $size = (Get-ChildItem -Path "dist" -Recurse -File | Measure-Object -Property Length -Sum).Sum / 1MB
        Write-Host "   Build size: $([math]::Round($size, 2)) MB" -ForegroundColor Gray
    } else {
        Write-Host "✗ Build output is empty" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✗ Build output directory missing" -ForegroundColor Red
    exit 1
}

# Step 6: Create archive (simulating deployment package)
Write-Host ""
Write-Host "📦 Step 6: Creating deployment archive..." -ForegroundColor Yellow
try {
    Compress-Archive -Path "dist\*" -DestinationPath "dist-test.zip" -Force
    Write-Host "✓ Archive created: dist-test.zip" -ForegroundColor Green
    $archiveSize = (Get-Item "dist-test.zip").Length / 1MB
    Write-Host "   Archive size: $([math]::Round($archiveSize, 2)) MB" -ForegroundColor Gray
    
    # Cleanup
    Remove-Item "dist-test.zip"
}
catch {
    Write-Host "✗ Failed to create archive" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ All local tests passed!" -ForegroundColor Green
Write-Host "Your code is ready to be pushed to GitHub." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. git add ." -ForegroundColor White
Write-Host "2. git commit -m `"Your commit message`"" -ForegroundColor White
Write-Host "3. git push origin main" -ForegroundColor White
Write-Host ""
