hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent")

	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("wl-paste --type text  --watch cliphist store")
	hl.exec_cmd("wl-paste --type image --watch cliphist store")

	hl.exec_cmd("hyprpm reload")

	hl.exec_cmd("udiskie")
	hl.exec_cmd("~/.config/hypr/scripts/theme/apply/random.sh")
	hl.exec_cmd("waybar")
end)
