# Robot Teleoperation with Transitive Framework

A simple robot teleoperation system built with the Transitive framework, featuring real-time control via web interface.

## Features

- Real-time 2D robot physics simulation (50Hz physics, 10Hz state publishing)
- Intuitive arrow key control
- Live position (X, Y, θ) and velocity display
- Web-based interface (no installation needed for users)
- MQTT communication via public broker
- Easy public hosting with Cloudflare Tunnel
- Automated deployment scripts

## Architecture
```
┌─────────────────────────┐
│  User's Browser         │  ← Control from anywhere
│  (Arrow Keys)           │
└────────┬────────────────┘
         │ HTTPS (Cloudflare Tunnel)
         ▼
┌─────────────────────────┐
│  Web Server (WSL)       │  ← Serves HTML/JS
│  Python HTTP Server     │
└────────┬────────────────┘
         │
         │ WebSocket (Public MQTT)
         ▼
┌─────────────────────────┐
│  test.mosquitto.org     │  ← Free public MQTT broker
│  (WebSocket: 8081)      │
└────────┬────────────────┘
         │ MQTT
         ▼
┌─────────────────────────┐
│  Robot Simulator (WSL)  │  ← 2D physics engine
│  Node.js                │
└─────────────────────────┘
```

## Project Structure
```
.
├── robot/                      # Robot simulator component
│   ├── index.js               # Physics engine & MQTT client
│   ├── package.json           # Dependencies
│   ├── run-robot.sh           # One-command automated startup
│   └── start-robot.sh         # Interactive startup (with shell)
│
├── web/                       # Web interface component
│   ├── index.html             # Control UI (React-like interface)
│   └── start-web.sh           # Web server startup script
│
├── cloud/                     # Cloud component (optional, not used)
│
├── setup-cloudflare.sh        # Helper to configure Cloudflare tunnel URL
├── sync-branches.sh           # Sync main branch to hosted branch
├── stop-all.sh                # Stop all services
├── HOSTING.md                 # Detailed hosting guide
├── QUICK-START.txt            # One-page reference
└── README.md                  # This file
```

## Quick Start

### Prerequisites

- **Windows with WSL2** (Ubuntu recommended)
- **Node.js 18+** (for robot simulator)
- **Python 3** (for web server)
- **Cloudflare Tunnel** (for public hosting)

### Installation
```bash
# Install Cloudflare Tunnel (Windows PowerShell - Admin)
winget install Cloudflare.cloudflared

# Verify installation
cloudflared --version
```

---

## Localhost Version (Development & Testing)

Perfect for local testing before going public.

### Start Robot Simulator

**WSL Terminal 1:**
```bash
cd robot
node index.js
```

**Expected output:**
```
[Robot] Connecting to: mqtt://test.mosquitto.org:1883
[Robot] ✓ Connected!
[Robot] ✓ Ready!
[Robot] x:0.00 y:0.00 θ:0.0° v:0.00 ω:0.00
```

### Start Web Interface

**WSL Terminal 2:**
```bash
cd web
./start-web.sh
```

Or manually:
```bash
python3 -m http.server 8000
```

### Test Locally

**Open in browser:** http://localhost:8000

**Test controls:**
- Press `↑` - Robot moves forward
- Press `←` - Robot turns left
- Press `SPACE` - Emergency stop

**If this works, you're ready to host publicly!**

---

## 🌐 Public Hosting (Cloudflare Tunnel)

Make your robot accessible from anywhere in the world!

### Complete Setup Process

#### **Step 1: Start Robot Simulator**

**WSL Terminal 1:**
```bash
cd ~/transitive-dev/simple-teleop/robot
node index.js
```

**Keep this terminal running!**

---

#### **Step 2: Start Cloudflare Tunnel for MQTT (OPTIONAL - Skip This)**

**Note:** Since we're using public MQTT broker (test.mosquitto.org), you don't need to tunnel MQTT.

**Skip to Step 3!**

---

#### **Step 3: Start Web Server**

**WSL Terminal 2:**
```bash
cd ~/transitive-dev/simple-teleop/web
./start-web.sh
```

**Expected output:**
```
Starting Web Interface...
Starting web server on port 8000...
Serving HTTP on 0.0.0.0 port 8000...
```

**Keep this terminal running!**

---

#### **Step 4: Start Cloudflare Tunnel for Web**

