---@module 'hl'

-- Hyprland config, Lua flavour.
-- Reference: https://wiki.hypr.land/Configuring/Start/
-- Stubs for completion: /usr/share/hypr/stubs/hl.meta.lua

local home = os.getenv("HOME")
local bin  = home .. "/.local/bin"

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Machine-specific monitor/workspace layout.
-- monitors.lua is a gitignored symlink to monitors.laptop.lua or monitors.desktop.lua.
require("monitors")

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm app -- hypridle & systemctl --user start hyprpolkitagent")
    hl.exec_cmd("uwsm app -- hyprpaper")
    hl.exec_cmd("uwsm app -- waybar")
    hl.exec_cmd("uwsm app -- swaync")

    -- Clipboard history: text and images tracked separately.
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Screen sharing.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Homerow mods.
    hl.exec_cmd(home .. "/.config/kmonad/activate.sh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 0,
        border_size = 2,

        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        layout = "master",
    },

    master = {
        orientation       = "left",  -- master area on the left
        mfact             = 0.5,     -- master gets 50% of the screen
        new_status        = "slave", -- new windows go to the slave stack
        new_on_active     = "none",  -- obey new_on_top setting
        new_on_top        = true,    -- add new windows to the top of the stack
        allow_small_split = false,   -- only one master window at a time
    },

    decoration = {
        rounding = 5,

        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,
        },

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },
    },

    animations = {
        enabled = true,
    },

    xwayland = {
        enabled = true,
    },
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true,  speed = 7,  bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true,  speed = 7,  bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true,  speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true,  speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true,  speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = false, speed = 6,  bezier = "default" })

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "caps:escape",
        kb_rules   = "",

        follow_mouse       = 1,
        numlock_by_default = true,
        sensitivity        = 0, -- -1.0 - 1.0, 0 means no modification.

        touchdevice = {
            enabled = false,
        },

        touchpad = {
            natural_scroll = true,
            scroll_factor  = 0.5,
        },
    },

    gestures = {
        workspace_swipe_invert   = true,
        workspace_swipe_distance = 700,
    },
})

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- ghostty"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))

-- Launchers and menus
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("tofi-drun | xargs hyprctl dispatch exec --"))
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.exec_cmd(bin .. "/scripts-menu"))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(bin .. "/powermenu"))

-- File managers
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("uwsm app -- " .. bin .. "/run-in-new-term yazi"))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd("uwsm app -- nemo"))

-- Browser and bookmarks
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("uwsm app -- zen-browser"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("uwsm app -- zen-browser"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(bin .. "/bookmarks-menu | ifne xargs zen-browser --new-tab"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(bin .. "/bookmarks-menu | ifne wl-copy"))

-- Clipboard history
hl.bind(mainMod .. " + SHIFT + V",
    hl.dsp.exec_cmd('cliphist list | tofi --prompt-text "Clipboard history: " | cliphist decode | wl-copy'))

-- Misc
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(bin .. "/align_workspaces"))
hl.bind(mainMod .. " + o", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("uwsm app -- hyprshot -m region -f"))
hl.bind(mainMod .. " + SHIFT + B",
    hl.dsp.exec_cmd("uwsm app -- swww img -t none --transition-duration 0.1 wallpapers/$(\\ls ~/wallpapers | shuf -n 1)"))

-- Move focus with mainMod + arrow keys / hjkl.
-- Note: J is up and K is down here, matching the original config.
local focusKeys = {
    { "left",  "left" },
    { "H",     "left" },
    { "right", "right" },
    { "L",     "right" },
    { "up",    "up" },
    { "J",     "up" },
    { "down",  "down" },
    { "K",     "down" },
}
for _, entry in ipairs(focusKeys) do
    hl.bind(mainMod .. " + " .. entry[1], hl.dsp.focus({ direction = entry[2] }))
end

-- Switch workspaces with mainMod + [0-9], move active window with mainMod + SHIFT + [0-9].
-- Moves are silent (focus stays put), matching movetoworkspacesilent.
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + TAB", hl.dsp.focus({ workspace = 10 }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Mac-style shortcuts: SUPER stands in for CTRL.
-- Copy/paste need the CTRL+SHIFT variant in terminals, so branch on the active
-- window's class at press time. Matched as a set, not a pattern: Lua patterns have
-- no alternation, and classes are capitalised inconsistently (e.g. "Alacritty").
local terminalClasses = {
    ["kitty"]                 = true,
    ["alacritty"]             = true,
    ["ghostty"]               = true,
    ["com.mitchellh.ghostty"] = true,
}
for _, key in ipairs({ "C", "V" }) do
    hl.bind(mainMod .. " + " .. key, function()
        local win = hl.get_active_window()
        local mods = (win and win.class and terminalClasses[win.class:lower()])
            and "CTRL_SHIFT" or "CTRL"
        hl.dispatch(hl.dsp.send_shortcut({ mods = mods, key = key }))
    end)
end
for _, key in ipairs({ "X", "Z", "R", "F" }) do
    hl.bind(mainMod .. " + " .. key, hl.dsp.send_shortcut({ mods = "CTRL", key = key }))
end
-- SUPER + A is bound to align_workspaces above, so no CTRL+A passthrough here.

-- Laptop lid
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("hyprlock & sleep 1 && systemctl suspend-then-hibernate"),
    { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl dispatch dpms on"), { locked = true })

-- Media and brightness keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"),
    { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"),
    { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(
    "amixer set Capture toggle && amixer get Capture | grep '\\[off\\]' " ..
    '&& notify-send "MIC switched OFF" || notify-send "MIC switched ON"'))

----------------------
---- WINDOW RULES ----
----------------------

hl.window_rule({
    name  = "dsp-immediate",
    match = { class = "^(steam_app_1366540)$" },

    immediate = true,
})
