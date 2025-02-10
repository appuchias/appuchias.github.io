#/bin/sh

lang=$1
name=$2

year=$(date "+%Y")

if [[ -z "$lang" || -z "$name" ]]; then
    echo "Usage: $0 <lang> <name>"
    exit 1
fi

hugo new content "$lang/$year/$name.md"