**Windows PowerShell (Regular user, NOT Admin):**
```powershell
cloudflared tunnel --url http://localhost:8000
```

**Expected output:**
```
Your quick Tunnel has been created!
https://random-words-1234.trycloudflare.com
```

**Copy this URL!** This is what you share with others.

** Keep this PowerShell running!**

---

#### **Step 5: Share the URL!**

Send the Cloudflare URL to anyone:
```
https://random-words-1234.trycloudflare.com
```

**They can:**
- Open the URL in any browser
- Control your robot in real-time
- See live position updates

**🎉 Success!**

---

### Quick Reference - Complete Checklist

| # | Terminal | Command | Status |
|---|----------|---------|--------|
| 1 | WSL Terminal 1 | `cd robot && node index.js` | ✅ Robot connected to MQTT |
| 2 | WSL Terminal 2 | `cd web && ./start-web.sh` | ✅ Web server running on port 8000 |
| 3 | Windows PowerShell | `cloudflared tunnel --url http://localhost:8000` | ✅ Tunnel active |

**Share:** The Cloudflare URL from step 3

---

## Controls

| Key | Action |
|-----|--------|
| `↑` | Move forward (0.5 m/s) |
| `↓` | Move backward (-0.5 m/s) |
| `←` | Turn left (1.0 rad/s) |
| `→` | Turn right (-1.0 rad/s) |
| `SPACE` | Emergency stop (all velocities to 0) |
| **Speed Slider** | Adjust velocity multiplier (0.1x - 2.0x) |

**Pro Tips:**
- Hold multiple keys for diagonal movement (e.g., `↑` + `←` for forward-left arc)
- Adjust speed slider before pressing keys for slower/faster movement
- Emergency stop works even during movement

---

## Display Information

The web interface shows real-time data:

- **Position**: 
  - X coordinate (meters) - horizontal position
  - Y coordinate (meters) - vertical position
  - θ (theta) - orientation in degrees (0° = facing right)

- **Velocity**: 
  - Linear velocity (m/s) - forward/backward speed
  - Angular velocity (rad/s) - turning rate

- **Active Keys**: Currently pressed arrow keys
- **Connection Status**: MQTT broker connection (green = connected)

---

## Technology Stack

| Component | Technology | Purpose |
|-----------|------------|---------|
| **Frontend** | HTML5, CSS3, Vanilla JavaScript | User interface |
| **Robot Simulator** | Node.js, MQTT.js | Physics engine & control |
| **Communication** | MQTT Protocol (WebSocket) | Real-time messaging |
| **Message Broker** | test.mosquitto.org (Public) | Command/state routing |
| **Hosting** | Cloudflare Tunnel | Public access |
| **Framework** | Transitive Robotics | System architecture |

---

## Git Branches

This repository has two main branches:

### **`main`** - Localhost Version (Development)
- **MQTT:** `mqtt://test.mosquitto.org:1883`
- **Purpose:** Local testing and development
- **Access:** http://localhost:8000

### **`hosted`** - Public Hosting Version (Production)
- **MQTT:** `wss://test.mosquitto.org:8081` (WebSocket)
- **Purpose:** Public demos and sharing
- **Access:** Cloudflare Tunnel URL

**Switch branches:**
```bash
git checkout main      # Local development
git checkout hosted    # Public hosting
```

---

## Development

### Making Changes

1. **Develop on `main` branch:**
```bash
   git checkout main
   # Make your changes
   git add .
   git commit -m "Description of changes"
   git push
```

2. **Test locally:**
```bash
   cd robot && node index.js          # Terminal 1
   cd web && ./start-web.sh           # Terminal 2
   # Open: http://localhost:8000
```

3. **Sync to `hosted` branch:**
```bash
   ./sync-branches.sh
```

4. **Test hosted version:**
```bash
   git checkout hosted
   cd robot && node index.js                           # Terminal 1
   cd web && ./start-web.sh                           # Terminal 2
   cloudflared tunnel --url http://localhost:8000     # PowerShell
```

---

## 🐛 Troubleshooting

### Robot Shows "Disconnected" in Terminal

**Check MQTT connection:**
```bash
# Robot should connect to: mqtt://test.mosquitto.org:1883
# Check robot/index.js line ~11 for correct URL
```

