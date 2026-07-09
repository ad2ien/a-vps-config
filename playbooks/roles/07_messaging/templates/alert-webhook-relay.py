#!/usr/bin/env python3
"""
Webhook relay → Matrix via Hookshot

Accepts Alertmanager or Dockhand JSON payloads and forwards them as
clean text messages to a Hookshot generic webhook. The path from the
incoming request is preserved, so the Hookshot webhook token stays
in the URL.

Alertmanager input:
  {
    "status": "firing",
    "groupLabels": {"alertname": "HighDiskUsage"},
    "alerts": [{
      "annotations": {"description": "Disk on / is 86.05% full (threshold: 80%)"}
    }]
  }
  → "🔥 FIRING: HighDiskUsage\n  • Disk on / is 86.05% full (threshold: 80%)"

Dockhand input:
  {
    "title": "Dockhand Test Notification",
    "message": "This is a test notification from Dockhand.",
    "type": "info",
    "environment": "production",
    "timestamp": "2026-07-09T06:29:25.838Z"
  }
  → "ℹ️ Dockhand Test Notification\nThis is a test notification from Dockhand.\nEnvironment: production"

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


def format_payload(payload):
    if "groupLabels" in payload or "alerts" in payload:
        return _format_alertmanager(payload)
    if "title" in payload or "message" in payload:
        return _format_dockhand(payload)
    return json.dumps(payload, indent=2)


def _format_alertmanager(payload):
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


def _format_dockhand(payload):
    title = payload.get("title", "Notification")
    message = payload.get("message", "")
    ptype = payload.get("type", "info")
    env = payload.get("environment")

    icons = {"info": "ℹ️", "success": "✅", "warning": "⚠️", "error": "🚨"}
    icon = icons.get(ptype, "📢")

    lines = [f"{icon} {title}"]
    if message:
        lines.append(message)
    if env:
        lines.append(f"Environment: {env}")

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

        text = format_payload(payload)
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
