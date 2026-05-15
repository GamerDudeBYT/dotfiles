-- Hyprland Lua config
-- https://wiki.hypr.land/Configuring/Start/

require("colors") -- was: source = ./colors.conf


------------------
---- MONITORS ----
------------------

hl.monitor({ output = "DP-1",     mode = "2560x1440@180", position = "auto", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1440x900@75",   position = "auto", scale = 1 })
hl.monitor({ output = "Virtual-1",mode = "1920x1080@60",  position = "auto", scale = 1 })


---------------------
---- MY PROGRAMS ----
---------------------

local terminal          = "ghostty"
local fileManager       = "dolphin"
local menu              = "pkill rofi || rofi -show drun"
local reload_waybar     = "pkill waybar; waybar &"
local browser           = "firefox"
local password_manager  = "1password --disable-gpu-sandbox"
local notificationcenter = "swaync-client -t -fw"
local screenshot        = "hyprshot -m region --freeze --raw | satty --filename -"
local cava              = "~/nixos-dotfiles/scripts/launch_cava.sh"


-------------------
---- AUTOSTART ----
-------------------

-- NOTE: environment variables belong in ~/.config/uwsm/env and ~/.config/uwsm/env-hyprland
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprlock --immediate-render")
    hl.exec_cmd(terminal)
    hl.exec_cmd("nm-applet")
    hl.exec_cmd(browser)
    hl.exec_cmd("waybar")
    hl.exec_cmd("swww-daemon")
    hl.exec_cmd("hyprctl dispatch workspace 1")
    hl.exec_cmd("swaync")
    hl.exec_cmd("wl-paste --watch clipman store")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("tail-tray")
    hl.exec_cmd(cava)
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in      = 5,
        gaps_out     = 20,
        border_size  = 2,
        col = {
            -- was: col.active_border = $primary_container $inverse_primary 45deg
            -- colors.lua should expose these as hex strings; update below once you have them
            active_border   = { colors = { "$primary_container", "$inverse_primary" }, angle = 45 },
            inactive_border = "$outline",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 5,
        rounding_power = 2,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },
        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        pseudotile     = true,
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },

    input = {
        kb_layout  = "gb",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",
        follow_mouse = 2,
        sensitivity  = 0,
        touchpad = {
            natural_scroll = false,
        },
    },
})


--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear",         { type = "bezier", points = { {0,    0},    {1,    1} } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5,  0.5},  {0.75, 1} } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1,  1} } })

hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true, speed = 7,    bezier = "quick" })


---------------
---- INPUT ----
---------------

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Apps
hl.bind(mainMod .. " + Q",           hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C",           hl.dsp.window.close())
hl.bind(mainMod .. " + M",           hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(mainMod .. " + E",           hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V",           hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P",           hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",           hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + R",   hl.dsp.exec_cmd(reload_waybar))
hl.bind(mainMod .. " + B",           hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + O",           hl.dsp.exec_cmd(password_manager))
hl.bind(mainMod .. " + ALT + T",     hl.dsp.exec_cmd("teams-for-linux"))
hl.bind(mainMod .. " + SHIFT + N",   hl.dsp.exec_cmd(notificationcenter))
hl.bind(mainMod .. " + SHIFT + S",   hl.dsp.exec_cmd(screenshot))
hl.bind(mainMod .. " + SHIFT + up",  hl.dsp.exec_cmd("hyprctl dispatch overview:toggle"))
hl.bind(mainMod .. " + ALT + C",     hl.dsp.exec_cmd(cava))
hl.bind(mainMod .. " + L",           hl.dsp.exec_cmd("hyprlock"))

-- Focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
end

-- Extra workspaces 11-15 (mainMod + ALT + 1-5)
for i = 1, 5 do
    hl.bind(mainMod .. " + ALT + " .. i, hl.dsp.focus({ workspace = 10 + i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + CTRL + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + S",  hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume & brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),     { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                   { locked = true, repeating = true })

-- Media keys
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),        { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"),  { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),    { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Suppress maximize requests from all apps
hl.window_rule({
    name          = "suppress-maximize",
    match         = { class = ".*" },
    suppress_event = "maximize",
})

-- Fix XWayland drag issues
hl.window_rule({
    name      = "fix-xwayland-drags",
    match     = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus  = true,
})

-- Satty: float and center
hl.window_rule({
    name  = "satty-float",
    match = { class = "^(satty)$" },
    float = true,
    move  = "center",
})

-- Workspace assignments
hl.workspace_rule({ workspace = "1",  monitor = "DP-1",     default = true })
hl.workspace_rule({ workspace = "11", monitor = "HDMI-A-1", default = true })