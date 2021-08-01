#! /bin/sh
set -e
set -o noglob

LAXZHOME=$HOME/.laxz
mkdir -p $LAXZHOME
if [ -f $LAXZHOME/cra.sh ]; then
    rm $LAXZHOME/cra.sh
fi
curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh -o $LAXZHOME/cra.sh
chmod 755 $LAXZHOME/cra.sh
cat<<EOF >>$LAXZHOME/.laxzrc
alias cra="$HOME/.laxz/cra.sh"
EOF
echo "source $HOME/.laxz/.laxzrc" >> $HOME/.zshrc
source $HOME/.zshrc
