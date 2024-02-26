#!/bin/bash

# Install base-devel and git (if not already installed)
sudo pacman -S --needed base-devel git

# Install Yay (Yet Another Yogurt)
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

# Update package lists
yay -Syu

# Install ZSH
yay -S zsh

# Install Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install ASDF VM
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.8.0

# Install Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install ZSH Syntax Highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install ZSH Autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Source ZSH to take changes into effect
source ~/.zshrc
