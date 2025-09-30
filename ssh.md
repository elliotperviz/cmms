# **SSH Setup Guide**

This is a brief guide for students who need to connect to the laboratory machines from home.

We use the "ssh" service to make a remote connection.

---

## **Prerequisites**

- A **Mac**, **Linux**, or **Windows (with WSL or PowerShell)**.
- (Optional) An **SSH private key** if not using a password.

---

## **Step 1: Open the Terminal**

- **macOS**: Open **Terminal** (`Cmd + Space`, then type `Terminal`).
- **Windows**: Use **PowerShell** or **WSL**.
- **Linux**: Use your default terminal emulator.

---

## **Step 2: Connect Using SSH**

The first time you connect, you may see a message like:
```bash
Are you sure you want to continue connecting (yes/no)?
```

Type
```bash
yes
```
Then press `Enter`.

You will then be prompted for your password (unless you are using an SSH key).

Run the following command:

```bash
ssh your_username@postel.felk.cvut.cz

## **Step 3: Accept the host key (first time only)
The authenticity of host 'linux.school.edu' can't be established...
Are you sure you want to continue connecting (yes/no)?

Type yes and press Enter.

Then enter your password when prompted (unless you're using SSH keys).



