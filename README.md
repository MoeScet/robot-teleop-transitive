# Robot Teleoperation with Transitive Framework

A simple robot teleoperation system built with the Transitive framework, featuring real-time control via web interface.

## Features

- Real-time 2D robot physics simulation (50Hz physics, 10Hz state publishing)
- Intuitive arrow key control
- Live position (X, Y, θ) and velocity display
- Web-based interface (no installation needed for users)
- MQTT communication protocol
- Fully containerized with Docker
- Easy deployment scripts

## Architecture
```
┌─────────────────┐
│  Web Browser    │  ← Users control robot here
│  (Arrow Keys)   │
└────────┬────────┘
         │ MQTT (WebSocket)
         ▼
┌─────────────────┐
│  MQTT Broker    │  ← Message routing
│  (mosquitto)    │
└────────┬────────┘
         │ MQTT
         ▼
┌─────────────────┐
│ Robot Simulator │  ← Physics engine
│  (Node.js)      │
└─────────────────┘
```

## Project Structure
```
.
├── robot/                  # Robot simulator component
│   ├── index.js           # Physics engine & MQTT client
│   ├── package.json       # Dependencies
│   ├── run-robot.sh       # One-command automated startup
│   └── start-robot.sh     # Interactive startup (with shell)
│
├── web/                   # Web interface component
│   ├── index.html         # Control UI
│   └── start-web.sh       # Web server startup script
│
├── cloud/                 # Cloud component (optional, not used)
│
├── setup-cloudflare.sh         # Helper to configure cloudflare URL
├── sync-branches.sh       # Sync main branch to hosted branch
└── README.md              # This file
```

## Quick Start

### Prerequisites

- **Windows with WSL2** (Ubuntu recommended)
- **Docker** (installed in WSL)
- **Node.js 18+** (for local development)
- **Python 3** (for web server)
- **cloudflare** (for public hosting - optional)

### Localhost Version (Development)

Perfect for local testing and development.

**Terminal 1 - Start Robot:**
```bash
cd robot
./run-robot.sh
```

**Terminal 2 - Start Web Interface:**
```bash
cd web
./start-web.sh
```

**Access:** http://localhost:8000

**That's it!** 

### Alternative: Interactive Mode

If you need to run additional commands in the robot container:

**Terminal 1:**
```bash
cd robot
./start-robot.sh
# Inside container:
node index.js
# Or run other commands...
```

## Public Hosting (c)

See [HOSTING.md](HOSTING.md) for detailed instructions on making your robot accessible from anywhere.

Quick overview:
1. Switch to `hosted` branch
2. Start cloudflare tunnels
3. Update MQTT URL
4. Share public URL!

## Controls

| Key | Action |
|-----|--------|
| `↑` | Move forward |
| `↓` | Move backward |
| `←` | Turn left |
| `→` | Turn right |
| `SPACE` | Emergency stop |
| Speed Slider | Adjust velocity (0.1x - 2.0x) |

## Display Information

- **Position**: X, Y coordinates (meters) and orientation θ (degrees)
- **Velocity**: Linear speed (m/s) and angular velocity (rad/s)
- **Active Keys**: Currently pressed keys
- **Connection Status**: MQTT broker connection state

## Technology Stack

| Component | Technology |
|-----------|------------|
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Robot Simulator | Node.js, MQTT.js |
| Communication | MQTT Protocol (WebSocket for browser) |
| Message Broker | Eclipse Mosquitto |
| Containerization | Docker |
| Framework | Transitive Robotics |

## Git Branches

This repository has two main branches:

- **`main`** - Localhost version (development)
  - MQTT: `ws://localhost:9002`
  - For local testing and development
  
- **`hosted`** - Public hosting version (production)
  - MQTT: `wss://your-cloudflare-url`
  - For sharing with others via cloudflare

Switch branches:
```bash
git checkout main      # Localhost version
git checkout hosted    # Hosted version
```

## Development

### Making Changes

1. **Make changes on `main` branch:**
```bash
   git checkout main
   # Make your changes
   git add .
   git commit -m "Your changes"
   git push
```

2. **Sync to `hosted` branch:**
```bash
   ./sync-branches.sh
```

### Testing

Always test on localhost first:
```bash
git checkout main
cd robot && ./run-robot.sh
# In another terminal:
cd web && ./start-web.sh
# Access: http://localhost:8000
```

## Troubleshooting

### Robot Won't Connect

1. Check if `test-mosquitto` is running:
```bash
   docker ps | grep test-mosquitto
```

2. Restart MQTT broker:
```bash
   docker start test-mosquitto
```

### Web Interface Shows "Disconnected"

1. Check MQTT URL in `web/index.html`
2. Verify MQTT broker is accessible
3. Check browser console (F12) for errors

### Scripts Not Executable
```bash
chmod +x robot/*.sh
chmod +x web/*.sh
chmod +x *.sh
```

## Physics Implementation

The robot simulator implements differential drive kinematics:

- **Update Rate**: 50Hz (20ms intervals)
- **State Publishing**: 10Hz (100ms intervals)
- **Position Update**: 
```
  x += v_linear * cos(θ) * dt
  y += v_linear * sin(θ) * dt
  θ += v_angular * dt
```

## Author

**Thet Zin**
- GitHub: [@MoeScet](https://github.com/MoeScet)

## Acknowledgments

- Built with [Transitive Robotics Framework](https://transitiverobotics.com)
- Uses [Eclipse Mosquitto](https://mosquitto.org) MQTT broker
- Inspired by real robot control systems

## Additional Documentation

- [HOSTING.md](HOSTING.md) - Detailed hosting instructions
- [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Common issues and solutions

---