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
echo " export ALIASES_PATH=$BASEDIR"
echo " source \$ALIASES_SCRIPT_PATH/.aliases"

echo ""
echo "Done."
