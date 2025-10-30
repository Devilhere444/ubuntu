#!/usr/bin/env python3
import http.server
import socketserver
import os

PORT = int(os.environ.get('PORT', 8080))

class HealthCheckHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/health':
            self.send_response(200)
            self.send_header('Content-type', 'text/plain')
            self.end_headers()
            self.wfile.write(b'OK')
        elif self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            html = f"""
            <!DOCTYPE html>
            <html>
            <head>
                <title>Ubuntu GNOME Desktop VNC</title>
                <style>
                    body {{ font-family: Arial, sans-serif; margin: 40px; background: #f0f0f0; }}
                    .container {{ background: white; padding: 30px; border-radius: 8px; max-width: 800px; margin: 0 auto; }}
                    h1 {{ color: #E95420; }}
                    .info {{ background: #f7f7f7; padding: 15px; border-left: 4px solid #E95420; margin: 20px 0; }}
                    code {{ background: #333; color: #fff; padding: 2px 6px; border-radius: 3px; }}
                </style>
            </head>
            <body>
                <div class="container">
                    <h1>🖥️ Ubuntu GNOME Desktop VNC Server</h1>
                    <p>Your Ubuntu 24.04 GNOME Desktop is running!</p>
                    
                    <div class="info">
                        <h3>Connection Details:</h3>
                        <ul>
                            <li><strong>VNC Port:</strong> 5000</li>
                            <li><strong>Username:</strong> ubuntu</li>
                            <li><strong>Password:</strong> ubuntu</li>
                            <li><strong>VNC Password:</strong> ubuntu</li>
                        </ul>
                    </div>
                    
                    <div class="info">
                        <h3>How to Connect:</h3>
                        <p>Use any VNC client (like RealVNC, TigerVNC, or TightVNC) to connect:</p>
                        <ol>
                            <li>Open your VNC client</li>
                            <li>Connect to: <code>&lt;your-render-url&gt;:5000</code></li>
                            <li>Enter VNC password: <code>ubuntu</code></li>
                        </ol>
                    </div>
                    
                    <div class="info">
                        <h3>System Information:</h3>
                        <ul>
                            <li><strong>OS:</strong> Ubuntu 24.04 LTS</li>
                            <li><strong>Desktop:</strong> GNOME (Minimal)</li>
                            <li><strong>Storage:</strong> 500GB</li>
                        </ul>
                    </div>
                </div>
            </body>
            </html>
            """
            self.wfile.write(html.encode())
        else:
            self.send_response(404)
            self.end_headers()

    def log_message(self, format, *args):
        # Suppress logging
        pass

with socketserver.TCPServer(("", PORT), HealthCheckHandler) as httpd:
    print(f"Health check server running on port {PORT}")
    httpd.serve_forever()
