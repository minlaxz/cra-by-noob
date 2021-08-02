#! /bin/sh
set -e
set -o noglob

# curl -fsSL https://getcra.minlaxz.me | sh -s -- -i // to install cra

HEAD='\e[7;36m'
RESET='\e[m'
OUTPUT='\e[32m'
NL='\n'
ERROR='\e[3;31m'
WARN='\e[3;33m'

oneLineOutput() {
    line=$1
    echo "${OUTPUT}$line${RESET}"
}

descriptionOutput() {
    line=$1
    echo "${WARN}Description : $line ${RESET}"
}

warningOutput() {
    line=$1
    echo "${ERROR}Warning : $line ${RESET}"
}

setup_laxzhome() {
    LAXZHOME=$HOME/.laxz
    mkdir -p $LAXZHOME
    if [ ! -f $LAXZHOME/.laxzrc ]; then
        touch $LAXZHOME/.laxzrc
    fi
}

remove_cra() {
    if [ -f $LAXZHOME/cra.sh ]; then
        warningOutput "CHECK - found cra, removing..."
        rm $LAXZHOME/cra.sh
    fi
    descriptionOutput "DONE - removed cra."
}

download_cra() {
    curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh -o $LAXZHOME/cra.sh
    chmod 755 $LAXZHOME/cra.sh
    descriptionOutput "DONE - downloaded cra."
}

finish_up() {
    oneLineOutput "REMOVING laxzrc from zshrc"
    sed -i '/source $HOME\/\.laxz\/\.laxzrc/d' $HOME/.zshrc
    oneLineOutput "Adding laxzrc to zshrc"
    echo "source $HOME/.laxz/.laxzrc" >>$HOME/.zshrc
    oneLineOutput "ya're good to go!\nJus run 'cra'"
}

# this should be called only after setup_laxzhome
update_rc() {
    if [ -f $LAXZHOME/cra.sh ]; then
        # cra exists
        sed -i '/alias cra/d' $LAXZHOME/.laxzrc # clean alias about cra in laxzrc
        cat <<EOF >>$LAXZHOME/.laxzrc
alias cra="$HOME/.laxz/cra.sh"
EOF
        oneLineOutput "cra is added to laxzrc"
    else
        sed -i '/alias cra/d' $LAXZHOME/.laxzrc # clean alias about cra in laxzrc
        oneLineOutput "cra is removed from laxzrc"
    fi
}

main() {
    echo "run with option : $1"
    case "$1" in
    "" | "-i")
        oneLineOutput "Installing CRA."
        setup_laxzhome
        remove_cra
        download_cra
        update_rc
        finish_up
        ;;
    "-r")
        oneLineOutput "Removing CRA."
        setup_laxzhome
        remove_cra
        update_rc
        ;;
    esac

}

main "$@"
