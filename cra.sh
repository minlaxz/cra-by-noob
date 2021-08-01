#! /bin/env bash

HEAD='\e[7;36m'
RESET='\e[m'
OUTPUT='\e[32m'
NL='\n'
ERROR='\e[3;31m'
WARN='\e[3;33m'

function oneLineOutput() {
    line=$1
    echo -e "${OUTPUT}$line${RESET}"
}

function descriptionOutput() {
    line=$1
    echo -e "${WARN}Description : $line ${RESET}"
}

function warningOutput() {
    line=$1
    echo -e "${ERROR}Warning : $line ${RESET}"
}

function hasSudo() {
    dpkg-query -l sudo >/dev/null 2>&1
    return $?
}

function hasUnzip() {
    dpkg-query -l unzip >/dev/null 2>&1
    return $?
}

function hasCurl() {
    dpkg-query -l curl >/dev/null 2>&1
    return $?
}

# MAKE PROJECT
read -p "Enter your project name : " projectName
read -p "Version [0.0.0] : " projectVersion
if [ -z "$projectVersion" ]; then
    version="0.0.0"
else
    version="$projectVersion"
fi

if [ -d $projectName ]; then
    echo "Project '$projectName' already exists"
    exit 1
fi

mkdir -p $projectName   

# Download bootstrapped files
hasUnzip && hasCurl
if [[ $? -eq 0 ]]; then
    descriptionOutput "All needed depedencies're already installed, y're good to go."
else
    hasSudo
    if [[ $? -eq 0 ]]; then
        warningOutput "this need 'unzip, curl'\nAnd are going to installed."
        # read -n 1 -s -r -p "Press any key to continue ..."
        read -p "Press enter to continue [CTRL-C to cancle] ... "
        sudo apt-get install unzip curl
    else
        warningOutput "this need 'sudo, unzip, curl'"
    fi
fi

curl -L https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.tar.xz | tar xvfJ - -C $projectName/ && cd $projectName

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
