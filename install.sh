#!/usr/bin/env sh

## print commands (debug mode)
if [ "$1" = "-v" ]; then
  set -x
fi

## Default install path in systemd file-hierarchy spec
INSTALL_DIR="$HOME/.local/bin"

## check and create directory
mkdir -p $INSTALL_DIR

## Verify if PATH contains $HOME/.local/bin and add it if not
if [[ ${PATH} != *"${HOME}/.local/bin"* ]]; then
	touch $HOME/.pam_environment
	echo "PATH DEFAULT=\${PATH}:/home/@{PAM_USER}/.local/bin" >> $HOME/.pam_environment
  echo "Relog and the rerun ./install.sh"
else
	## install python dependencies 
	uv sync

	## get the ementas script and set permissions
	scriptPath="$(cd "$(dirname "$0")" && pwd)"
	cat <<EOF > "$HOME/.local/bin/ementas"
#!/bin/sh
exec uv run --directory "$scriptPath" meals-ua.py
EOF

	chmod +x $HOME/.local/bin/ementas
fi
