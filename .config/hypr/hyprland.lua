------------------
---- MONITORS ----
------------------

-- Main Monitor: Acer V196HQL (Nasa Kaliwa, posisyon 0x0)
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1366x768@59.79",
    position = "0x0",
    scale    = "1",
})

-- Secondary Monitor: Built-in Laptop Screen (Nasa Kanan, posisyon 1366x0)
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@60",
    position = "1366x0",
    scale    = "1.25",
})

-- Fallback para sa ibang display
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- Workspace Assignments:
-- Workspaces 1-5 para sa Acer Main Monitor (HDMI-A-1)
for i = 1, 5 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1", default = (i == 1) })
end

-- Workspaces 6-10 para sa Laptop Screen (eDP-1)
for i = 6, 10 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1", default = (i == 6) })
end


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "rofi -show drun"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    hl.exec_cmd("kwalletd6")
    hl.exec_cmd("/usr/lib/pam_kwallet_init")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("fcitx5 -d")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("BROWSER", "zen")
hl.env("SSH_AUTH_SOCK", "")

------------------------------------------
---- LOOK AND FEEL (SAGE GREEN THEME) ----
------------------------------------------

hl.config({
    general = {
        gaps_in  = 4,
        gaps_out = 10,

        border_size = 2,

        col = {
            -- Sage Green to Soft Mint gradient
            active_border   = { colors = {"rgba(8fa88bee)", "rgba(b2c8a2ee)"}, angle = 45 },
            -- Muted Slate / Dark Forest Green for inactive windows
            inactive_border = "rgba(3d4a3eaa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        active_opacity   = 0.96,
        inactive_opacity = 0.88,

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = 0x661e271e,
        },

        blur = {
            enabled   = true,
            size      = 6,
            passes    = 2,
            vibrancy  = 0.2,
            new_optimizations = true,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Animation Curves
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 238.1191, dampening = 24.21279333 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 2.2,  bezier = "almostLinear", style = "fade" })

-- Layout Settings
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
        disable_splash_rendering = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
	kb_options   = "korean:ralt_hangul",
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Core Apps & Windows-Style Shortcuts
hl.bind("CTRL + ALT + T",             	hl.dsp.exec_cmd(terminal))
hl.bind("ALT + F4",                     hl.dsp.window.close())
hl.bind(mainMod .. " + E",              hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",              hl.dsp.exec_cmd(menu))
hl.bind("CTRL + SHIFT + Escape",        hl.dsp.exec_cmd("missioncenter"))
hl.bind("CTRL + ALT + Delete",     	hl.dsp.exec_cmd("wlogout -b 6 -c 15 -r 15 -m 350"))
hl.bind(mainMod .. " + L",		hl.dsp.exec_cmd("hyprlock"))
-- Utilities (Clipboard & Color Picker)
hl.bind(mainMod .. " + V",              hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"))
hl.bind(mainMod .. " + SHIFT + C",      hl.dsp.exec_cmd('hyprpicker -a && notify-send "Color Picker" "Copied to clipboard!" -i color-picker'))

-- Window Management & Sizing
hl.bind(mainMod .. " + SPACE",          hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",              hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J",              hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + M",              hl.dsp.window.fullscreen(1)) -- Maximize / Monocle (May Waybar)
hl.bind(mainMod .. " + F11",            hl.dsp.window.fullscreen(0)) -- Full Fullscreen (Tago ang Waybar)

-- Minimize & Scratchpad
hl.bind(mainMod .. " + down",           hl.dsp.window.move({ workspace = "special:magic" })) -- Minimize
hl.bind(mainMod .. " + S",              hl.dsp.workspace.toggle_special("magic"))            -- Restore / Toggle View

-- Navigation & Window Focus
hl.bind(mainMod .. " + left",           hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",          hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",             hl.dsp.focus({ direction = "up" }))

-- Dual Monitor Navigation & Window Transfer
hl.bind(mainMod .. " + comma",          hl.dsp.focus({ monitor = "HDMI-A-1" }))
hl.bind(mainMod .. " + period",         hl.dsp.focus({ monitor = "eDP-1" }))
hl.bind(mainMod .. " + SHIFT + comma",  hl.dsp.window.move({ monitor = "HDMI-A-1" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "eDP-1" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Mouse Window Movement / Resizing
hl.bind(mainMod .. " + mouse:272",      hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",      hl.dsp.window.resize(), { mouse = true })

-- Screenshot (Super + Shift + S)
hl.bind(mainMod .. " + SHIFT + S",      hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Copied to clipboard!" -i camera'))

-- Audio and Brightness Keys
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Media Controls
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- Alt + Tab para sa mabilisang paglipat ng focus sa susunod na window
hl.bind("ALT + Tab", hl.dsp.focus({ window = "next" }))

-- Alt + Shift + Tab para sa nakaraang window
hl.bind("ALT + SHIFT + Tab", hl.dsp.focus({ window = "previous" }))

-- Super + Shift + Tab para sa Rofi Visual Window Switcher Menu
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.exec_cmd("rofi -show window"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Floating rules para sa Dialogs, System Utilities, at Mission Center
hl.window_rule({
    name  = "float-kleopatra",match = { class = "org.kde.kleopatra" },
    float = true,
})

hl.window_rule({
    name  = "float-dolphin-dialogs",
    match = { class = "org.kde.dolphin", title = "Progress Dialog|Copying.*|Moving.*" },
    float = true,
})

hl.window_rule({
    name  = "float-system-dialogs",
    match = { class = "pavucontrol|blueman-manager|nm-connection-editor|io.missioncenter.MissionCenter|hu.irl.cameractrls" },
    float = true,
})

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})
