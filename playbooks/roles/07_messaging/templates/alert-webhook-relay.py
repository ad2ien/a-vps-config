#!/usr/bin/env python3
"""
Alertmanager → Matrix webhook relay

Receives Alertmanager webhook payloads and forwards them as clean text
messages to a Hookshot generic webhook. The path from the incoming request
is preserved, so the Hookshot webhook token stays in the URL.

Input (from Alertmanager):
  POST /512aa5cc-...  (Alertmanager JSON payload)
  {
    "status": "firing",
    "groupLabels": {"alertname": "HighDiskUsage"},
    "alerts": [{
      "annotations": {"description": "Disk on / is 86.05% full (threshold: 80%)"}
    }]
  }

Output (to Hookshot):
  POST https://hook.{$domain}/512aa5cc-...
  {"text": "🔥 FIRING: HighDiskUsage\n  • Disk on / is 86.05% full (threshold: 80%)"}

Environment:
  HOOKSHOT_BASE_URL  Target Hookshot base (default: https://hook.ad2ien.dev)
  PORT               Listen port (default: 9094)
"""
import json
import os
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from urllib.request import Request, urlopen
from urllib.error import URLError

HOOKSHOT_BASE = os.environ.get("HOOKSHOT_BASE_URL", "https://hook.ad2ien.dev")


def format_alert(payload):
    status = payload.get("status", "unknown")
    alertname = payload.get("groupLabels", {}).get("alertname", "Unknown")

    prefix = "✅ RESOLVED" if status == "resolved" else "🔥 FIRING"
    lines = [f"{prefix}: {alertname}"]

    for alert in payload.get("alerts", []):
        ann = alert.get("annotations", {})
        desc = ann.get("description", "")
        if desc:
            lines.append(f"  • {desc}")

    return "\n".join(lines)


class AlertHandler(BaseHTTPRequestHandler):
    def do_POST(self):
        content_length = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(content_length)

        try:
            payload = json.loads(body)
        except json.JSONDecodeError:
            self.send_response(400)
            self.end_headers()
            self.wfile.write(b"invalid json")
            return

        text = format_alert(payload)
        forward = json.dumps({"text": text}).encode("utf-8")
        target = f"{HOOKSHOT_BASE}{self.path}"

        req = Request(
            target,
            data=forward,
            headers={"Content-Type": "application/json"},
            method="POST",
        )

        try:
            with urlopen(req, timeout=10):
                self.send_response(200)
                self.end_headers()
                self.wfile.write(b"ok")
        except URLError as e:
            self.send_response(502)
            self.end_headers()
            self.wfile.write(f"forward failed: {e.reason}".encode())

if __name__ == "__main__":
    port = int(os.environ.get("PORT", 9094))
    server = HTTPServer(("0.0.0.0", port), AlertHandler)
    sys.stderr.write(f"[alert-relay] listening on {port}\n")
    server.serve_forever()
