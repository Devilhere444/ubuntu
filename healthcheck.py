#!/usr/bin/env python3
import http.server
import socketserver
import os

PORT = int(os.environ.get('PORT', 8080))

class HealthCheckHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/plain')
        self.end_headers()
        self.wfile.write(b'Ubuntu GNOME VNC Server - Port 5000\n')

    def log_message(self, format, *args):
        pass

with socketserver.TCPServer(("", PORT), HealthCheckHandler) as httpd:
    print(f"Health check server running on port {PORT}")
    httpd.serve_forever()
