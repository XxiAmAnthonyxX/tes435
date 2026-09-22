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
anim("global", 5)

-- Windows
anim("windows", 6, "slide")
anim("windowsIn", 6, "slide")
anim("windowsOut", 5, "slide")
anim("windowsMove", 4)

-- Layers
anim("layers", 4, "fade")
anim("layersIn", 4)
anim("layersOut", 3)

-- General fades
anim("fade", 4)
anim("fadeIn", 4)
anim("fadeOut", 4)
anim("fadeSwitch", 3)
anim("fadeShadow", 4)
anim("fadeGlow", 4)
anim("fadeDim", 4)

-- Layer fades
anim("fadeLayers", 4)
anim("fadeLayersIn", 4)
anim("fadeLayersOut", 3)

-- Popup fades
anim("fadePopups", 3)
anim("fadePopupsIn", 3)
anim("fadePopupsOut", 3)
anim("fadeDpms", 4)

-- Borders
-- anim("border", 5)
-- anim("borderangle", 8)
-- anim("shadowangle", 3)
-- anim("glowangle", 3)

-- Workspaces
anim("workspaces", 6, "slidevert")
anim("workspacesIn", 4, "slidevert")
anim("workspacesOut", 4, "slidevert")
-- anim("specialWorkspace", 4)
-- anim("specialWorkspaceIn", 4)
-- anim("specialWorkspaceOut", 4)

-- Misc
-- anim("zoomFactor", 4)
-- anim("monitorAdded", 4)
