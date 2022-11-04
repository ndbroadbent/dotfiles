tell application "System Events" to tell process "Code"
	set frontmost to true
	keystroke "e" using {shift down, command down}
	keystroke "p" using {shift down, command down} -- Open Command Palette
	keystroke "collapse folders"
	key code 36 -- Send enter to execute command
	-- Cmd+K Cmd+W to close all editor tabs
	keystroke "k" using {command down}
	keystroke "w" using {command down}
end tell
