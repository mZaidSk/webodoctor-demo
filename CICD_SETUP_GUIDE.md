# CI/CD Pipeline Setup Guide

This guide will help you set up the complete CI/CD pipeline for WebODoctor with automated testing, security scanning, building, and deployment.

## 🎯 Pipeline Overview

The pipeline consists of 4 main jobs:

1. **Test & Security Checks**
   - ESLint (Linting)
   - TypeScript Type Checking
   - npm audit (Dependency vulnerabilities)
   - Semgrep (SAST - Static Application Security Testing)
   - Snyk (Vulnerability scanning)
   - OWASP Dependency Check

2. **Build**
   - Builds the Vite application
   - Creates a compressed archive
   - Uploads as artifact

3. **Deploy**
   - Manages old builds (old → delete, current → old)
   - Deploys new build via SCP
   - Automatic rollback on failure

4. **Notify**
   - Reports deployment status

## 📋 Prerequisites

### 1. GitHub Repository
Ensure your code is in a GitHub repository.

### 2. Server Requirements
- Ubuntu server with SSH access
- Nginx installed and configured
- Deployment directory: `/var/www/webodoctor`

### 3. SSH Key Setup

On your local machine or server, generate an SSH key pair:

```bash
# Generate SSH key (if you don't have one)
ssh-keygen -t rsa -b 4096 -C "github-actions@webodoctor"

# This creates:
# - Private key: ~/.ssh/id_rsa
# - Public key: ~/.ssh/id_rsa.pub
```

Copy the public key to your server:

```bash
ssh-copy-id ubuntu@your-server-ip
```

Or manually add it:

```bash
# On your server
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys
# Paste the public key content, save and exit

# Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```

## 🔐 GitHub Secrets Configuration

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add the following secrets:

### Required Secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `SSH_PRIVATE_KEY` | Private SSH key for server access | Content of `~/.ssh/id_rsa` |
| `SERVER_HOST` | Server IP address or domain | `123.45.67.89` or `server.example.com` |
| `SERVER_USER` | SSH username | `ubuntu` |

