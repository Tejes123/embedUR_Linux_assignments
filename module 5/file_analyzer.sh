#!/bin/bash

ERROR_LOG="errors.log"

show_help() {
cat << EOF
Usage: $0 [OPTIONS]

Options:
  -d <directory>   Directory to search recursively
  -f <file>        File to search directly
  -k <keyword>     Keyword to search for
  --help           Display this help menu

Examples:
  $0 -d logs -k error
  $0 -f script.sh -k TODO
  $0 --help
EOF
}

# Error handler

log_error() {
    echo "ERROR: $1" | tee -a "$ERROR_LOG" >&2
}

# Recursive function
recursive_search() {
    local dir="$1"
    local keyword="$2"

    for item in "$dir"/*; do
        if [[ -d "$item" ]]; then
            recursive_search "$item" "$keyword"
        elif [[ -f "$item" ]]; then
            grep -n "$keyword" "$item" 2>>"$ERROR_LOG"
        fi
    done
}

# Argument validation (Regex)
validate_inputs() {
    # Keyword must not be empty and only contain valid characters
    if [[ ! "$KEYWORD" =~ ^[a-zA-Z0-9_]+$ ]]; then
        log_error "Invalid keyword: '$KEYWORD'"
        exit 1
    fi

    if [[ -n "$DIRECTORY" && ! -d "$DIRECTORY" ]]; then
        log_error "Directory does not exist: $DIRECTORY"
        exit 1
    fi

    if [[ -n "$FILE" && ! -f "$FILE" ]]; then
        log_error "File does not exist: $FILE"
        exit 1
    fi
}

# Handle --help manually
if [[ "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# getopts (Command-line arguments)
while getopts ":d:f:k:" opt; do
    case "$opt" in
        d) DIRECTORY="$OPTARG" ;;
        f) FILE="$OPTARG" ;;
        k) KEYWORD="$OPTARG" ;;
        *)
            log_error "Invalid option used"
            show_help
            exit 1
            ;;
    esac
done

# Special parameters feedback
echo "Script Name     : $0"
echo "Total Arguments : $#"
echo "All Arguments   : $@"

# Mandatory keyword check
if [[ -z "$KEYWORD" ]]; then
    log_error "Keyword (-k) is mandatory"
    exit 1
fi

validate_inputs

# File search using Here String
if [[ -n "$FILE" ]]; then
    echo "Searching '$KEYWORD' in file: $FILE"
    grep -n "$KEYWORD" <<< "$(cat "$FILE")"
    echo "Exit status: $?"
fi

# Directory recursive search
if [[ -n "$DIRECTORY" ]]; then
    echo "Recursively searching '$KEYWORD' in directory: $DIRECTORY"
    recursive_search "$DIRECTORY" "$KEYWORD"
    echo "Exit status: $?"
fi
