# ubuntu-scripts

A collection of automation scripts for Ubuntu system maintenance and setup.

## Scripts

| Script | Description |
|---|---|
| `system-update.sh` | Full system update (apt + snap + flatpak) and cleanup |
| `disk-cleanup.sh` | Free up disk space: temp files, logs, apt cache, old snaps |
| `install-essentials.sh` | Install common development and sysadmin tools |
| `setup-firewall.sh` | Configure UFW firewall with sensible defaults |
| `system-info.sh` | Display detailed system information report |
| `backup.sh` | Backup home directory to a destination |
| `create-user.sh` | Create a new sudo user |
| `monitor.sh` | Real-time system monitor (CPU, memory, disk, processes) |

## Usage

```bash
git clone https://github.com/clubkimmagroup-cloud/ubuntu-scripts
cd ubuntu-scripts
chmod +x *.sh

# Example
./system-update.sh
./disk-cleanup.sh
./system-info.sh
./monitor.sh          # real-time, Ctrl+C to quit
./backup.sh /media/backup
./create-user.sh newuser
```

## Requirements

- Ubuntu 20.04+ (tested on Ubuntu 26.04 LTS)
- `sudo` privileges for most scripts
