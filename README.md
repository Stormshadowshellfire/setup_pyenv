<h1>🚀 setup_pyenv_app.sh</h1>

<p>A lightweight and reliable setup script that automates the creation of isolated Python environments using pyenv and pyenv‑virtualenv.<br/>
It installs the requested Python version (if missing), creates a dedicated virtual environment, activates it locally via .python-version, and installs project dependencies.

This script is ideal for developers who want a reproducible, clean, and automatic Python setup right after cloning a repository.</p>

<h2>✨ Features</h2>
<ul>
<li>Automatic installation of any Python version supported by pyenv</li>
<li>Virtual environment creation via pyenv‑virtualenv</li>
<li>Local activation through .python-version</li>
<li>Safe environment naming (no spaces, no special characters)</li>
<li>Dependency installation from:</li><ul>
<li>requirements.txt</li>
<li>setup.py</li>
<li>pyproject.toml</li></ul>
<li>Idempotent: safe to run multiple times</li>
<li>Strict Bash mode (set -euo pipefail) to avoid silent failures</li></ul>

<h2>📦 Requirements</h2>
<ul>
<li>pyenv</li>
<li>pyenv‑virtualenv</li>
<li>A shell where pyenv is initialized (bash, zsh, etc.)</li></ul>

Your shell config file (e.g. .profile, .bashrc, .zshrc) must include:
```
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

<h2>🛠️ Usage</h2>

Run the script from inside your project directory:

```
./setup_pyenv_app.sh <python_version>
```

Example:

```
./setup_pyenv_app.sh 3.11.6
```

This will:
<ol>
<li>Install Python 3.11.6 via pyenv (if missing)</li>
<li>Create a virtualenv named <projectname>_3116</li>
<li>Write .python-version for automatic activation</li>
<li>Install dependencies if a supported file is present</li></ol>

<h2>🔍 How It Works</h2>

<p>Environment Naming<br/>
The script uses the current directory name, normalizes it, and appends the Python version (without dots).</p>

<p>Python Installation<br/>
If the requested version is not installed, pyenv compiles it.</p>

<p>Virtualenv Creation<br/>
The script creates a dedicated environment using:</p>

```
pyenv virtualenv <version> <env_name>
```

<p>Local Activation<br/>
A .python-version file is written so pyenv automatically activates the environment when entering the directory.</p>

<p>Dependency Installation<br/>
The script detects and installs from:</p>
<ul>
<li>requirements.txt</li>
<li>setup.py</li>
<li>pyproject.toml</li></ul>

<p>If none are found, it simply warns and exits cleanly.</p>

<h2>📘 Example Output</h2>

```
[+] Project directory: /home/user/mytool
[+] Python version: 3.11.6
[+] Virtualenv name: mytool_3116
[+] Installing Python 3.11.6 via pyenv...
[+] Creating virtualenv via pyenv-virtualenv...
[+] Writing .python-version
[+] Activating environment locally...
[+] Installing dependencies from requirements.txt...
[✓] Setup complete.
→ Entering this directory will automatically activate: mytool_3116
```

<h2>🧩 Notes</h2>

<ul><il>The script assumes it is run from a terminal (interactive shell).</il>
<il>It does not modify your shell configuration; pyenv must already be initialized.</il>
<il>If Python compilation fails, you may need system dependencies (e.g. libssl-dev, zlib1g-dev, etc.).</il></ul>

