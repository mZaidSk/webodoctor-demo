#!/bin/bash

# CI/CD Local Test Script
# This script simulates the CI/CD pipeline locally before pushing to GitHub

set -e  # Exit on any error

echo "🚀 Starting Local CI/CD Pipeline Test..."
echo "========================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Step 1: Linting
echo ""
echo "📝 Step 1: Running ESLint..."
if npm run lint; then
    print_status "Linting passed"
else
    print_error "Linting failed"
    exit 1
fi

# Step 2: TypeScript Type Check
echo ""
echo "🔍 Step 2: Running TypeScript Type Check..."
if npx tsc --noEmit; then
    print_status "Type check passed"
else
    print_error "Type check failed"
    exit 1
fi

# Step 3: Dependency Vulnerability Check
echo ""
echo "🔒 Step 3: Checking for vulnerabilities..."
if npm audit --audit-level=moderate; then
    print_status "No critical vulnerabilities found"
else
    print_warning "Vulnerabilities detected - review npm audit output"
fi

# Step 4: Build
echo ""
echo "🔨 Step 4: Building application..."
if npm run build; then
    print_status "Build successful"
else
    print_error "Build failed"
    exit 1
fi

# Step 5: Check build output
echo ""
echo "📦 Step 5: Verifying build output..."
if [ -d "dist" ] && [ "$(ls -A dist)" ]; then
    print_status "Build output verified"
    echo "   Build size: $(du -sh dist | cut -f1)"
else
    print_error "Build output is empty or missing"
    exit 1
fi

# Step 6: Create archive (simulating deployment package)
echo ""
echo "📦 Step 6: Creating deployment archive..."
cd dist
tar -czf ../dist-test.tar.gz .
cd ..
print_status "Archive created: dist-test.tar.gz"
echo "   Archive size: $(du -sh dist-test.tar.gz | cut -f1)"

# Cleanup
rm dist-test.tar.gz

echo ""
echo "========================================"
echo -e "${GREEN}✅ All local tests passed!${NC}"
echo "Your code is ready to be pushed to GitHub."
echo ""
echo "Next steps:"
echo "1. git add ."
echo "2. git commit -m 'Your commit message'"
echo "3. git push origin main"
echo ""