**Test connection:**
```bash
# Install mosquitto-clients
sudo apt-get install mosquitto-clients

# Test connection
mosquitto_sub -h test.mosquitto.org -p 1883 -t "test/robot1/state"
```

### Web Interface Shows "Disconnected"

**Common causes:**

1. **Wrong MQTT URL in web/index.html**
```javascript
   // Should be:
   const MQTT_URL = 'wss://test.mosquitto.org:8081';
```

2. **Browser blocking WebSocket**
   - Check browser console (F12 → Console)
   - Look for WebSocket errors

3. **Firewall blocking port 8081**
   - Try different network
   - Disable firewall temporarily to test

### Cloudflare Tunnel Stops Working

**Causes & Solutions:**

1. **Computer went to sleep**
```powershell
   # Disable sleep (Windows PowerShell - Admin)
   powercfg /change standby-timeout-ac 0
```

2. **PowerShell window closed**
   - Keep PowerShell minimized, don't close
   - Or run in background (see below)

3. **Tunnel timed out**
   - Free Cloudflare tunnels timeout after inactivity
   - Just restart: `cloudflared tunnel --url http://localhost:8000`

### Robot Not Moving

**Checklist:**

1. Robot terminal shows "Connected"
2. Web shows "Connected" status (green)
3. Browser console has no errors (F12)
4. Both using same MQTT broker (test.mosquitto.org)

**Debug steps:**
```bash
# Check robot is publishing
# In robot terminal, you should see position updates

# Check web is receiving
# In browser console (F12), should see state messages
```

### Scripts Not Executable
```bash
chmod +x robot/*.sh
chmod +x web/*.sh
chmod +x *.sh
```

---

## 🔬 Physics Implementation

The robot simulator implements **differential drive kinematics**:

### Update Rates
- **Physics:** 50Hz (20ms per update)
- **State Publishing:** 10Hz (100ms intervals)

### Motion Equations
```
# Orientation update
θ += v_angular × dt

# Position update (based on current orientation)
x += v_linear × cos(θ) × dt
y += v_linear × sin(θ) × dt

Where:
- θ (theta) = robot orientation in radians
- v_linear = linear velocity (m/s)
- v_angular = angular velocity (rad/s)
- dt = time step (0.02 seconds)
```

### Example Movement

**Moving forward at 0.5 m/s for 2 seconds:**
```
Initial: x=0, y=0, θ=0°
After 2s: x=1.0m, y=0m, θ=0°
```

**Turning left at 1.0 rad/s for π seconds:**
```
Initial: x=0, y=0, θ=0°
After πs: x=0, y=0, θ=180°
```

---

## Performance Tips

### Keep Robot Online Longer

**1. Prevent Computer Sleep:**
```powershell
# Windows (Admin)
powercfg /change standby-timeout-ac 0
```

**2. Use Screen (Keep processes alive):**
```bash
# Start robot in screen
screen -S robot
cd ~/transitive-dev/simple-teleop/robot
node index.js
# Detach: Ctrl+A then D

# Start web in screen  
screen -S web
cd ~/transitive-dev/simple-teleop/web
./start-web.sh
# Detach: Ctrl+A then D

# Reattach later
screen -r robot
screen -r web
```

**3. Auto-reconnect is already built-in!**
- Robot reconnects every 5 seconds if disconnected
- Web interface reconnects automatically
- Just keep terminals/PowerShell open

---

## Additional Documentation

- **[HOSTING.md](HOSTING.md)** - Detailed hosting guide with troubleshooting
- **[QUICK-START.txt](QUICK-START.txt)** - One-page quick reference card

---

## 👤 Author

**Thet Zin**
- GitHub: [@MoeScet](https://github.com/MoeScet)

---

## Acknowledgments

- Built with [Transitive Robotics Framework](https://transitiverobotics.com)
- Uses [test.mosquitto.org](https://test.mosquitto.org) - Free public MQTT broker
- Hosting via [Cloudflare Tunnel](https://www.cloudflare.com/products/tunnel/)
- Inspired by real robot control systems

---

## 🎓 Learning Resources

Want to learn more about the technologies used?

- **MQTT Protocol:** https://mqtt.org/
- **Transitive Robotics:** https://docs.transitiverobotics.com/
- **Cloudflare Tunnel:** https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/
- **Robot Kinematics:** https://en.wikipedia.org/wiki/Differential_wheeled_robot