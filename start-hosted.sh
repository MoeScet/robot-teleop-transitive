#!/bin/bash

echo "╔════════════════════════════════════════════════════════╗"
echo "║     Robot Teleop - Hosted Version                   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check current branch
BRANCH=$(git branch --show-current)
if [ "$BRANCH" != "hosted" ]; then
    echo "WARNING: Not on 'hosted' branch!"
    echo "Current branch: $BRANCH"
    echo ""
    echo "Switch to hosted branch with:"
    echo "  git checkout hosted"
    echo ""
    exit 1
fi

# Check MQTT URL
CURRENT_URL=$(grep "const MQTT_URL = " web/index.html | sed "s/.*'\(.*\)'.*/\1/")

if [[ "$CURRENT_URL" == "wss://YOUR-NGROK-MQTT-URL.ngrok-free.app" ]]; then
    echo "MQTT URL not configured!"
    echo ""
    echo "Setup steps:"
    echo "1. Start ngrok for MQTT:"
    echo "   Windows PowerShell: ngrok http 9002"
    echo ""
    echo "2. Copy the HTTPS URL (e.g., https://abc123.ngrok-free.app)"
    echo ""
    echo "3. Update web/index.html:"
    echo "   const MQTT_URL = 'wss://abc123.ngrok-free.app';"
    echo "   (Replace https:// with wss://)"
    echo ""
    echo "4. Run this script again"
    echo ""
    exit 1
fi

echo "✓ MQTT URL: $CURRENT_URL"
echo ""

# Start web server
echo "Starting web server on port 8000..."
cd web
python3 -m http.server 8000 &
WEB_PID=$!

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║                  READY TO SHARE!                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Next steps:"
echo "1. Run ngrok for web (in Windows PowerShell):"
echo "   ngrok http 8000"
echo ""
echo "2. Share the ngrok HTTPS URL with others!"
echo ""
echo "Press Ctrl+C to stop..."
echo ""

wait $WEB_PID
