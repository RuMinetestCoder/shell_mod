shell_mod = {}
local history = {}

-- INITLIB
local S, NS
if minetest.global_exists('intllib') then
    S, NS = intllib.make_gettext_pair(minetest.get_current_modname())
else
    S = function(s) return s end
    NS = S
end

-- LOCAL FUNCTIONS
local function get_shell(player_name, old, cmd)
    local str = 'size[20.25,9]textlist[0,0;20,8;shell_mod:box;'
    local len = 0
    if old then
        for _, line in ipairs(old) do
            str = str .. line .. ','
            len = len + 1
        end
    end
    if cmd then
        local log_cmd = player_name .. ': ' .. cmd
        local date = minetest.formspec_escape(os.date('[%Y-%m-%d %X]: '))
        table.insert(history, date .. log_cmd)
        str = str .. date .. log_cmd .. ','
        minetest.log('warning', '[shell_mod] command: ' .. log_cmd)
        len = len + 1
        local handler = io.popen(cmd)
        for line in handler:lines() do
            line = minetest.formspec_escape(line)
            str = str .. date .. line .. ','
            table.insert(history, date .. line)
            minetest.log('warning', '[shell_mod] out: ' .. line)
            len = len + 1
        end
        handler:close()
    end
    str = str .. ';' .. tostring(len) .. ']field[0.30,8.3;17,1;shell_mod:cmd;;]button[17.25,8;3,1;shell_mod:go;' .. S('Go') .. ']'
    return str
end

-- API
function shell_mod.open_shell(player_name, old, cmd)
    minetest.show_formspec(player_name, 'shell_mod', get_shell(player_name, old, cmd))
end

function shell_mod.get_history()
    return history
end

function shell_mod.clear_history()
    history = {}
end

-- EVENTS
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname == 'shell_mod' and fields['shell_mod:cmd'] then
        shell_mod.open_shell(player:get_player_name(), history, fields['shell_mod:cmd'])
    end
end)

-- REGISTRATIONS
minetest.register_privilege('shell_cmd', S('Can use /shell'))
minetest.register_privilege('shell_clear', S('Can use /shell-clear'))

-- COMMANDS
minetest.register_chatcommand('shell', {
	params = 'none',
	description = S('open shell window'),
	privs = {shell_cmd = true},
	func = function(name)
		shell_mod.open_shell(name, history, nil)
		return true
	end,
})

minetest.register_chatcommand('shell-clear', {
	params = 'none',
	description = S('clear shell history'),
	privs = {shell_clear = true},
	func = function(name)
		history = {}
		return true, S('shell history cleared')
	end,
})
