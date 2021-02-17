local hyper = 

hs.loadSpoon("EWM")

hs.window.animationDuration = 0
spoon.EWM:bindHotkeys(
	{"ctrl", "alt", "cmd"},  -- hyper
	{
	  X = {"pad1", "pad2", "pad3"},
	  Y = {"pad4", "pad5", "pad6"},
	  GRID = {{'u', 'i', 'o'}, -- [Y][X]
			  {'j', 'k', 'l'},
			  {'m', ',', '.'}},
	  fullScreen = "f",
	  streamCorner = "w",
	  screenEast = "pageup",
	  screenWest = "pagedown"
	})

hs.loadSpoon("Seal")