### Optional Secrets (for enhanced security scanning):

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `SNYK_TOKEN` | Snyk API token | Sign up at [snyk.io](https://snyk.io) → Account Settings → API Token |

### How to Add Secrets:

1. **SSH_PRIVATE_KEY**:
   ```bash
   # Display your private key
   cat ~/.ssh/id_rsa
   
   # Copy the ENTIRE output including:
   # -----BEGIN OPENSSH PRIVATE KEY-----
   # ... key content ...
   # -----END OPENSSH PRIVATE KEY-----
   ```
   Paste this into GitHub Secrets.

2. **SERVER_HOST**:
   ```
   your-server-ip-or-domain
   ```

3. **SERVER_USER**:
   ```
   ubuntu
   ```

4. **SNYK_TOKEN** (Optional but recommended):
   - Sign up at https://snyk.io
   - Go to Account Settings → API Token
   - Copy and paste the token

## 🚀 Pipeline Workflow

### Build Management Logic:

```
Initial State:
└── /var/www/webodoctor/
    └── (empty or has dist/)

After 1st Deployment:
└── /var/www/webodoctor/
    └── dist/              (Build #1)

After 2nd Deployment:
└── /var/www/webodoctor/
    ├── dist/              (Build #2 - current)
    └── dist-old/          (Build #1 - backup)

After 3rd Deployment:
└── /var/www/webodoctor/
    ├── dist/              (Build #3 - current)
    └── dist-old/          (Build #2 - backup)
    # Build #1 is deleted
```

### Deployment Process:

1. **Check for `dist-old`** → If exists, delete it
2. **Check for `dist`** → If exists, rename to `dist-old`
3. **Create new `dist`** directory
4. **Copy and extract** new build
5. **Set permissions** and finalize

### Rollback on Failure:

If deployment fails, the pipeline automatically restores `dist-old` → `dist`

## 🔧 Customization

### Change Deployment Path

Edit `.github/workflows/ci-cd.yml`:

```yaml
env:
  DEPLOY_PATH: '/your/custom/path'  # Change this
```

### Deploy on Different Branches

Current setup deploys only on `main` branch. To deploy on `develop`:

```yaml
deploy:
  if: github.event_name == 'push' && (github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop')
```

### Adjust Security Scan Severity

For Snyk:
```yaml
args: --severity-threshold=high  # Options: low, medium, high, critical
```

For npm audit:
```yaml
npm audit --audit-level=moderate  # Options: low, moderate, high, critical
```

## 🧪 Testing the Pipeline

### 1. Test Locally First

```bash
# Run linting
npm run lint

# Run type check
npx tsc --noEmit

# Run build
npm run build

# Check for vulnerabilities
npm audit
```

### 2. Push to GitHub

```bash
git add .
git commit -m "Add CI/CD pipeline"
git push origin main
```

### 3. Monitor Pipeline

- Go to your GitHub repository
- Click on **Actions** tab
- Watch the pipeline execution

## 📊 Pipeline Triggers

The pipeline runs on:

- **Push** to `main` or `develop` branches
- **Pull Request** to `main` or `develop` branches

### What Runs When:

| Event | Testing | Build | Deploy |
|-------|---------|-------|--------|
| PR to main/develop | ✅ | ❌ | ❌ |
| Push to develop | ✅ | ✅ | ❌ |
| Push to main | ✅ | ✅ | ✅ |

## 🛠️ Troubleshooting

### SSH Connection Issues

```bash
# Test SSH connection manually
ssh -i ~/.ssh/id_rsa ubuntu@your-server-ip

# Check SSH key format
cat ~/.ssh/id_rsa | head -1
# Should show: -----BEGIN OPENSSH PRIVATE KEY-----
# or: -----BEGIN RSA PRIVATE KEY-----
```

### Permission Denied

Ensure the GitHub Actions runner can access your server:

```bash
# On your server, check authorized_keys
cat ~/.ssh/authorized_keys

# Check permissions
ls -la ~/.ssh/
# Should show:
# drwx------ (700) for .ssh directory
# -rw------- (600) for authorized_keys file
```

### Build Fails

Check the Actions tab for detailed error logs. Common issues:

- **Linting errors**: Fix ESLint issues in your code
- **Type errors**: Fix TypeScript errors
- **Dependency vulnerabilities**: Update vulnerable packages

```bash
# Fix vulnerabilities
npm audit fix

# Or force fix (may introduce breaking changes)
npm audit fix --force
```

### Deployment Fails

Check if:
1. Server is accessible via SSH
2. Deployment path exists: `/var/www/webodoctor`
3. User has write permissions

```bash
# On server, check permissions
ls -la /var/www/
sudo chown -R ubuntu:ubuntu /var/www/webodoctor
```

## 🔒 Security Best Practices

1. **Never commit secrets** to your repository
2. **Use GitHub Secrets** for all sensitive data
3. **Rotate SSH keys** periodically
4. **Review security scan reports** regularly
5. **Keep dependencies updated**

## 📈 Monitoring & Logs

### View Pipeline Logs

GitHub → Repository → Actions → Select workflow run

### View Deployment Logs

```bash
# SSH into your server
ssh ubuntu@your-server-ip

# Check deployment directory
cd /var/www/webodoctor
ls -la

# Check Nginx logs
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

## 🎯 Next Steps

1. ✅ Set up GitHub Secrets
2. ✅ Configure SSH access
3. ✅ Push code to trigger pipeline
4. ✅ Monitor first deployment
5. ✅ Set up Snyk for enhanced security (optional)
6. ✅ Configure notifications (Slack, Email, etc.)

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Semgrep Rules](https://semgrep.dev/explore)
- [Snyk Documentation](https://docs.snyk.io/)
- [OWASP Dependency Check](https://owasp.org/www-project-dependency-check/)

---

**Your CI/CD pipeline is now ready!** 🚀

Every push to `main` will automatically:
1. Run security checks
2. Build your application
3. Deploy to your server
4. Keep a backup of the previous build
