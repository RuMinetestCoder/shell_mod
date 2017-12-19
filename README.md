# shell_mod

This mod add game terminal for execute shell commands. Please, use *screen* or other utility for long execute.

**WARNING! This mod creates a potential backdoor! Do not give users of privileges for this mod!**

## Commands and privs

* **/shell** - open terminal window (need *shell_cmd* priv)
* **/shell-clear** - clear terminal history (need *shell_clear* priv)

## Depends

* initlib?

## API

* **shell_mod.open_shell(player_name, old, cmd)** - open terminal window. *old* - array (history), *cmd* - command for execute (string). *old* and *cmd* is optionally.
* **shell_mod.get_history()** - get terminal history, return array
* **shell_mod.clear_history()** - clear history
