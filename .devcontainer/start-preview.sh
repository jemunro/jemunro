#!/usr/bin/env bash
# Start the Quarto preview unless it is already running. Log: /tmp/quarto-preview.log
cd "$(dirname "$0")/.." || exit 1
if curl -s -o /dev/null --max-time 2 http://localhost:4200/; then exit 0; fi
nohup quarto preview --port 4200 --host 0.0.0.0 --no-browser >/tmp/quarto-preview.log 2>&1 &
