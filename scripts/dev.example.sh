#!/bin/bash

# Currency Conversion App - Development Script
# Copy this file to dev.sh and update with your actual API credentials
# Make it executable: chmod +x scripts/dev.sh

echo "🚀 Starting Currency Conversion App in Development Mode..."

# Replace these with your actual API credentials
BASE_URL="https://api.exconvert.com"
ACCESS_KEY="your_api_key_here"  # Get from https://api.exconvert.com
ENVIRONMENT="development"

# Check if API key is set
if [ "$ACCESS_KEY" = "your_api_key_here" ]; then
    echo "❌ Please update ACCESS_KEY in scripts/dev.sh with your actual API key"
    echo "📝 Get your API key from: https://api.exconvert.com"
    exit 1
fi

# Run the app
flutter run \
  --dart-define=BASE_URL="$BASE_URL" \
  --dart-define=ACCESS_KEY="$ACCESS_KEY" \
  --dart-define=ENVIRONMENT="$ENVIRONMENT" \
  "$@"  # Pass any additional arguments 