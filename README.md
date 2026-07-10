<div align="center"><img src="assets/logo.png" alt="Erymont Logo" width="180">Erymont

A modern, colorful, and powerful Linux distribution management CLI.

Install, manage, launch, back up, restore, and maintain Linux environments from a single command.

""License: MIT" (https://img.shields.io/badge/License-MIT-blue.svg)" (LICENSE)
"Platform" (https://img.shields.io/badge/Platform-Linux-success)
"Shell" (https://img.shields.io/badge/Bash-5.0+-orange)
"Version" (https://img.shields.io/badge/version-1.0.0-cyan)

</div>---

Overview

Erymont is a lightweight command-line utility designed to simplify Linux environment management through a clean and intuitive interface.

It provides a modern CLI experience with colorful output, intelligent diagnostics, backup tools, configuration management, and an extensible architecture while remaining compact and easy to maintain.

---

Features

- Modern command-based CLI
- Beautiful colorful terminal interface
- Downloadable ASCII logo with local cache
- Install supported Linux distributions
- Start, stop and restart environments
- Interactive shell access
- Backup and restore support
- Built-in diagnostics ("doctor")
- Configurable settings
- Automatic dependency checks
- Safe error handling
- Mobile-friendly project structure
- ShellCheck-friendly Bash code
- Modular architecture
- MIT Licensed

---

Requirements

- Linux
- Bash 5.0 or newer
- curl or wget
- tar
- gzip
- Internet connection (required only for downloads)

---

Installation

Clone the repository:

git clone https://github.com/YOUR_USERNAME/erymont.git

Enter the project directory:

cd erymont

Make the launcher executable:

chmod +x ery

Verify the installation:

./ery version

Display available commands:

./ery help

---

Quick Start

Install Ubuntu

./ery install ubuntu

Start Ubuntu

./ery start ubuntu

Open a shell

./ery shell ubuntu

List installed environments

./ery list

---

Command Reference

Command| Description
"ery install ubuntu"| Install Ubuntu
"ery install debian"| Install Debian
"ery install arch"| Install Arch Linux
"ery start <name>"| Start an environment
"ery stop <name>"| Stop an environment
"ery restart <name>"| Restart an environment
"ery shell <name>"| Open an interactive shell
"ery remove <name>"| Remove an environment
"ery list"| Show installed environments
"ery info <name>"| Display information
"ery backup <name>"| Create a backup
"ery restore <name>"| Restore from a backup
"ery doctor"| Run diagnostics
"ery update"| Update Erymont
"ery config"| Manage configuration
"ery version"| Show version
"ery help"| Display help

---

Example Workflow

./ery install ubuntu
./ery start ubuntu
./ery shell ubuntu
./ery backup ubuntu
./ery stop ubuntu

---

Project Structure

erymont/
├── ery
├── README.md
├── LICENSE
├── .gitignore
├── core/
├── config/
├── assets/
└── docs/

---

Configuration

Configuration is stored inside:

config/config.sh

You can customize:

- Logo URL
- Logo cache
- Download timeout
- Retry count
- Preferred download utility
- Theme colors

---

Troubleshooting

Command not found

Ensure the launcher is executable.

chmod +x ery

Download failed

Check your internet connection and verify the configured logo URL.

Missing dependency

Run:

./ery doctor

---

Contributing

Contributions are welcome.

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push the branch.
5. Open a Pull Request.

Please ensure all Bash scripts remain readable, properly quoted, and free of syntax errors.

---

License

This project is licensed under the MIT License.

See the "LICENSE" file for details.

---

<div align="center">Made with ❤️ for the Linux community.

Erymont — Powerful Linux Management from Your Terminal.

</div>
