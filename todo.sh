#!/usr/bin/env bash


DB_FILE="$HOME/.todo/todo.csv"
mkdir -p "$(dirname "$DB_FILE")"
touch "$DB_FILE"

add() {
    task="$1"
    deadline="$2 $3"

    # Date format yyyy-mm-dd hh:mm
    [[ "$deadline" =~ 201[5-9]-[01][0-9]-[0-3][0-9]\ [0-2][0-9]:[0-5][0-9] ]] || {
        echo "Incorrect date format! (yyyy-mm-dd hh:mm)"
        exit 2
    }
    echo "$deadline|TODO|$task" >> "$DB_FILE"
    sort -o "$DB_FILE" "$DB_FILE"
}

replace() {
    sed -i -e /"$1"'/Is/'"$2"/"$3"/ "$DB_FILE"
}

mark_done() {
    target="${1// /.*}"
    replace "$target" '|TODO|' '|DONE|'
}

mark_undone() {
    target="${1// /.*}"
    replace "$target" '|DONE|' '|TODO|'
}

remove() {
    target="$1"
    sed -i -e /"$target"'/Id' "$DB_FILE"
}

list() {
    target="${1// /.*}"
    [ "$target" != "" ] || target=".*"
    sed -n -e /"$target"'/Ip' "$DB_FILE" |

        # Ugly piece of code, provides colored output
        awk -F '|' '{printf "%s  ", $1}/TODO/{printf "\033[31m"}/DONE/{printf "\033[32m"}{printf "%s\033[0m\t%s\n", $2, $3}'

}

usage() {
    cat <<EOF

Usage: todo [command] [arguments]...

Commands:
  list [regex]          - Lists todo items (default command), filter with regex.
                          Multiple search terms supported, empty lists all items.
  add [task] [deadline] - Add new item to todo list.
  remove [regex]        - Remove a todo item matching a regex.
                          A backup is created automatically.
  restore               - Restores latest backup created by remove.
  done [regex]          - Mark all matching items done.
  undone [regex]        - Mark all matching items todo.
  help                  - Prints this message.

  NOTES: 
      - A space in a regex argument is converted into '.*', so there is no way
        to match a literal space. This makes it possible to filter results by
        providing several arguments.
      - Regexes are case-insensitive.
      - Date format is yyyy-mm-dd hh:mm. Don't put quotes around date, give it
        as two separate arguments.
EOF
}

case "$1" in
    'add')
        shift
        add "$@"
        ;;
    'remove')
        cp "$DB_FILE" "$DB_FILE".bak
        shift
        remove "$*"
        ;;
    'restore')
        mv "$DB_FILE".bak "$DB_FILE" 2> /dev/null || {
            echo 'ERROR: No backup found'; exit 3
        }
        ;;
    'done')
        shift
        mark_done "$*"
        ;;
    'undone')
        shift
        mark_undone "$*"
        ;;
    'list'|'')
        shift
        list "$*"
        ;;
    'help')
        echo "ToDoTool by nyyManni"
        usage
        exit 0
        ;;
    *)
        echo "ERROR: Unknown command"
        usage
        exit 1
        ;;
esac
