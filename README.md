## Quick Start (Using Scripts)

### Easiest Way - Automated Scripts

**Terminal 1 - Robot:**
```bash
cd robot
./run-robot.sh
```

**Terminal 2 - Web:**
```bash
cd web
./start-web.sh
```

**Open:** http://localhost:8000

### Alternative - Interactive Mode

If you want to run additional commands in the container:

**Terminal 1 - Robot:**
```bash
cd robot
./start-robot.sh
# Inside container:
node index.js
```

**Terminal 2 - Web:**
```bash
cd web
./start-web.sh
```