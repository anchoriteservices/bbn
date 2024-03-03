#!/bin/bash -e
substAndInstall() {
    file=$1
    dest=$2
    perms=$3

    TMP_FILE=$(mktemp -q .temp.XXXXXX || exit 1)
    
    # Set trap to clean up file
    trap 'rm -f -- "$TMP_FILE"' EXIT
    
    envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < "$file" > "$TMP_FILE"

    if [ "$perms" = "" ]; then
        install -v "$TMP_FILE" "$dest"
    else
        install -v -m $perms "$TMP_FILE" "$dest"
    fi

    #cat "$TMP_FILE"

    rm -f -- "$TMP_FILE"
    trap - EXIT
}

substAndInstallUserGroup() {
    file=$1
    dest=$2
    o=$3
    g=$4
    perms=$5

    TMP_FILE=$(mktemp -q .temp.XXXXXX || exit 1)
    
    # Set trap to clean up file
    trap 'rm -f -- "$TMP_FILE"' EXIT
    
    envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < "$file" > "$TMP_FILE"
    
    if [ "$perms" = "" ]; then
        install -v -o $o -g $g "$TMP_FILE" "$dest"
    else
        install -v -o $o -g $g -m $perms "$TMP_FILE" "$dest"
    fi

    #cat "$TMP_FILE"

    rm -f -- "$TMP_FILE"
    trap - EXIT
}

substAndAppend() {
    file=$1
    dest=$2

    TMP_FILE=$(mktemp -q .temp.XXXXXX || exit 1)
    
    # Set trap to clean up file
    trap 'rm -f -- "$TMP_FILE"' EXIT
    
    envsubst "$(env | sed -e 's/=.*//' -e 's/^/\$/g')" < "$file" > "$TMP_FILE"
    cat "$TMP_FILE" >> "$dest"

    #cat "$TMP_FILE"

    rm -f -- "$TMP_FILE"
    trap - EXIT
}
