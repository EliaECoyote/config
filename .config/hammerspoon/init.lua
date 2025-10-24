local hs = hs

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


hs.hotkey.bind({ "ctrl", "cmd" }, "A", app("Alacritty"))
hs.hotkey.bind({ "ctrl", "cmd" }, "D", app("Google Chrome"))
hs.hotkey.bind({ "ctrl", "cmd" }, "I", app("IntelliJ IDEA Community Edition"))
hs.hotkey.bind(
  { "ctrl", "cmd" },
  "C",
  jump("Google Chrome", "https://chatgpt.com/")
)
hs.hotkey.bind(
  { "ctrl", "cmd" },
  "S",
  jump("Google Chrome", "https://app.slack.com/")
)


hs.alert.show("Hammerspoon config loaded")
