# Linux Cheat Sheet for Beginners

## File & Directory Commands
| Command | Explanation |
|---------|-------------|
| `pwd` | Show current directory. |
| `ls` | List files in the current directory. |
| `ls -l` | List files with details (permissions, size, date). |
| `cd <dir>` | Change directory to `<dir>`. |
| `cd ..` | Move up one directory. |
| `mkdir <dir>` | Create a new directory `<dir>`. |
| `rmdir <dir>` | Remove an empty directory `<dir>`. |
| `rm -r <dir>` | Remove a directory and its contents. |
| `touch <file>` | Create an empty file `<file>`. |
| `cp <src> <dest>` | Copy file or directory. |
| `mv <src> <dest>` | Move or rename file/directory. |
| `rm <file>` | Delete a file. |

---

## File Viewing & Editing
| Command | Explanation |
|---------|-------------|
| `cat <file>` | Show the contents of a file. |
| `less <file>` | View file page by page. |
| `head <file>` | Show first 10 lines of a file. |
| `tail <file>` | Show last 10 lines of a file. |
| `nano <file>` | Edit file in terminal (simple editor). |
| `vim <file>` | Edit file with advanced editor (keyboard shortcuts). |

---

## File Searching & Filtering
| Command | Explanation |
|---------|-------------|
| `find . -name "<pattern>"` | Search for files matching `<pattern>` in current dir. |
| `grep "<text>" <file>` | Search for `<text>` inside a file. |
| `grep -r "<text>" <dir>` | Search recursively in directory. |

---

## Permissions
| Command | Explanation |
|---------|-------------|
| `ls -l` | View file permissions. |
| `chmod +x <file>` | Make a file executable. |
| `chown <user>:<group> <file>` | Change file owner and group. |

---

## Processes & System
| Command | Explanation |
|---------|-------------|
| `ps` | Show current running processes. |
| `top` | Show real-time system processes. |
| `kill <pid>` | Terminate a process by PID. |
| `df -h` | Show disk usage. |
| `free -h` | Show memory usage. |

---

## Package Management (Ubuntu/Debian)
| Command | Explanation |
|---------|-------------|
| `sudo apt update` | Update package list. |
| `sudo apt upgrade` | Upgrade installed packages. |
| `sudo apt install <package>` | Install a new package. |
| `sudo apt remove <package>` | Remove a package. |

---

## Networking
| Command | Explanation |
|---------|-------------|
| `ping <host>` | Check connectivity to `<host>`. |
| `wget <url>` | Download a file from the internet. |
| `scp <src> <user>@<host>:<dest>` | Copy files to/from remote machine. |
| `ssh <user>@<host>` | Connect to remote machine via SSH. |

---

## Redirection & Pipes
| Command | Explanation |
|---------|-------------|
| `>` | Redirect output to a file (overwrite). |
| `>>` | Redirect output to a file (append). |
| `|` | Pipe output of one command to another. |

---

## Tips
- `Tab` → Auto-complete file/directory names.  
- `Ctrl + C` → Stop a running command.  
- `Ctrl + Z` → Pause a command and send it to background.  
- `history` → Show previously executed commands.  
