# 🚀 secure-dev-docker

A quick-start guide to setting up your secure local development environment with Docker and VS Code.

---

## 📦 Requirements

Before you begin, make sure you have the following tools installed:

### 1. Visual Studio Code
- [Download VS Code](https://code.visualstudio.com/download) for your platform (macOS / Windows)

### 2. Docker Desktop
- [Download Docker Desktop](https://www.docker.com/products/docker-desktop) for your platform (macOS / Windows)

### 3. Git

#### ➤ On **macOS**:
If you don’t already have Git or Homebrew installed:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Then install Git
brew install git
```

#### ➤ On **Windows**:
- [Download Git for Windows](https://git-scm.com/download/win) and follow the installer prompts.

---

## ⚙️ Project Setup

1. **Clone or download** the `secure-dev-docker` project to your local machine.

2. **Open the project folder in VS Code**.

3. In VS Code, click the **Docker icon** on the left sidebar to ensure Docker integration is working properly.

---

## 🔐 SSH Key Setup

You'll need an SSH key to securely access private repositories and services.

### Generate a New SSH Key Pair

In your terminal (macOS or Git Bash / WSL on Windows):

```bash
ssh-keygen -t rsa -b 4096 -C "build-bot@kmstack.com" -f ./user_rsa
```

> 📤 **Send your _public key only_ (`user_rsa.pub`) to your admin.**  
> They will add it to the necessary repositories or project access lists.

---

## 📁 Next Steps

Once your admin has given you access:

1. Open the `docker-compose.yml` file.
2. Start the services (e.g., using the Docker extension in VS Code or via terminal).

### Attaching to the Dev Container

1. In VS Code, go to the **Docker extension panel** (left sidebar).
2. Under **Containers**, locate `secure-dev-docker-container`.
3. Right-click and choose **Attach Shell**, or click **Attach Visual Studio Code**.
4. Once the container is attached, open a terminal **inside the container**.
5. In the terminal, run:

   ```bash
   code workspace/rbac-system
This will open the rbac-system project inside the container context.

📌 Any additional project-specific setup instructions will be included in that project's README or documentation
---

## ⚠️ Security Notes

- ❗ **NEVER commit your SSH public or private keys to any repository.**
- 🔐 Always keep your private key (`user_rsa`) secure and never share it with anyone.

---

## 💡 Recommended (Optional)

- **VS Code Extensions**:
  - Docker
  - Remote - SSH
  - GitLens

- **Add `user_rsa` to your SSH agent (optional)**

```bash
eval "$(ssh-agent -s)"
ssh-add ./user_rsa
```

---

## 💬 Need Help?

If you run into issues or need help, reach out to your team admin or check your project’s internal documentation.
