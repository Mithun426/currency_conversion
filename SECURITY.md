# Security Guidelines

## 🔒 Secure Configuration

This app follows security best practices by **never hardcoding sensitive information** in source code.

### ✅ What We Do

- **Environment Variables**: Use `--dart-define` for API keys and URLs
- **Configuration Validation**: Validate all required variables at startup
- **Graceful Degradation**: App handles missing configuration elegantly
- **Gitignore Protection**: All potential secret files are ignored
- **Documentation**: Clear setup instructions for developers

### ❌ What We Don't Do

- **No hardcoded API keys** in source code
- **No credentials in git history**
- **No sensitive data in build artifacts**
- **No secrets in error messages or logs**

## 🛡️ Security Checklist

Before deploying or sharing code:

- [ ] No API keys in source code
- [ ] All environment variables use `--dart-define`
- [ ] `.gitignore` includes environment files
- [ ] Different keys for dev/staging/production
- [ ] API keys are regularly rotated
- [ ] Build scripts use CI/CD secrets
- [ ] Error messages don't expose sensitive data

## 🔧 Configuration Security

### Environment Variables
```dart
// ✅ Good - Using environment variables
static const String accessKey = String.fromEnvironment('ACCESS_KEY');

// ❌ Bad - Hardcoded secrets
static const String accessKey = '270ca084-96a82de7-ae4aff0f-60b941d9';
```

### Validation
```dart
// ✅ Good - Validate configuration
if (!AppConfig.isConfigValid) {
  throw Exception('Missing required configuration');
}

// ❌ Bad - No validation
String url = baseUrl + endpoint; // Could fail silently
```

### Error Handling
```dart
// ✅ Good - Generic error message
throw Exception('API Configuration Error: Missing variables');

// ❌ Bad - Exposing configuration details
throw Exception('API key 270ca084-96a82de7 is invalid');
```

## 🚀 Development Workflow

1. **Get API Credentials**
   ```bash
   # Sign up at https://api.exconvert.com
   # Get your API access key
   ```

2. **Copy Example Script**
   ```bash
   cp scripts/dev.example.sh scripts/dev.sh
   chmod +x scripts/dev.sh
   ```

3. **Update Credentials**
   ```bash
   # Edit scripts/dev.sh
   ACCESS_KEY="your_actual_api_key_here"
   ```

4. **Run Securely**
   ```bash
   ./scripts/dev.sh
   ```

## 🏗️ Production Deployment

### CI/CD Secrets
Store secrets in your CI/CD environment:

- `API_BASE_URL`: https://api.exconvert.com
- `API_ACCESS_KEY`: Your production API key
- `ENVIRONMENT`: production

### Build Commands
```bash
# GitHub Actions
flutter build apk \
  --dart-define=BASE_URL=${{ secrets.API_BASE_URL }} \
  --dart-define=ACCESS_KEY=${{ secrets.API_ACCESS_KEY }} \
  --dart-define=ENVIRONMENT=production

# Manual build
flutter build apk \
  --dart-define=BASE_URL=https://api.exconvert.com \
  --dart-define=ACCESS_KEY=your_prod_key \
  --dart-define=ENVIRONMENT=production
```

## 🔍 Security Monitoring

### What to Monitor
- API key usage and quotas
- Unauthorized access attempts
- Configuration validation errors
- Build failures due to missing secrets

### Logging Security
```dart
// ✅ Good - Safe logging
print('API request failed: Invalid credentials');

// ❌ Bad - Exposing secrets
print('API request failed with key: ${apiKey}');
```

## 🆘 Security Incident Response

If API keys are compromised:

1. **Immediately rotate** affected API keys
2. **Update all environments** with new keys
3. **Review git history** for any exposed secrets
4. **Update team members** with new credentials
5. **Monitor for unauthorized usage**

## 📚 Additional Resources

- [Flutter Security Best Practices](https://flutter.dev/docs/development/data-and-backend/json#security)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security-testing-guide/)
- [API Security Guidelines](https://owasp.org/www-project-api-security/)

## 🤝 Contributing

When contributing to this project:

1. **Never commit secrets** - Use the provided configuration system
2. **Test with your own API keys** - Don't share credentials
3. **Update documentation** if adding new configuration options
4. **Follow security guidelines** outlined in this document

Remember: **Security is everyone's responsibility!** 🔒 