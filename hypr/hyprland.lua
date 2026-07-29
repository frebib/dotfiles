-- https://wiki.hyprland.org/Configuring/Configuring-Hyprland/

require("monitors")
require("workspaces")

hl.config({
    general = {
        gaps_in = 10,
        gaps_out = 24,
        border_size = 0,
        -- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,
        layout = "dwindle",
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },

    xwayland = {
        force_zero_scaling = true,
    },

    cursor = {
        enable_hyprcursor = false,
        zoom_factor = 1.0,
        zoom_detached_camera = false,
    },

    decoration = {
        rounding = 13,
        rounding_power = 3.0,
        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 0.55,
        -- How much to dim the rest of the screen when the special workspace is open
        dim_special = 0.5,
        shadow = {
            enabled = true,
            range = 50,
            --offset = 0 8
            render_power = 3,
            color = "rgba(00000060)",
        },
        blur = {
            enabled = true,
            size = 30,
            passes = 3,
            ignore_opacity = true,
            noise = 0.006,
            vibrancy = 0.1696,
        },
    },

    dwindle = {
        preserve_split = true,
        -- You probably want this
        smart_resizing = false,
        --pseudotile = true # Master switch for pseudotiling. Enabling is bound to super + P in the keybinds section below
        default_split_ratio = 1.1,
    },

    input = {
        kb_layout = "gb",
        kb_variant = "dvorak",
        -- kb_model =
        -- kb_options =
        -- kb_rules =
        follow_mouse = 1,
        float_switch_override_focus = 2,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
        touchpad = {
            natural_scroll = true,
        },
    },

    binds = {
        scroll_event_delay = 1,
    },
})

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.config({ animations = { enabled = true } })

hl.curve("opening", { type = "bezier", points = {{0.05, 0.9}, {0.1, 1.05} } })
hl.curve("windowsIn", { type = "bezier", points = {{0.2, 1.27}, {0.6, 1.0} } })
hl.curve("easeOutCustom", { type = "bezier", points = {{0.3, 1.0}, {0.5, 1.0} } })
hl.curve("easeOutBackCustom", { type = "bezier", points = {{0.2, 1.2}, {0.6, 1.0} } })

