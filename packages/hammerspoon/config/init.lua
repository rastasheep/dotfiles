hs.window.animationDuration = 0

hs.alert.defaultStyle.textColor = {white = 1}
hs.alert.defaultStyle.fillColor = {black = 1, alpha = 0.5}
hs.alert.defaultStyle.strokeColor = {white = 1}
hs.alert.defaultStyle.strokeWidth = 4
hs.alert.defaultStyle.radius = 16
hs.alert.defaultStyle.textSize = 16
hs.alert.defaultStyle.padding = 8

require("leaderflow"):init({
    hyper_mods = {"cmd", "alt", "ctrl", "shift"},

    -- Multiple leader key mappings
    leaders = {
        -- Hyper+A for Apps
        a = {
            label = "Apps",
            t = "Terminal",
            v = "Visual Studio Code",
            c = "Google Chrome",
            f = "Finder",
            s = "Slack",
            n = "Notion",
            z = "Zoom",
        },

        -- Hyper+D for Development
        d = {
            label = "Dev",
            g = {
                label = "GitHub",
                g = "https://github.com",
                m = "https://github.com/rastasheep",
                d = "https://github.com/rastasheep/dotfiles",
                r = {
                    label = "[repos]",
                    d = "https://github.com/rastasheep/dotfiles",
                    n = "https://github.com/rastasheep/notebook",
                    p = "https://github.com/rastasheep/projects",
                }
            },
            v = {"Visual Studio Code", "VS Code"},
            t = "Terminal",
            c = "cmd:code .",
            r = "cmd:code ~/src",
            n = "https://npmjs.com",
        },

        -- Hyper+L for Links
        l = {
            label = "Links",
            g = "https://google.com",
            h = "https://github.com",
            t = "https://twitter.com",
            r = "https://reddit.com",
            n = "https://news.ycombinator.com",
            y = "https://youtube.com",
            m = "https://gmail.com",
        },

        -- Hyper+W for Window management
        w = {
            label = "Window",
            h = "window:left-half",
            l = "window:right-half",
            j = "window:bottom-half",
            k = "window:top-half",
            f = "window:maximize",
            c = "window:center",
        },

        -- Hyper+S for System
        s = {
            label = "System",
            l = "cmd:pmset displaysleepnow",
            r = "cmd:sudo shutdown -r now",
            s = "cmd:sudo shutdown -h now",
            v = "cmd:open /System/Library/PreferencePanes/SharingPref.prefPane",
        },

        -- Hyper+T for Text snippets
        t = {
            label = "Text",
            e = "text:rastasheep3@gmail.com",
            n = "text:Aleksandar Diklic",
            p = "text:+1234567890",
            a = "text:123 Main St, City, State 12345",
        },

        -- Hyper+H for Hammerspoon
        h = {
            label = "Hammerspoon",
            r = "reload",
            c = "cmd:code ~/.hammerspoon",
            l = function()
                hs.console.hswindow():focus()
            end,
            d = "cmd:open ~/Library/Logs/Hammerspoon",
        },
    }
})
