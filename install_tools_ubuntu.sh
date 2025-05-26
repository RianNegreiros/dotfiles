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

# Install SDKMAN
echo "Installing SDKMAN..."
if [ ! -d "$HOME/.sdkman" ]; then
    curl -s "https://get.sdkman.io" | bash
    # Source SDKMAN
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    # Add SDKMAN initialization to .zshrc if not already present
    if ! grep -q "sdkman-init.sh" ~/.zshrc; then
        echo '[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"' >> ~/.zshrc
    fi
else
    echo "SDKMAN is already installed, skipping..."
fi

# Install nvm (Node Version Manager)
echo "Installing nvm..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    # Add nvm initialization to .zshrc if not already present
    if ! grep -q "nvm.sh" ~/.zshrc; then
        echo 'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion' >> ~/.zshrc
    fi
else
    echo "nvm is already installed, skipping..."
fi

echo "Installation complete!"
echo "Please restart your terminal or run 'zsh' to apply changes."
echo "When you first start ZSH with Powerlevel10k, a configuration wizard will appear."
