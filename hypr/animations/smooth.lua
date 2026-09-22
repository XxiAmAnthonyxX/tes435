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
anim("global", 9)

-- Windows
anim("windows", 10, "slide")
anim("windowsIn", 9, "slide")
anim("windowsOut", 8, "slide")
anim("windowsMove", 7)

-- Layers
anim("layers", 7, "fade")
anim("layersIn", 6, "fade")
anim("layersOut", 6, "fade")

-- General fades
anim("fade", 7)
anim("fadeIn", 6)
anim("fadeOut", 6)
anim("fadeSwitch", 5)
anim("fadeShadow", 6)
anim("fadeGlow", 6)
anim("fadeDim", 6)

-- Layer fades
anim("fadeLayers", 6)
anim("fadeLayersIn", 6)
anim("fadeLayersOut", 6)

-- Popup fades
anim("fadePopups", 5)
anim("fadePopupsIn", 5)
anim("fadePopupsOut", 5)
anim("fadeDpms", 6)

-- Borders
-- anim("border", 9)
-- anim("borderangle", 16)
-- anim("shadowangle", 6)
-- anim("glowangle", 6)

-- Workspaces
anim("workspaces", 10, "fade")
anim("workspacesIn", 7, "fade")
anim("workspacesOut", 7, "fade")
-- anim("specialWorkspace", 7)
-- anim("specialWorkspaceIn", 7)
-- anim("specialWorkspaceOut", 7)

-- Misc
-- anim("zoomFactor", 6)
-- anim("monitorAdded", 6)
