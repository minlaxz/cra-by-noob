#! /bin/sh
set -e
set -o noglob

setup_laxzhome() {
    LAXZHOME=$HOME/.laxz
    mkdir -p $LAXZHOME
}

remove_cra() {
    if [ -f $LAXZHOME/cra.sh ]; then
        rm $LAXZHOME/cra.sh
    fi
}

download_cra() {
    curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh -o $LAXZHOME/cra.sh
    chmod 755 $LAXZHOME/cra.sh
}

finish_up() {
    cat <<EOF >>$LAXZHOME/.laxzrc
alias cra="$HOME/.laxz/cra.sh"
EOF
    echo "source $HOME/.laxz/.laxzrc" >>$HOME/.zshrc
    echo "Good to go!"
}

main() {
    echo "run with option : $1"
    case "$1" in
    "" | "-i")
        setup_laxzhome
        remove_cra
        download_cra
        finish_up
        ;;
    "-r")
        remove_cra
        ;;
    esac

}

main "$@"
