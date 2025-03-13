# 🚀 secure-dev-docker

A quick-start guide to setting up your secure local development environment with Docker and VS Code.

---

## 📦 Requirements

Before you begin, make sure you have the following installed:

- [Visual Studio Code](https://code.visualstudio.com/download)  
- [Docker Desktop](https://www.docker.com/products/docker-desktop)  
- Git (for Mac users):

### Install Git on macOS

If you don’t already have Git or Homebrew installed:

```bash
# Install Homebrew (if not already installed)
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then install Git
brew install git
```

---

## ⚙️ Project Setup

1. **Clone or download** the `secure-dev-docker` repository.

2. **Open the project in VS Code.**

3. In VS Code, click the **Docker icon** on the left sidebar to verify Docker is connected properly.

---

## 🔐 SSH Key Setup

You’ll need an SSH key to securely access private repositories or services.

### Generate a New SSH Key Pair

Run the following command in your terminal:

```bash
ssh-keygen -t rsa -b 4096 -C "build-bot@kmstack.com" -f ./user_rsa
```

> 📤 **Send your _public key only_ (`user_rsa.pub`) to your admin**  
> They’ll add it to the appropriate repositories or projects you’ll be working on.

---

## 📁 Next Steps

All additional project-specific information and setup instructions will be provided in the documentation of the project you're assigned to.

---

## ⚠️ Security Notes

- **NEVER commit your SSH private or public keys to any repository.**
- Keep your private key (`user_rsa`) secure and protected at all times.

---

## 💬 Need Help?

If you run into issues or need further support, reach out to your team admin or check the internal documentation channels.