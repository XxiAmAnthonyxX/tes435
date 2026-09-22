hl.curve("smooth", {
	type = "bezier",
	points = {
		{ 0.22, 1.0 },
		{ 0.36, 1.0 },
	},
})

local function anim(leaf, speed, style)
	hl.animation({
		leaf = leaf,
		enabled = true,
		speed = speed,
		bezier = "smooth",
		style = style,
	})
end

-- Global
anim("global", 7)

-- Windows
anim("windows", 8, "slide")
anim("windowsIn", 8, "slide")
anim("windowsOut", 6, "slide")
anim("windowsMove", 5)

-- Layers
anim("layers", 5, "fade")
anim("layersIn", 5)
anim("layersOut", 4)

-- General fades
anim("fade", 6)
anim("fadeIn", 5)
anim("fadeOut", 5)
anim("fadeSwitch", 4)
anim("fadeShadow", 5)
anim("fadeGlow", 5)
anim("fadeDim", 5)

-- Layer fades
anim("fadeLayers", 5)
anim("fadeLayersIn", 5)
anim("fadeLayersOut", 4)

-- Popup fades
anim("fadePopups", 4)
anim("fadePopupsIn", 4)
anim("fadePopupsOut", 4)
anim("fadeDpms", 5)

-- Borders
-- anim("border", 7)
-- anim("borderangle", 12)
-- anim("shadowangle", 4)
-- anim("glowangle", 4)

-- Workspaces
anim("workspaces", 7, "slidevert")
anim("workspacesIn", 5, "slidevert")
anim("workspacesOut", 5, "slidevert")
-- anim("specialWorkspace", 5)
-- anim("specialWorkspaceIn", 5)
-- anim("specialWorkspaceOut", 5)

-- Misc
-- anim("zoomFactor", 5)
-- anim("monitorAdded", 5)
