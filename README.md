# Ubuntu GNOME 24.04 on Render.com

Minimal Ubuntu 24.04 GNOME desktop running in browser via noVNC.

## Quick Start

1. Fork this repository
2. Connect to Render.com
3. Create new Blueprint
4. Deploy

## Access

Your service URL: `https://your-app.onrender.com`

**noVNC (Browser)**: Open `https://your-app.onrender.com:5000`
- Click "Connect"
- Password: `ubuntu`

## Files

- `Dockerfile` - Container setup
- `supervisord.conf` - Service manager
- `healthcheck.py` - Health check server
- `render.yaml` - Render.com config

## Credentials

- VNC Password: `ubuntu`
- User: `ubuntu`
- Password: `ubuntu`
