sudo pacman -Syu

pacman -S curl git

sudo pacman -S zsh

sudo pacman -S zsh-autosuggestions

sudo pacman -S zsh-syntax-highlighting

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://aur.archlinux.org/asdf-vm.git && cd asdf-vm && makepkg -si
