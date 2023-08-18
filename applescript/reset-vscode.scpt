tell application "System Events" to tell process "Code"
	set frontmost to true
	-- Scroll up to first file
	keystroke "p" using {shift down, command down} -- Open Command Palette
	keystroke "Focus on Folders"
	key code 36 -- Enter
	key code 115 -- Home

	keystroke "p" using {shift down, command down} -- Open Command Palette
	keystroke "collapse folders"
	key code 36 -- Send enter to execute command
	-- Cmd+K Cmd+W to close all editor tabs
	keystroke "k" using {command down}
	keystroke "w" using {command down}
end tell
