#!/bin/bash

echo "╔════════════════════════════════════════════════════════╗"
echo "║          ngrok Hosted Version Setup Helper             ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

echo "Please enter your ngrok MQTT URL"
echo "(From Windows PowerShell: ngrok http 9002)"
echo ""
echo "Example: https://sal-nontarnishable-myriadly.ngrok-free.dev"
echo ""
read -p "ngrok MQTT URL: " MQTT_URL

# Convert https:// to wss://
MQTT_URL_WS=$(echo "$MQTT_URL" | sed 's/https:/wss:/')

echo ""
echo "Converting to WebSocket URL: $MQTT_URL_WS"
echo ""

# Update web/index.html
cd web
sed -i "s|const MQTT_URL = .*|const MQTT_URL = '$MQTT_URL_WS';|" index.html

echo "✓ Updated web/index.html"
echo ""
echo "Next steps:"
echo "1. Start web server: ./start-web.sh"
echo "2. Run ngrok for web: ngrok http 8000"
echo "3. Share the web ngrok URL!"
echo ""
