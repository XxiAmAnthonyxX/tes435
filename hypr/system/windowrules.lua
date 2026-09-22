hl.window_rule({ match = { class = "^(mpv$" }, fullscreen = true })

hl.window_rule({ match = { class = "^(imv|kitty)$" }, float = true, size = "1000 500" })

hl.window_rule({
	match = { class = "^(librewolf|mpv|imv|steam|kitty)$" },
	opacity = "1.0 override 1.0 override 1.0 override",
})
