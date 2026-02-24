local hs = hs

-- App switchers
local function app(name)
  return function() hs.application.launchOrFocus(name) end
end

local function jump(browserName, url)
  return function()
    hs.application.launchOrFocus(browserName)
    local script = (
      [[(function() {
           var browser = Application('%s');
           browser.activate();

           for (win of browser.windows()) {
             var tabIndex = win.tabs().findIndex(function(tab) {
              return tab.url().indexOf('%s') !== -1;
             });

             if (tabIndex != -1) {
               win.activeTabIndex = (tabIndex + 1);
               win.index = 1;
             }
           }
         })();]]
    ):format(browserName, url)
    hs.osascript.javascript(script)
  end
end


hs.hotkey.bind({"ctrl", "cmd"}, "A", app("Alacritty"))
hs.hotkey.bind({"ctrl", "cmd"}, "D", app("Google Chrome"))
hs.hotkey.bind({"ctrl", "cmd"}, "I", app("IntelliJ IDEA Community Edition"))
hs.hotkey.bind({"ctrl", "cmd"}, "M", app("Anki"))
hs.hotkey.bind(
  {"ctrl", "cmd"},
  "C",
  jump("Google Chrome", "https://chatgpt.com/")
)
hs.hotkey.bind(
  {"ctrl", "cmd"},
  "S",
  jump("Google Chrome", "https://app.slack.com/")
)


-- Window management (MiroWindowsManager)
hs.window.animationDuration = 0
hs.loadSpoon("MiroWindowsManager")
local spoon = spoon
spoon.MiroWindowsManager.sizes = { 2, 3, 3 / 2 }
spoon.MiroWindowsManager.fullScreenSizes = { 1, 4 / 3, 2 }
spoon.MiroWindowsManager:bindHotkeys({
  fullscreen = {{"ctrl", "cmd"}, "up"},
  right = {{"ctrl", "cmd"}, "right"},
  left = {{"ctrl", "cmd"}, "left"},
})


hs.alert.show("Hammerspoon config loaded")
