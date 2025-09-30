# Remote connection to the laboratory

This is a brief guide for students who want to connect to the laboratory machines from home.

We use the "ssh" service to make a remote connection.

### Prerequisites

- A **Mac**, **Linux**, or **Windows (with WSL)** system.
- (Optional) An **SSH private key** if not using a password.

## SSH Setup Guide

### **Step 1: Open the Terminal**

- **macOS**: Open **Terminal** (`Cmd + Space`, then type `Terminal`).
- **Windows**: Use **PowerShell** or **WSL**.
- **Linux**: Use your default terminal emulator.

### Step 2: Connect Using SSH

Run the following command in your terminal:

```bash
ssh your_username@postel.felk.cvut.cz
```

### **Step 3: Accept the host key (first time only)**

The first time you connect, you may see a message like:
```bash
The authenticity of host 'postel.felk.cvut.cz' can't be established...
Are you sure you want to continue connecting (yes/no)?
```

Type
```bash
yes
```
Then press `Enter`.

You will then be prompted for your password (unless you are using an SSH key).

## Optional: Use SSH key instead of a password

An SSH key is much more convenient than entering your password each time you want to log into the the laboratory remotely.

### Step 4: Generate an SSH key (if you don't have one)

```bash
ssh-keygen -t ed25519 -C "your_username@cvut.cz"
```

You wil then see:
```bash
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/youruser/.ssh/id_ed25519):
```

You can press `Enter` to accept the default location, or specify a custom path.

Next:
```bash
Enter passphrase (empty for no passphrase):
```

A passphrase adds extra security, although this may be skipped if only you have access to your laptop.

### Step 5: Add the public key to the laboratory server

Note: this step requires the command `ssh-copy-id`, which may not be installed by default in all terminal applications.

On Linux-Ubuntu or Windows-WSL, you can install it with:
```bash
sudo apt install ssh-copy-id
```

Once you have generated your key, simply run:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub your_username@postel.felk.cvut.cz
```

If you renamed your key, you should specify the specific `~/.ssh/<keyname>.pub`.


This will:

- Prompt you for your remote account password (one last time).
- Create the ~/.ssh directory on the server if needed.
- Append your public key to ~/.ssh/authorized_keys.
- Set the correct permissions automatically.

Afterwards, test it:

```bash
ssh your_username@postel.felk.cvut.cz
```

You should now be able to log in without a password (or only with the local key passphrase if set).








