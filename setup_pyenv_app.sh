#!/usr/bin/env bash

# Usage: ./setup_pyenv_app.sh <python_version>
# Example: ./setup_pyenv_app.sh 2.7.18

set -euo pipefail

# --- Parameter check ---
if [ $# -ne 1 ]; then
    echo "Usage: $0 <python_version>"
    exit 1
fi

PY_VERSION="$1"

# --- Check pyenv availability ---
if ! command -v pyenv >/dev/null 2>&1; then
    echo "Error: pyenv is not initialized in your shell."
    echo "Make sure your shell config file (.profile, .bashrc, .zshrc) contains:"
    echo 'export PYENV_ROOT="$HOME/.pyenv"'
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
    echo 'eval "$(pyenv init -)"'
    exit 1
fi

APP_DIR="$(realpath .)"
APP_NAME="$(basename "$APP_DIR")"

# Normalize name: no spaces, no dashes, no special chars
SAFE_NAME="$(echo "$APP_NAME" | tr ' ' '_' | tr '-' '_' | tr -cd '[:alnum:]_')"

# Remove dots from version to avoid pyenv conflicts
VENV_NAME="${SAFE_NAME}_${PY_VERSION//./}"

echo "[+] Project directory: $APP_DIR"
echo "[+] Python version: $PY_VERSION"
echo "[+] Virtualenv name: $VENV_NAME"

# --- Install Python version if missing ---
if ! pyenv versions --bare | grep -qx "$PY_VERSION"; then
    echo "[+] Installing Python $PY_VERSION via pyenv..."
    pyenv install "$PY_VERSION"
else
    echo "[+] Python $PY_VERSION already installed."
fi

# --- Create virtualenv ---
if ! pyenv versions --bare | grep -qx "$VENV_NAME"; then
    echo "[+] Creating virtualenv via pyenv-virtualenv..."
    pyenv virtualenv "$PY_VERSION" "$VENV_NAME"
else
    echo "[+] Virtualenv $VENV_NAME already exists."
fi

# --- Local activation ---
echo "[+] Writing .python-version"
echo "$VENV_NAME" > "$APP_DIR/.python-version"

echo "[+] Activating environment locally..."
pyenv local "$VENV_NAME"

# --- Dependency installation ---
if [ -f "requirements.txt" ]; then
    echo "[+] Installing dependencies from requirements.txt..."
    pip install -r requirements.txt

elif [ -f "setup.py" ]; then
    echo "[+] Installing package via setup.py..."
    pip install .

elif [ -f "pyproject.toml" ]; then
    echo "[+] Installing package via pyproject.toml..."
    pip install .

else
    echo "[!] No installation file found (requirements.txt, setup.py, pyproject.toml)."
fi

echo "[✓] Setup complete."
echo "→ Entering this directory will automatically activate: $VENV_NAME"
