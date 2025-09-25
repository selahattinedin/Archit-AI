# ArchitAI

AI-powered interior design application.

## Setup

### 1. API Keys Configuration

1. Copy `Config.example.plist` to `Config.plist`
2. Fill in your actual API keys in `Config.plist`:

```xml
<key>STABILITY_AI_API_KEY</key>
<string>YOUR_ACTUAL_STABILITY_AI_API_KEY</string>
<key>REVENUECAT_API_KEY</key>
<string>YOUR_ACTUAL_REVENUECAT_API_KEY</string>
```

### 2. Firebase Configuration

Make sure `GoogleService-Info.plist` is properly configured for your Firebase project.

### 3. Build and Run

Open the project in Xcode and build for your target device or simulator.

## Security Notes

- `Config.plist` contains sensitive API keys and is excluded from version control
- Never commit `Config.plist` to your repository
- Use `Config.example.plist` as a template for other developers