hl.animation({ leaf = "windows",     enabled = true, speed = 4, bezier = "opening" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3, bezier = "windowsIn", style = "popin" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 4, bezier = "easeOutCustom" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = false, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeSwitch",  enabled = true, speed = 5, bezier = "default" })
hl.animation({ leaf = "fadeDim",     enabled = true, speed = 9, bezier = "default" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 5, bezier = "easeOutBackCustom", style = "slidefade 50%" })

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

--hl.bind("SUPER + M", hl.dsp.exec_cmd("uwsm stop"))
hl.bind("SUPER + Apostrophe", hl.dsp.window.close())
hl.bind("SUPER + ALT + SPACE", hl.dsp.window.center())
hl.bind("SUPER + U", hl.dsp.window.float())
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + F", hl.dsp.window.fullscreen())
hl.bind("SUPER + Period", hl.dsp.layout("togglesplit dwindle"))
hl.bind("SUPER + Comma", hl.dsp.layout("swapsplit dwindle"))
hl.bind("SUPER + M", hl.dsp.layout("preselect r"))
hl.bind("SUPER + W", hl.dsp.layout("preselect d"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("hyprctl kill"))

hl.bind("SUPER + B", hl.dsp.exec_raw("uwsm app -- firefox"))
hl.bind("SUPER + Return", hl.dsp.exec_raw("uwsm app -- ghostty"))
hl.bind("SUPER + SHIFT + Return", hl.dsp.exec_cmd("uwsm app -- ghostty --working-directory=$(hyprcwd)"))
hl.bind("SUPER + CONTROL + Return", hl.dsp.exec_cmd("uwsm app -- ghostty --class=com.mitchellh.ghostty.floating"))
hl.bind("SUPER + SHIFT + CONTROL + Return", hl.dsp.exec_cmd("uwsm app -- ghostty --working-directory=$(hyprcwd) --class=com.mitchellh.ghostty.floating"))
hl.bind("SUPER + Space", hl.dsp.exec_raw("uwsm app -- rofi -modi drun -show drun -show-icons -normal-window -run-command 'uwsm app -- {cmd}'"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_raw("uwsm app -- rofi -modi emoji -show emoji"))
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exec_cmd("uwsm app --  config/hypr/powermenu.sh"), { repeating = true })
hl.bind("SUPER + K", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"), { repeating = true })
hl.bind("Pause", hl.dsp.pass({ window = "class:^(TeamSpeak 3)$" }), { non_consuming = true, ignore_mods = true, pass = true })

-- Move focus with super + dhtn
hl.bind("SUPER + d", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + h", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + t", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + n", hl.dsp.focus({ direction = "right" }))

-- Move window with super + shift + dhtn
hl.bind("SUPER + SHIFT + d", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + h", hl.dsp.window.move({ direction = "down" }))
hl.bind("SUPER + SHIFT + t", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + n", hl.dsp.window.move({ direction = "right" }))

-- Move workspace with super + alt + dhtn
hl.bind("SUPER + ALT + d", hl.dsp.workspace.move({ monitor = "left" }))
hl.bind("SUPER + ALT + h", hl.dsp.workspace.move({ monitor = "down" }))
hl.bind("SUPER + ALT + t", hl.dsp.workspace.move({ monitor = "up" }))
hl.bind("SUPER + ALT + n", hl.dsp.workspace.move({ monitor = "right" }))

-- Switch workspaces with super + [0-9]
hl.bind("SUPER + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("SUPER + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("SUPER + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("SUPER + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("SUPER + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("SUPER + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("SUPER + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("SUPER + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("SUPER + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("SUPER + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with super + SHIFT + [0-9]
hl.bind("SUPER + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("SUPER + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("SUPER + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("SUPER + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("SUPER + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("SUPER + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("SUPER + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("SUPER + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("SUPER + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("SUPER + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind("SUPER + ALT + 0", hl.dsp.window.move({ workspace = 10 }, { follow = false }))
hl.bind("SUPER + ALT + 1", hl.dsp.window.move({ workspace = 1 }, { follow = false }))
hl.bind("SUPER + ALT + 2", hl.dsp.window.move({ workspace = 2 }, { follow = false }))
hl.bind("SUPER + ALT + 3", hl.dsp.window.move({ workspace = 3 }, { follow = false }))
hl.bind("SUPER + ALT + 4", hl.dsp.window.move({ workspace = 4 }, { follow = false }))
hl.bind("SUPER + ALT + 5", hl.dsp.window.move({ workspace = 5 }, { follow = false }))
hl.bind("SUPER + ALT + 6", hl.dsp.window.move({ workspace = 6 }, { follow = false }))
hl.bind("SUPER + ALT + 7", hl.dsp.window.move({ workspace = 7 }, { follow = false }))
hl.bind("SUPER + ALT + 8", hl.dsp.window.move({ workspace = 8 }, { follow = false }))
hl.bind("SUPER + ALT + 9", hl.dsp.window.move({ workspace = 9 }, { follow = false }))
hl.bind("SUPER + ALT + 0", hl.dsp.window.move({ workspace = 10 }, { follow = false }))

-- Example special workspace (scratchpad)
hl.bind("SUPER + Grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SUPER + SHIFT + Grave", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with super + LMB/RMB and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Play/pause, prev and next with super + shift + arrows and multimedia keys
hl.bind("SUPER + SHIFT + Left", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("SUPER + SHIFT + Right", hl.dsp.exec_cmd("playerctl next"))
hl.bind("SUPER + SHIFT + Space", hl.dsp.exec_cmd("playerctl play-pause"))

hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true })

-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Uncommon-tips-and-tricks/#glass-magnifier-zoom
local MAX_ZOOM = 8
local MIN_ZOOM = 1
local function zoom(offset)
    local current = hl.get_config("cursor.zoom_factor")
    if offset ~= nil then
        current = current + offset
    elseif current ~= MIN_ZOOM then
        current = MIN_ZOOM
    end
    current = math.max(MIN_ZOOM, math.min(MAX_ZOOM, current))
    hl.config({ cursor = { zoom_factor = current } })
end

hl.bind("SUPER + SHIFT + mouse_up", function() zoom(0.2) end)
hl.bind("SUPER + SHIFT + mouse_down", function() zoom(-0.2) end)
hl.bind("SUPER + SHIFT + equal", function() hl.config({ cursor = { zoom_factor = 1 }}) end)

hl.window_rule({
    name  = "float windows with class=float",
    match = { class = "floating" },
    float = true,
})

hl.window_rule({
    name  = "float ghostty floating windows",
    match = { class = "com.mitchellh.ghostty.floating" },
    float = true,
})

hl.layer_rule({
    match = { namespace = "notifications" },
    blur = true,
    animation = "slide right",
})

hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true,
})

-- Autostart
-- *sigh*
-- https://github.com/hyprwm/Hyprland/discussions/9967
hl.on("hyprland.start", function()
    hl.exec_cmd("setxkbmap -layout gb -variant dvorak")
end)
