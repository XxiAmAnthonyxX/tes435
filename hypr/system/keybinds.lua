package.path = package.path .. ";./?.lua;./?/init.lua"
local smw = require("plugins.split-monitor-workspaces")

smw.setup({
	workspace_count = 5,
	monitor_priority = { "DP-1", "HDMI-A-1" },
	enable_persistent_workspaces = true,
	enable_wrapping = true,
	keep_focused = true,
})

-- MainMod
local winMod = "SUPER"

-- Kill
hl.bind(winMod .. " + ESCAPE", hl.dsp.window.close())

-- Focus
hl.bind(winMod .. " + A", hl.dsp.layout("focus l"))
hl.bind(winMod .. " + D", hl.dsp.layout("focus r"))
hl.bind(winMod .. " + S", hl.dsp.layout("focus d"))
hl.bind(winMod .. " + W", hl.dsp.layout("focus u"))

-- Swap / Move / Fit
hl.bind(winMod .. " + SHIFT + TAB", hl.dsp.window.float({ action = "toggle" }))
hl.bind(winMod .. " + SHIFT + SPACE", hl.dsp.layout("fit active"))
hl.bind(winMod .. " + SHIFT + A", hl.dsp.layout("swapcol l"))
hl.bind(winMod .. " + SHIFT + D", hl.dsp.layout("swapcol r"))
hl.bind(winMod .. " + SHIFT + S", hl.dsp.window.move({ direction = "down" }))
hl.bind(winMod .. " + SHIFT + W", hl.dsp.window.move({ direction = "up" }))

-- Windows
hl.bind(winMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(winMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(winMod .. " + CTRL + SPACE", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(winMod .. " + CTRL + A", hl.dsp.layout("promote"))
hl.bind(winMod .. " + CTRL + D", hl.dsp.layout("expel"))
hl.bind(winMod .. " + CTRL + S", hl.dsp.layout("consume"))
hl.bind(winMod .. " + CTRL + W", hl.dsp.layout("consume_or_expel next"))

-- Workspaces
for i = 1, smw.get_amount_of_workspaces() do
	local n = tostring(i)
	hl.bind(winMod .. " + " .. n, smw.workspace(n))
	hl.bind(winMod .. " + SHIFT + " .. n, smw.move_to_workspace(n))
	hl.bind(winMod .. " + CTRL + " .. n, smw.move_to_workspace_silent(n))
end

-- Personal
hl.bind(winMod .. " + Q", hl.dsp.exec_cmd("kitty"))
hl.bind(winMod .. " + Z", hl.dsp.exec_cmd("steam"))
hl.bind(winMod .. " + X", hl.dsp.exec_cmd("librewolf"))

hl.bind(winMod .. " + RETURN", hl.dsp.exec_cmd("kitty -e fish -i -c '~/.config/hypr/scripts/launcher.sh'"))
