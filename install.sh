# Check we are using zsh
echo "Checking we are using ZSH..."
if [[ $ZSH_NAME == "zsh" ]]; then
  echo ""
else
  echo "Error: Not using ZSH."
  echo ""
  echo "Please use ZSH to run this script."
  exit 1
fi

# The .dotfiles repo directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# git
echo "Configuring git user..."
git config --global user.email "ben@heidemann.co.uk"
git config --global user.name "Ben Heidemann"
echo ""

# Global .gitignore
echo "Linking $BASEDIR/.gitignore to $HOME/.gitignore..."
ln -s $BASEDIR/.gitignore $HOME/.gitignore

echo "Configuring git core.excludesfile..."
git config --global core.excludesfile $HOME/.gitignore
echo ""

# Create .config directory
echo "Creating $HOME/.config directory..."
mkdir -p $HOME/.config
echo ""

# Install nvim config
echo "Installing NeoVim config..."
ln -s $BASEDIR/.config/nvim $HOME/.config/nvim
echo ""

# Global .aliases
echo "Please add the following line to your .zshrc file:"
echo " export DOTFILES_PATH=$BASEDIR"
echo " source \$DOTFILES_PATH/.aliases"
echo " export PATH=\"$DOTFILES_PATH/bin:$PATH\""
echo ""

# Recommended bindkey commands
echo "You may also want to add the following lines to your .zshrc file:"
echo " bindkey \"^[[3~\" delete-char"
echo " bindkey \"^[[1;5C\" emacs-forward-word"
echo " bindkey \"^[[1;5D\" emacs-backward-word"
echo ""

echo "Done."
