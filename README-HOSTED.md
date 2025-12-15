# Robot Teleop - Hosted Version Setup

This branch is configured for public hosting via ngrok.

## Prerequisites

1. Robot simulator running
2. ngrok installed on Windows
3. Port forwarding configured (if using WSL)

## Quick Start

### Step 1: Start Robot Simulator

**WSL Terminal 1:**
```bash
cd robot
docker run -it --rm --name robot-simulator --network cloud_default \
  -v $(pwd):/app -w /app node:18-alpine sh
npm install
node index.js
```

### Step 2: Start ngrok for MQTT

**Windows PowerShell 1:**
```powershell
ngrok http 9002
```

**Output:**
```
Forwarding  https://abc123xyz.ngrok-free.app -> http://localhost:9002
```

**Copy the HTTPS URL!**

### Step 3: Update MQTT URL in Web Interface

**WSL Terminal 2:**
```bash
cd web
nano index.html

# Find and update:
const MQTT_URL = 'wss://abc123xyz.ngrok-free.app';
# Note: Use wss:// (not https://)

# Save: Ctrl+O, Enter, Ctrl+X
```

### Step 4: Start Web Server

**WSL Terminal 2 (continued):**
```bash
cd ..
./start-hosted.sh
```

### Step 5: Start ngrok for Web Interface

**Windows PowerShell 2:**
```powershell
ngrok http 8000
```

**Output:**
```
Forwarding  https://xyz789abc.ngrok-free.app -> http://localhost:8000
```

### Step 6: Share the Web URL!

Send **https://xyz789abc.ngrok-free.app** to anyone!

They can now control your robot from anywhere!

## Troubleshooting

### MQTT Connection Failed

1. Check ngrok is running for port 9002
2. Verify MQTT URL in web/index.html uses `wss://` (not `ws://` or `https://`)
3. Check robot simulator is running
4. Verify test-mosquitto is running: `docker ps | grep test-mosquitto`

### Web Page Won't Load

1. Check ngrok is running for port 8000
2. Verify web server is running: `ps aux | grep python.*8000`
3. Check port forwarding (if using WSL)

### Robot Not Moving

1. Check browser console for errors (F12)
2. Verify "Connected" status (green) in web interface
3. Test with localhost first to isolate ngrok issues

## URLs Explained

- **MQTT ngrok (9002):** For robot communication (WebSocket)
  - Goes in web/index.html as `const MQTT_URL`
  - Use `wss://` prefix
  
- **Web ngrok (8000):** What you share with users
  - The public website URL
  - Share this URL

## Switching Between Versions

**To localhost version:**
```bash
git checkout main
cd web
python3 -m http.server 8000
# Access: http://localhost:8000
```

**To hosted version:**
```bash
git checkout hosted
# Update MQTT URL, then:
./start-hosted.sh
# Access via ngrok URL
```

## Notes

- ngrok free tier: URLs change on restart
- Remember to update MQTT URL after ngrok restart
- Both versions use same robot simulator
