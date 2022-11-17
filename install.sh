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

# Global .aliases
echo "Please add the following line to your .bashrc or .zshrc file:"
echo " export ALIASES_SCRIPT_PATH=$BASEDIR/.aliases"
echo " source \$ALIASES_SCRIPT_PATH"

echo ""
echo "Done."
