#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

set -e

echo "🧠 Detecting OS..."

if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
else
    echo "❌ OS detect nahi hua"
    exit 1
fi

echo "📌 OS Detected: $OS"

# Auto run based on OS
if [[ "$OS" == "ubuntu" ]]; then
    echo "🚀 Running Ubuntu installer..."
    bash "$SCRIPT_DIR/Ubuntu.sh" 

elif [[ "$OS" == "debian" ]]; then
    echo "🚀 Running Debian installer..."
    bash "$SCRIPT_DIR/Debian.sh" 
else
    echo "❌ Unsupported OS: $OS"
    exit 1
fi

echo "✅ Done! System ready."
