# Quick Deployment Guide for Render.com

## Prerequisites
- GitHub account
- Render.com account (sign up at https://render.com)

## Step-by-Step Deployment

### 1. Push Code to GitHub
```bash
git push origin main
```

### 2. Deploy on Render.com

#### Option A: Blueprint (Recommended)
1. Go to https://dashboard.render.com
2. Click "New" → "Blueprint"
3. Connect your GitHub repository
4. Render will detect `render.yaml` automatically
5. Click "Apply" to deploy

#### Option B: Manual Web Service
1. Go to https://dashboard.render.com
2. Click "New" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - **Name**: ubuntu-gnome-desktop
   - **Environment**: Docker
   - **Plan**: Pro Ultra
   - **Region**: Oregon (or your preferred region)
5. Add Disk:
   - **Name**: ubuntu-storage
   - **Mount Path**: /home/ubuntu
   - **Size**: 500 GB
6. Add Environment Variables:
   - `PORT`: 8080
   - `VNC_PORT`: 5000
7. Click "Create Web Service"

### 3. Wait for Deployment
- Initial deployment takes 5-10 minutes
- Watch the logs in Render dashboard
- Wait for "Health check passed" message

### 4. Get Connection Details
Once deployed, you'll get a URL like:
```
https://ubuntu-gnome-desktop-xxxx.onrender.com
```

### 5. Connect via VNC
1. Install a VNC client:
   - **Windows**: RealVNC Viewer, TightVNC
   - **Mac**: RealVNC Viewer, Screen Sharing
   - **Linux**: Remmina, TigerVNC
   
2. Connect to:
   ```
   ubuntu-gnome-desktop-xxxx.onrender.com:5000
   ```

3. Enter VNC password: `ubuntu`

4. Enjoy your Ubuntu GNOME desktop!

### 6. Access Your GNOME Desktop
Visit your service URL in a browser to verify the health check:
```
https://ubuntu-gnome-desktop-xxxx.onrender.com
```

You should see: "Ubuntu GNOME VNC Server - Port 5000"

## Troubleshooting

### Service Not Starting
- Check logs in Render dashboard
- Verify Docker build succeeded
- Ensure Pro Ultra plan is selected

### Can't Connect via VNC
- Verify port 5000 is accessible
- Check firewall settings
- Try connecting from different network
- Ensure VNC client supports VNC protocol (not RDP)

### Health Check Failing
- Wait 2-3 minutes for full startup
- Check logs for errors
- Verify port 8080 is responding

### Performance Issues
- Confirm Pro Ultra plan is active
- Check Render metrics for resource usage
- Consider reducing screen resolution in supervisord.conf

## Costs
- **Pro Ultra Plan**: ~$85/month
- **500GB Storage**: ~$25/month
- **Total**: ~$110/month

## Support
- **Render Issues**: https://render.com/docs
- **VNC Issues**: Check your VNC client documentation
- **Ubuntu/GNOME**: https://help.ubuntu.com

## Tips
- Save your work regularly
- Use the 500GB persistent storage for important files
- Consider scheduled backups of /home/ubuntu
- Pause service when not in use to save costs
