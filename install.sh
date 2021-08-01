#! /bin/sh
set -e
set -o noglob

LAXZHOME=$HOME/.laxz
mkdir -p $LAXZHOME
curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh -o $LAXZHOME/cra.sh
chmod 755 $HOME/cra.sh
cat<<EOF >>$LAXZHOME/.laxzrc
alias cra="$HOME/.laxz/cra.sh"
EOF
echo "source $HOME/.laxz/.laxzrc" >> $HOME/.zshrc
source $HOME/.zshrc
