#!/bin/bash

# Determine the installation directory
INSTALL_DIR="$HOME/.phpvm"


# # Create the directory if it doesn't exist
# mkdir -p "$INSTALL_DIR"

# # Copy the phpvm.sh script to the installation directory
# cp phpvm.sh "$INSTALL_DIR/phpvm.sh"

# # Ensure the script is executable
# chmod +x "$INSTALL_DIR/phpvm.sh"

# Clone the repository and install
git clone git@github.com:meer-sagor/phpvm.git "$INSTALL_DIR" && cd "$INSTALL_DIR" && chmod +x phpvm.sh install_phpvm.sh && ./install_phpvm.sh

# Add the installation directory to the PATH in the user's shell profile
if ! grep -q 'export PATH="$HOME/.phpvm:$PATH"' "$HOME/.bashrc"; then
    echo 'export PATH="$HOME/.phpvm:$PATH"' >> "$HOME/.bashrc"
    echo 'alias phpvm="$HOME/.phpvm/phpvm.sh"' >> "$HOME/.bashrc"
fi

if ! grep -q 'export PATH="$HOME/.phpvm:$PATH"' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.phpvm:$PATH"' >> "$HOME/.zshrc"
    echo 'alias phpvm="$HOME/.phpvm/phpvm.sh"' >> "$HOME/.zshrc"
fi

echo "PHPVM installed. Please restart your terminal or run 'source ~/.bashrc' or 'source ~/.zshrc' to start using it."

