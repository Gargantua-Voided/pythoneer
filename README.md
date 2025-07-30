

<img width="300" height="300" alt="pythoneer_logo" src="https://github.com/user-attachments/assets/79e228a1-ea31-4450-8b28-7a593b278c46" />




# 🐍 Portable Python Development Environment

This project sets up a portable development environment with Python and Git, allowing you to code anywhere without installing anything on the host system! 

## ✨ Features

- 🐍 Portable Python 3.11.5
- 📦 Pre-configured pip package manager
- 🌿 Portable Git 2.42.0
- 🔄 Automatic repository cloning
- 📝 Dependency management with requirements.txt
- 🎯 Zero system installation required

## 🚀 Quick Start

1. Download this project
2. Run `setup_portable_env.bat`
3. When prompted, enter your GitHub repository URL (or press Enter to skip)
4. Start coding with `launch.bat`!

## 🛠️ What Gets Installed?

The setup script creates a `portable` directory containing:
- `python/` - Python 3.11.5 with pip
- `git/` - Git 2.42.0
- Your cloned repository in `repo/`

## 📝 Environment Details

- 🐍 Python: Embedded distribution 3.11.5
- 🌿 Git: Portable Git 2.42.0
- 📂 Structure:
  ```
  your-folder/
  ├── portable/
  │   ├── python/
  │   └── git/
  ├── repo/
  ├── setup_portable_env.bat
  ├── launch.bat
  └── README.md
  ```

## 💻 Usage

1. 🔧 First-time setup:
   ```batch
   setup_portable_env.bat
   ```

2. 🚀 Start coding:
   ```batch
   launch.bat
   ```

3. 🛠️ Available commands in the environment:
   - `python` - Run Python interpreter
   - `pip` - Manage Python packages
   - `git` - Version control commands

## 🤝 Contributing

Feel free to:
- 🐛 Report bugs
- 💡 Suggest features
- 🔀 Submit pull requests

## ⚖️ License

This project is open-source and free to use! 🎉
