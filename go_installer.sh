#!/bin/bash

#Version to be installed
GO_VERSION="1.17.2"

currentver="$(go version | grep -Po "(?<=go)[0-9\.]*(?= )")"
#Min version required.
requiredver="1.14.4"
installation_directory="/usr/local"

checkVersion() {
    if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then 
            echo "Go version is greater than or equal to ${requiredver}"
            verStatus="gte"
    else
            echo "Go version is less than ${requiredver}, which is the minimum required version. Uninstall it and rerun this program"
            verStatus="lt"
    fi
}

FILE="go${GO_VERSION}.linux-amd64.tar.gz";
installGo() {
    echo "Installing Go version ${GO_VERSION} on this machine."
    if [ -f "$FILE" ]
        then
            echo "Installation file $FILE exists."
        else
            echo "$file does not exist. Downloading."
            wget https://storage.googleapis.com/golang/$FILE
            wget_result = $?
            if [ wget_result -ne 0 ]; then
                echo "Failed to download Go. Check your internet connection and try again."
                exit 1
            fi
    fi
    echo "Extracting installation file to ${installation_directory}"
    tar -zxvf $FILE -C $installation_directory
    echo "Removing downloaded file: ${FILE}"
    rm $FILE    
    export GOROOT="${installation_directory}"/go/
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin    
        if ! command -v go &>/dev/null
            then
                echo "Go was not installed correctly."
                exit 2
            else
                echo "Go was successfully installed!"
                echo "If for some reason you can't use Go, please run 'source ~/.bashrc' and try again."                
        fi
}

#Main routine
if ! command -v go &>/dev/null
    then
        echo "Go could not be found"
        installGo
        echo "export GOROOT=${installation_directory}/go/" >> ~/.bashrc
        echo "export GOPATH=$HOME/go" >> ~/.bashrc
        echo "export PATH=$PATH:$GOROOT/bin:$GOPATH/bin" >> ~/.bashrc
        export GOROOT="${installation_directory}"/go/
        export GOPATH=$HOME/go
        export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
    else
        verStatus=checkVersion
        if [ verStatus="gte" ]
            then
                echo "Go version satisfies minimum requirements."
                echo "Go is already installed in this machine."
                go version
            else
                echo "Current go version is less then the minimum requirement."
                echo "Please uninstall and rerun 'make install-go'"
                exit 3
        fi        
fi

exit 0
