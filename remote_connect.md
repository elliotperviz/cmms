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

In the terminal on your home computer, follow the next steps to setup an SSH key.

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

With `ssh-copy-id` and your generated SSH key, simply run:

```bash
ssh-copy-id -i ~/.ssh/id_ed25519.pub your_username@postel.felk.cvut.cz
```

This will:

- Prompt you for your remote account password (one last time).
- Create the ~/.ssh directory on the server if needed.
- Append your public key to ~/.ssh/authorized_keys.
- Set the correct permissions automatically.

Note, if you renamed your key, you should specify the appropriate `~/.ssh/<keyname>.pub`.

Afterwards, test it:

```bash
ssh your_username@postel.felk.cvut.cz
```

You should now be able to log in without a password (or only with the local key passphrase if set).

## Remote connection with X-forwarding

Some extra setup is required in order to visualise plots or use GUI programs when connecting to the laboratory remotely. Specifically, you need to setup "X-forwarding", which forwards the graphical windows from the remote machine to your local computer.

### Step 6: Install an X server (if needed)

- **macOS**: Install **XQuartz** (https://www.xquartz.org/)
- **Windows**: Install VcXsrv (https://sourceforge.net/projects/vcxsrv/)
- **Linux**: Use your default terminal emulator (no additional installation necessary)

### Step 7: Connect with X-forwarding

In your terminal, use the `-X` option when connecting via SSH:

```bash
ssh -X your_username@postel.felk.cvut.cz
```

After connecting with X-forwarding enabled, try running a simple GUI proram on the server e.g. type
```bash
thunar
```
to open the file browser, or
```bash
firefox
```
to open the web browser.

It may take some time to load the GUI locally, but if it opens correctly, you are good to go!
