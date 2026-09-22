local colors = require("theme-hyprland")

hl.config({
	general = {
		border_size = 3,
		gaps_in = 5,
		gaps_out = 15,

		col = {
			active_border = {
				colors = {
					"rgb(" .. colors.color11:sub(2) .. ")",
					"rgb(" .. colors.color13:sub(2) .. ")",
				},
				angle = 45,
			},

			inactive_border = {
				colors = {
					"rgb(" .. colors.color11:sub(2) .. ")",
					"rgb(" .. colors.color13:sub(2) .. ")",
				},
				angle = 45,
			},
		},

		layout = "scrolling",
	},
})
