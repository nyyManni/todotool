# ToDoTool
## Usage:
        todo [command] [arguments]...

## Commands:
  - list [regex]          
    - Lists todo items (default command), filter with regex.
      Multiple search terms supported, empty lists all items.
  - add [task] [deadline] 
    - Add new item to todo list.
  - remove [regex]        
    - Remove a todo item matching a regex.
      A backup is created automatically.
  - restore               
    - Restores latest backup created by remove.
  - done [regex]          
    - Mark all matching items done.
  - undone [regex]        
    - Mark all matching items todo.
  - help                  
    - Prints this message.

## Notes: 
- A space in a regex argument is converted into '.*', so there is no way to match a literal space. 
This makes it possible to filter results by providing several arguments.
- Regexes are case-insensitive.
- Date format is yyyy-mm-dd hh:mm. Don't put quotes around date, give it as two separate arguments.
