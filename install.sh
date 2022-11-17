# The .dotfiles repo directory
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Global .gitignore
echo "Linking $BASEDIR/.gitignore to $HOME/.gitignore..."
ln -s $BASEDIR/.gitignore $HOME/.gitignore

echo "Configuring git core.excludesfile..."
git config --global core.excludesfile $HOME/.gitignore


echo ""
echo "Done."
