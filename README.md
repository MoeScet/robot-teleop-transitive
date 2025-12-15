# Robot Teleoperation with Transitive Framework

A simple robot teleoperation system built with the Transitive framework, featuring real-time control via web interface.

## Features

- Real-time 2D robot physics simulation
- Arrow key control (WASD alternative)
- Live position and velocity display
- Web-based interface (no installation needed)
- MQTT communication protocol
- Docker containerized

## Architecture
```
Web Browser (Controls) ←→ MQTT Broker ←→ Robot Simulator (Physics)
```

## Components

- **Robot Component** (`robot/`): Node.js physics simulator
- **Web Component** (`web/`): HTML/JavaScript interface
- **Cloud Component** (`cloud/`): Optional server-side processing (not used in basic version)

## Quick Start

### Prerequisites

- Docker
- Node.js 18+
- Python 3 (for web server)

### Localhost Version (Development)

**Terminal 1 - Robot Simulator:**
```bash
cd robot
docker run -it --rm --name robot-simulator --network cloud_default \
  -v $(pwd):/app -w /app node:18-alpine sh
npm install
node index.js
```

**Terminal 2 - Web Interface:**
```bash
cd web
python3 -m http.server 8000
```

**Open:** http://localhost:8000

### Controls

- `↑` - Move forward
- `↓` - Move backward
- `←` - Turn left
- `→` - Turn right
- `SPACE` - Emergency stop
- Speed slider - Adjust velocity multiplier

## Versions

This repository has two main branches:

- `main` - Localhost version (development)
- `hosted` - ngrok/public hosting version

## Technology Stack

- **Frontend:** HTML, CSS, JavaScript
- **Backend:** Node.js
- **Communication:** MQTT (mosquitto)
- **Containerization:** Docker
- **Framework:** Transitive Robotics

## Project Structure
```
.
├── robot/              # Robot simulator
│   ├── index.js       # Physics engine & MQTT client
│   └── package.json
├── web/               # Web interface
│   └── index.html    # Control UI
└── cloud/            # Cloud component (optional)
```

## License

None

## Author

Thet Zin
