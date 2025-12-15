#!/bin/bash

echo "Starting Web Interface..."
echo ""

PORT=8000

# Check if port is already in use
if lsof -Pi :$PORT -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "Port $PORT is already in use!"
    echo ""
    echo "Kill existing server? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        kill $(lsof -t -i:$PORT) 2>/dev/null
        sleep 1
    else
        exit 1
    fi
fi

echo "Starting web server on port $PORT..."
echo ""
echo "Access at: http://localhost:$PORT"
echo ""
echo "Press Ctrl+C to stop"
echo ""

python3 -m http.server $PORT
