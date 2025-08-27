# Configuration Guide

## Environment Variables

This app uses `--dart-define` to securely manage API credentials and configuration. **Never hardcode secrets in source code.**

### Required Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `BASE_URL` | API base URL | `https://api.exconvert.com` |
| `ACCESS_KEY` | API access key | `your_api_key_here` |
| `ENVIRONMENT` | App environment | `development` or `production` |

### Development Setup

1. **Get API Credentials**
   - Sign up at [ExConvert API](https://api.exconvert.com)
   - Get your API access key

2. **Run the App**
   ```bash
   flutter run \
     --dart-define=BASE_URL=https://api.exconvert.com \
     --dart-define=ACCESS_KEY=your_actual_api_key \
     --dart-define=ENVIRONMENT=development
   ```

3. **Build for Production**
   ```bash
   flutter build apk \
     --dart-define=BASE_URL=https://api.exconvert.com \
     --dart-define=ACCESS_KEY=your_production_key \
     --dart-define=ENVIRONMENT=production
   ```

### Using Scripts (Recommended)

Create these scripts in your project root for easier development:

**`scripts/dev.sh`** (macOS/Linux):
```bash
#!/bin/bash
flutter run \
  --dart-define=BASE_URL=https://api.exconvert.com \
  --dart-define=ACCESS_KEY=your_dev_key \
  --dart-define=ENVIRONMENT=development
```

**`scripts/dev.bat`** (Windows):
```batch
@echo off
flutter run ^
  --dart-define=BASE_URL=https://api.exconvert.com ^
  --dart-define=ACCESS_KEY=your_dev_key ^
  --dart-define=ENVIRONMENT=development
```

**`scripts/build-prod.sh`**:
```bash
#!/bin/bash
flutter build apk \
  --dart-define=BASE_URL=https://api.exconvert.com \
  --dart-define=ACCESS_KEY=your_prod_key \
  --dart-define=ENVIRONMENT=production
```

### IDE Configuration

#### VS Code (launch.json)
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Currency App (Dev)",
      "request": "launch",
      "type": "dart",
      "toolArgs": [
        "--dart-define=BASE_URL=https://api.exconvert.com",
        "--dart-define=ACCESS_KEY=your_dev_key",
        "--dart-define=ENVIRONMENT=development"
      ]
    },
    {
      "name": "Currency App (Prod)",
      "request": "launch",
      "type": "dart",
      "toolArgs": [
        "--dart-define=BASE_URL=https://api.exconvert.com",
        "--dart-define=ACCESS_KEY=your_prod_key",
        "--dart-define=ENVIRONMENT=production"
      ]
    }
  ]
}
```

#### Android Studio
1. Go to Run > Edit Configurations
2. Add to "Additional run args":
   ```
   --dart-define=BASE_URL=https://api.exconvert.com --dart-define=ACCESS_KEY=your_key --dart-define=ENVIRONMENT=development
   ```

### Security Best Practices

1. **Never commit API keys** to version control
2. **Use different keys** for development and production
3. **Rotate keys regularly**
4. **Use environment-specific URLs** if needed
5. **Validate configuration** at app startup

### Troubleshooting

#### Missing Configuration Error
```
❌ Missing required environment variables: BASE_URL, ACCESS_KEY
Please run with: flutter run --dart-define=BASE_URL=your_url --dart-define=ACCESS_KEY=your_key
```

**Solution**: Make sure all required `--dart-define` parameters are provided.

#### API Configuration Error
```
API Configuration Error: Missing required environment variables
```

**Solution**: Check that your API credentials are correct and the service is accessible.

### Alternative: Flavors (Advanced)

For more complex setups, you can use Flutter flavors:

1. Create flavor-specific configuration files
2. Use build variants for Android
3. Use schemes for iOS
4. Combine with `--dart-define` for secrets

Example flavor setup would involve:
- `lib/config/dev_config.dart`
- `lib/config/prod_config.dart`
- Build scripts for each flavor
- Different app icons/names per environment

### CI/CD Integration

For automated builds, store secrets in your CI/CD environment:

**GitHub Actions**:
```yaml
- name: Build APK
  run: |
    flutter build apk \
      --dart-define=BASE_URL=${{ secrets.API_BASE_URL }} \
      --dart-define=ACCESS_KEY=${{ secrets.API_ACCESS_KEY }} \
      --dart-define=ENVIRONMENT=production
```

**GitLab CI**:
```yaml
build:
  script:
    - flutter build apk
      --dart-define=BASE_URL=${API_BASE_URL}
      --dart-define=ACCESS_KEY=${API_ACCESS_KEY}
      --dart-define=ENVIRONMENT=production
```

This ensures secrets are never exposed in your source code while maintaining security best practices. 