hyper       = {"cmd","alt","ctrl"}
shift_hyper = {"cmd","alt","ctrl","shift"}
ctrl_cmd    = {"cmd","ctrl"}

hs.loadSpoon("SpoonInstall")
Install=spoon.SpoonInstall
hs.loadSpoon("EWM")

hs.window.animationDuration = 0
spoon.EWM:bindHotkeys(
	hyper,  -- hyper
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


Install:andUse("Seal",
               {
                 hotkeys = { show = { {"cmd"}, "space" } },
                 fn = function(s)
                   s:loadPlugins({"apps", "calc", "pasteboard",
                                  "screencapture", "useractions"})
                   --- s.plugins.safari_bookmarks.always_open_with_safari = false
                   s.plugins.useractions.actions = {}
                   s:refreshAllCommands()
                 end,
                 start = true,
               }
)
