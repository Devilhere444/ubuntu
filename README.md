# Ubuntu GNOME 24.04 Desktop on Render.com

A clean Ubuntu 24.04 GNOME desktop environment running in Docker, optimized for Render.com deployment with VNC access.

## Features

- **OS**: Ubuntu 24.04 LTS
- **Desktop**: GNOME (Minimal Installation)
- **Remote Access**: VNC Server on port 5000
- **Web Interface**: Health check and info page on port 8080
- **Storage**: 500GB persistent disk
- **Plan**: Pro Ultra (32GB RAM, highest CPU configuration)

## Deployment on Render.com

### Quick Deploy

1. Fork this repository
2. Connect your GitHub account to Render.com
3. Create a new **Blueprint** in Render
4. Point it to your forked repository
5. Render will automatically detect `render.yaml` and deploy

### Configuration

The service is configured for:
- **Plan**: Pro Ultra (32GB RAM, 8 vCPUs)
- **Region**: Oregon (can be changed in render.yaml)
- **Persistent Storage**: 500GB mounted at `/home/ubuntu`
- **Auto-deploy**: Enabled on git push

## Accessing Your Desktop

### Via VNC Client

1. Install a VNC client (RealVNC Viewer, TigerVNC, TightVNC, etc.)
2. Get your Render service URL from the dashboard
3. Connect to: `<your-render-url>:5000`
4. Enter VNC password: `ubuntu`

### Web Interface

Visit your Render service URL in a browser to see:
- Connection instructions
- System information
- Health status at `/health`

## Credentials

- **VNC Password**: `ubuntu`
- **System User**: `ubuntu`
- **User Password**: `ubuntu`
- **Sudo Access**: Yes (ubuntu user has sudo privileges)

## Services Running

The following services are managed by Supervisor:

1. **Health Check Server** (Port 8080) - HTTP server for Render health checks
2. **D-Bus System Daemon** - Required for GNOME
3. **VNC Server** (Port 5000) - Xvnc with 1920x1080 resolution
4. **GNOME Session** - Full GNOME desktop environment

## Resource Specifications

### Pro Ultra Plan Includes:
- **RAM**: 32GB
- **vCPUs**: 8 cores
- **Storage**: 500GB persistent SSD
- **Network**: High-performance networking
- **Bandwidth**: Unlimited

## Customization

### Change VNC Password

Edit `Dockerfile` line 22:
```dockerfile
echo "YOUR_PASSWORD" | vncpasswd -f > ~/.vnc/passwd && \
```

### Change Screen Resolution

Edit `supervisord.conf` line 18:
```ini
command=/usr/bin/Xvnc :1 -geometry 1920x1080 ...
```

Common resolutions: 1920x1080, 2560x1440, 3840x2160

### Change Storage Size

Edit `render.yaml` line 11:
```yaml
sizeGB: 500  # Change to your desired size
```

### Change Region

Edit `render.yaml` line 6:
```yaml
region: oregon  # Options: oregon, frankfurt, singapore, ohio
```

## Files

- `Dockerfile` - Container configuration
- `supervisord.conf` - Service manager configuration
- `healthcheck.py` - Web health check server
- `render.yaml` - Render.com blueprint configuration

## Troubleshooting

### VNC Connection Refused
- Check that the service is fully started (may take 2-3 minutes)
- Verify port 5000 is exposed in Render dashboard
- Check logs in Render dashboard for errors

### GNOME Not Starting
- Check supervisor logs in Render dashboard
- Ensure D-Bus is running before GNOME
- Verify /run/user/1000 directory exists

### Performance Issues
- Ensure you're on Pro Ultra plan for best performance
- Check Render metrics for resource usage
- Consider reducing screen resolution for lower bandwidth

## Cost Optimization

- Pro Ultra plan: ~$85/month
- 500GB storage: ~$25/month
- Total estimated: ~$110/month

For lower costs, you can:
- Reduce to Pro or Standard plan
- Reduce storage size
- Use only when needed (pause when not in use)

## Support

For issues with:
- **Render deployment**: Check Render.com documentation
- **VNC connection**: Check firewall and VNC client settings
- **GNOME issues**: Check Ubuntu/GNOME documentation

## License

This configuration is provided as-is for educational and development purposes.
