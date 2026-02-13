# WebODoctor

A modern React application built with TypeScript and Vite, featuring automated CI/CD pipeline with comprehensive security testing.

## 🚀 Features

- ⚡ **Vite** - Lightning fast build tool
- ⚛️ **React 19** - Latest React features
- 📘 **TypeScript** - Type-safe development
- 🔄 **CI/CD Pipeline** - Automated testing, security scanning, and deployment
- 🔒 **Security First** - SAST, dependency scanning, and vulnerability checks
- 🌐 **Nginx Deployment** - Production-ready server configuration

## 📋 Prerequisites

- Node.js 20 or higher
- npm or yarn
- Git

## 🛠️ Local Development

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd webodoctor

# Install dependencies
npm install

# Start development server
npm run dev
```

### Available Scripts

```bash
# Development server with HMR
npm run dev

# Build for production
npm run build

# Preview production build
npm run preview

# Run linting
npm run lint

# Type checking
npx tsc --noEmit
```

## 🔄 CI/CD Pipeline

This project includes a complete CI/CD pipeline with automated testing, security scanning, and deployment.

### Pipeline Features

- ✅ **Automated Testing** - ESLint, TypeScript type checking
- 🔒 **Security Scanning** - SAST (Semgrep), npm audit, Snyk, OWASP
- 🔨 **Automated Build** - Vite production build
- 🚀 **Automated Deployment** - SCP to server with smart build management
- 🔄 **Automatic Rollback** - Restores previous build on failure
- 📦 **Build Backup** - Always keeps one previous build

### Quick Setup

1. **Configure GitHub Secrets** (Required for deployment)
   - `SSH_PRIVATE_KEY` - Your SSH private key
   - `SERVER_HOST` - Server IP or domain
   - `SERVER_USER` - SSH username

2. **Push to GitHub**
   ```bash
   git push origin main
   ```

3. **Monitor Deployment**
   - Go to GitHub → Actions tab
   - Watch the pipeline execute

### Documentation

- 📖 **[CI/CD Setup Guide](CICD_SETUP_GUIDE.md)** - Complete setup instructions
- 📋 **[Quick Reference](CICD_QUICK_REFERENCE.md)** - Common commands and troubleshooting
- 📊 **[Visual Flow](CICD_VISUAL_FLOW.md)** - Pipeline diagrams and decision trees
- 📝 **[Implementation Summary](CICD_IMPLEMENTATION_SUMMARY.md)** - What's included
- 🌐 **[Deployment Guide](DEPLOYMENT_GUIDE.md)** - Nginx server setup

### Test Pipeline Locally

Before pushing to GitHub, test the pipeline locally:

```bash
# Windows
powershell -ExecutionPolicy Bypass -File test-pipeline.ps1

# Linux/Mac
chmod +x test-pipeline.sh
./test-pipeline.sh
```

## 🌐 Deployment

### Server Requirements

- Ubuntu/Linux server
- Nginx installed
- SSH access configured
- Deployment path: `/var/www/webodoctor`

### Build Management

The pipeline automatically manages builds:

```
First Deployment:
└── dist/              (Build #1)

Second Deployment:
├── dist/              (Build #2 - current)
└── dist-old/          (Build #1 - backup)

Third Deployment:
├── dist/              (Build #3 - current)
└── dist-old/          (Build #2 - backup)
                       # Build #1 deleted automatically
```

### Manual Deployment

If you need to deploy manually:

1. Build the project:
   ```bash
   npm run build
   ```

2. Upload to server:
   ```bash
   scp -r dist/* user@server:/var/www/webodoctor/dist/
   ```

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for detailed Nginx setup.

## 🔒 Security

The CI/CD pipeline includes multiple security layers:

- **SAST** - Static Application Security Testing with Semgrep
- **Dependency Scanning** - npm audit, Snyk, OWASP
- **Type Safety** - TypeScript strict mode
- **Code Quality** - ESLint with security rules

## 📁 Project Structure

```
webodoctor/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # CI/CD pipeline configuration
├── src/                       # Source code
├── dist/                      # Production build (generated)
├── public/                    # Static assets
├── nginx.conf                 # Nginx configuration
├── test-pipeline.ps1          # Local pipeline test (Windows)
├── test-pipeline.sh           # Local pipeline test (Linux/Mac)
├── CICD_SETUP_GUIDE.md       # CI/CD setup instructions
├── CICD_QUICK_REFERENCE.md   # Quick reference guide
├── CICD_VISUAL_FLOW.md       # Pipeline flow diagrams
├── DEPLOYMENT_GUIDE.md       # Nginx deployment guide
└── README.md                  # This file
```

## 🔧 Configuration

### Vite Configuration

The project uses Vite with React plugin. Configuration can be found in `vite.config.ts`.

### TypeScript Configuration

- `tsconfig.json` - Base TypeScript configuration
- `tsconfig.app.json` - Application-specific config
- `tsconfig.node.json` - Node-specific config

### ESLint Configuration

ESLint is configured in `eslint.config.js` with TypeScript and React rules.

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Run tests locally: `./test-pipeline.ps1` or `./test-pipeline.sh`
4. Push to GitHub
5. Create a Pull Request

The CI/CD pipeline will automatically run tests on your PR.

## 📊 Pipeline Triggers

| Event | Testing | Build | Deploy |
|-------|---------|-------|--------|
| Push to `main` | ✅ | ✅ | ✅ |
| Push to `develop` | ✅ | ✅ | ❌ |
| Pull Request | ✅ | ❌ | ❌ |

## 🐛 Troubleshooting

### Build Fails Locally

```bash
# Clear node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Clear Vite cache
rm -rf node_modules/.vite
```

### Pipeline Fails

Check the [CICD_QUICK_REFERENCE.md](CICD_QUICK_REFERENCE.md) for common issues and solutions.

### Deployment Issues

See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) for Nginx troubleshooting.

## 📚 Additional Resources

- [Vite Documentation](https://vite.dev/)
- [React Documentation](https://react.dev/)
- [TypeScript Documentation](https://www.typescriptlang.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)

## 📄 License

[Your License Here]

## 👥 Authors

[Your Name/Team]

---

**Built with ❤️ using React, TypeScript, and Vite**
