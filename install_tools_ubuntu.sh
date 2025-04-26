#!/bin/bash
set -e  # Exit on error

echo "Starting installation of development tools..."

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Install required dependencies
echo "Installing dependencies..."
sudo apt-get install -y zsh curl git

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed, skipping..."
fi

# Install ASDF VM (latest version)
echo "Installing ASDF VM..."
if [ ! -d "$HOME/.asdf" ]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
else
    echo "ASDF VM is already installed, skipping..."
fi

# Add ASDF to shell configuration
echo "Configuring ASDF in shell..."
ASDF_CONFIG='. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"'
grep -qF "$ASDF_CONFIG" ~/.zshrc || echo "$ASDF_CONFIG" >> ~/.zshrc

# Install Powerlevel10k
echo "Installing Powerlevel10k theme..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    echo "Powerlevel10k is already installed, skipping..."
fi

# Set Powerlevel10k as the ZSH theme
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Install ZSH Syntax Highlighting
echo "Installing ZSH Syntax Highlighting..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
else
    echo "ZSH Syntax Highlighting is already installed, skipping..."
fi

# Install ZSH Autosuggestions
echo "Installing ZSH Autosuggestions..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
else
    echo "ZSH Autosuggestions is already installed, skipping..."
fi

# Configure plugins in .zshrc
PLUGINS_LINE='plugins=(git zsh-syntax-highlighting zsh-autosuggestions)'
sed -i "s/plugins=(.*)/plugins=(git zsh-syntax-highlighting zsh-autosuggestions)/" ~/.zshrc

echo "Installation complete!"
echo "Please restart your terminal or run 'zsh' to apply changes."
echo "When you first start ZSH with Powerlevel10k, a configuration wizard will appear."
