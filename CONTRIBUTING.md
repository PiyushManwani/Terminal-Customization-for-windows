# Contributing Guidelines

Thank you for your interest in contributing!

## How to Contribute

### Adding a New Theme

1. Create the config file in `configs/my-theme.json`
2. Create color scheme in `color-schemes/my-theme.json`
3. Update README.md with preview
4. Submit PR

### Reporting Issues

- **Bug**: Something doesn't work
- **Enhancement**: New feature request
- **Documentation**: Improvements to docs

### Code Style

- Format JSON with proper indentation
- Use 4-space indentation
- Include comments for complex settings
- Validate all JSON at [jsonlint.com](https://jsonlint.com/)

## Testing

Before submitting:
```powershell
.\scripts\validate-json.ps1
