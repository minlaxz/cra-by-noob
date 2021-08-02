#!/usr/bin/env bash
set -e
set -o noglob

HEAD='\e[7;36m'
RESET='\e[m'
OUTPUT='\e[32m'
NL='\n'
ERROR='\e[3;31m'
WARN='\e[3;33m'

oneLineOutput() {
    line=$1
    echo -e "${OUTPUT}$line${RESET}"
}

descriptionOutput() {
    line=$1
    echo -e "${WARN}Description : $line ${RESET}"
}

warningOutput() {
    line=$1
    echo -e "${ERROR}Warning : $line ${RESET}"
}

hasSudo() {
    dpkg-query -l sudo >/dev/null 2>&1
    return $?
}

hasUnzip() {
    dpkg-query -l unzip >/dev/null 2>&1
    return $?
}

hasCurl() {
    dpkg-query -l curl >/dev/null 2>&1
    return $?
}

# MAKE PROJECT
make_project() {
    # Already define a project name
    projectName=$1

    if [[ -z $projectName ]]; then
        read -p "Enter your project name : " projectName
        if [[ -z $projectName ]]; then
            warningOutput "You cannot start a project without a name!"
            exit 1
        else
            descriptionOutput "Checking project already exists..."
            if [[ -d $projectName ]]; then
                warningOutput "'$projectName' already exists at $(pwd)/$projectName"
                exit 1
            else
                oneLineOutput "DIR CHECK PASS"
            fi
        fi
    fi
    oneLineOutput "Lazyyy ones, we are gonna create \033[33mreact app\033[39m without node_modules!\nHere > $(pwd)/$projectName"
    read -p "Version default [0.0.0] : " projectVersion
    if [[ -z "$projectVersion" ]]; then
        version="0.0.0"
    else
        version="$projectVersion"
    fi
}

check_libs() {
    hasUnzip && hasCurl
    if [[ $? -eq 0 ]]; then
        descriptionOutput "All needed depedencies're already installed, y're good to go."
        read -p "Press enter to continue [CTRL-C to cancle] ... "
        oneLineOutput "Please weed :c ... "
    else
        hasSudo
        if [[ $? -eq 0 ]]; then
            warningOutput "this need 'unzip, curl'\nAnd are going to installed."
            # read -n 1 -s -r -p "Press any key to continue ..."
            read -p "Press enter to continue [CTRL-C to cancle] ... "
            sudo apt-get install unzip curl
        else
            warningOutput "this need 'sudo, unzip, curl'"
            exit 1
        fi
    fi
}

create_project() {
    mkdir -p $projectName
    descriptionOutput "Creating package.json ..."
    cat <<EOF >>package.json
{
  "name": "$projectName",
  "version": "$version",
  "private": true,
  "dependencies": {
    "@testing-library/jest-dom": "^5.11.4",
    "@testing-library/react": "^11.1.0",
    "@testing-library/user-event": "^12.1.10",
    "react": "^17.0.2",
    "react-dom": "^17.0.2",
    "react-scripts": "4.0.3",
    "web-vitals": "^1.0.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test",
    "eject": "react-scripts eject"
  },
  "eslintConfig": {
    "extends": [
      "react-app",
      "react-app/jest"
    ]
  },
  "browserslist": {
    "production": [
      ">0.2%",
      "not dead",
      "not op_mini all"
    ],
    "development": [
      "last 1 chrome version",
      "last 1 firefox version",
      "last 1 safari version"
    ]
  }
}
EOF
    oneLineOutput "DONE - created package.json"
}

# Download bootstrapped files
download_bootstrapped_files() {
    descriptionOutput "Getting latest tarball list..."
    tarballVersion=$(curl -s https://api.github.com/repos/minlaxz/cra-by-noob/releases/latest | grep "browser_download_url.*tar.xz" | cut -d : -f 2,3 | tr -d \" | xargs)
    descriptionOutput "Downloading bootstrapped tarball..."
    curl -fsSL $tarballVersion | tar xfJ - -C $projectName/ && cd $projectName
    # curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.tar.xz | tar xfJ - -C $projectName/ && cd $projectName
    oneLineOutput "DONE - tarball is extracted."
}

download_cra() {
    descriptionOutput "Downloading latest version of cra..."
    curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh -o $LAXZHOME/cra.sh
    chmod 755 $LAXZHOME/cra.sh
    oneLineOutput "DONE - cra is downloaded."
    check_update
}

check_remote_sha() {
    descriptionOutput "Checking for update from remote..."
    remote_checksum=$(curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh | sha256sum | awk '{print $1}' | cut -c -12)
    oneLineOutput "DONE - Remote Checksum : $remote_checksum"
}

check_local_sha() {
    # For multile shell files
    # local_checksum=$(find $LAXZHOME -maxdepth 2 -name "*.sh" -print0 | xargs -0 sha1sum | sort -h | sha256sum | awk '{print $1}')
    local_checksum=$(cat $LAXZHOME/cra.sh | sha256sum | awk '{print $1}' | cut -c -12)
    oneLineOutput "DONE - Local  Checksum : $local_checksum"
}

check_update() {
    check_remote_sha
    check_local_sha
    if [ "$remote_checksum" != "$local_checksum" ]; then
        isCraOutdated=1
    else
        isCraOutdated=0
        oneLineOutput "Cra is at latest version $local_checksum :v ."
    fi
}

# Remove CRA
remove_cra() {
    if [[ -f $LAXZHOME/cra.sh ]]; then
        rm -rf $LAXZHOME/cra.sh
        if [[ -f $LAXZHOME/.laxzrc ]]; then
            sed -i '/alias cra/d' $LAXZHOME/.laxzrc # clean alias about cra in laxzrc
            oneLineOutput "cra is removed from laxzrc"
        else
            warningOutput ".laxzrc is not found to remove alias cra."
        fi
    else
        warningOutput "Seems to be cra is installed at other locations.\nPlease remove it manually. $(which cra)"
    fi
}

# --- running process --

# {
#     make_project "$@"
#     check_libs
#     create_project
#     download_bootstrapped_files
# }

# test "${VAR}" -eq 1 && action || true
main() {
    LAXZHOME=$HOME/.laxz

    case $1 in
    "-h" | "--help")
        oneLineOutput "-n --new      Create new lite-react project."
        cat <<EOF >&1
    Example : 
        cra
        cra -n <projectname>
        cra --name <projectname>
EOF
        oneLineOutput "-u --update   Check for cra update."
        cat <<EOF >&1
    Example :
        cra -u
        cra --update
EOF
        ;;

    "-n" | "--new" | "")
        make_project "$2"
        check_libs
        create_project
        download_bootstrapped_files
        ;;
    "-u" | "--update")
        check_update
        if [ $isCraOutdated -eq 1 ]; then
            read -p "New version found, press Enter to continue ... "
            download_cra
        fi
        ;;
    "-r" | "--remove")
        remove_cra
        ;;
    *)
        descriptionOutput "unrecognized '$1', -h for help."
        ;;
    esac

}

main "$@"
