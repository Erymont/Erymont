#!/usr/bin/env bash
set -euo pipefail
APP_NAME="Erymont"
APP_VERSION="1.0.0"
APP_TAGLINE="Modern cloud installer and management suite"
LOGO_CACHE="assets/logo.cache"
LOGO_URL=""
RETRY_COUNT=3
TIMEOUT_SECONDS=15
DOWNLOAD_TOOL="curl"
