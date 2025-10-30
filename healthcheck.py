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
            self.wfile.write(b'OK\n')
        else:
            # Serve simple HTML with link to noVNC
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            # Get the host from the request or use a default
            host = self.headers.get('Host', 'localhost:5000')
            base_url = host.split(':')[0]
            
            html = f"""<!DOCTYPE html>
<html>
<head>
    <title>Ubuntu GNOME Desktop VNC</title>
    <meta http-equiv="refresh" content="0; url=http://{base_url}:5000/vnc.html?autoconnect=true&resize=scale">
</head>
<body>
    <h1>Redirecting to noVNC...</h1>
    <p>If not redirected, <a href="http://{base_url}:5000/vnc.html?autoconnect=true&resize=scale">click here</a></p>
    <p>Or access noVNC directly at port 5000</p>
</body>
</html>"""
            self.wfile.write(html.encode())

    def log_message(self, format, *args):
        pass

with socketserver.TCPServer(("", PORT), HealthCheckHandler) as httpd:
    print(f"Health check server running on port {PORT}")
    httpd.serve_forever()
