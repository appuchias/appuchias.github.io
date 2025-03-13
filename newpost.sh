#/bin/sh

lang=$1
name=$2

year=$(date "+%Y")

if [[ -z "$lang" || -z "$name" ]]; then
    echo "Usage: $0 <lang> <name>"
    exit 1
fi

hugo new content -k $lang --clock $(date -I)T00:00:00+01:00 "posts/$year/$name.md"
