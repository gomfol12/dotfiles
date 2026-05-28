--- Colors ---

local cache_path = os.getenv("XDG_CACHE_HOME")
if not cache_path then
    cache_path = os.getenv("HOME") .. "/.cache"
end

local theme = loadfile(cache_path .. "/theming/colors.lua")()
local colors = theme.colors

--- Globals ---

local terminal = "kitty"
local file_manager = "nemo"
local menu = "dmenu_run"
local browser = "firefox"

--- Monitors ---

local PRIMARY = os.getenv("PRIMARY")
local SECONDARY = os.getenv("SECONDARY")

if PRIMARY then
    hl.monitor({
        output = PRIMARY,
        mode = "1920x1080@119.98",
        position = "1920x0",
        scale = 1,
    })
    hl.exec_cmd("xrandr --output " .. PRIMARY .. " --primary")
end
if SECONDARY then
    hl.monitor({
        output = SECONDARY,
        mode = "1920x1080@60",
        position = "0x0",
        scale = 1,
    })
end

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "auto",
})

--- Autostart ---

hl.on("hyprland.start", function()
    local cmds = {
        "sleep 1 && theming -f",
        "lxpolkit",
        "awww-daemon",
        -- "kanshi",
        "~/.config/eww/scripts/start.sh",
        "nm-applet",
        "blueman-applet",
        "easyeffects --gapplication-service",
        -- "xsettingsd",
        "nextcloud --background",
        "hyprpm reload",
        "hypridle",
        "clip_manager -r && wl-paste --watch clip_manager -s",
        "tmux setenv -g HYPRLAND_INSTANCE_SIGNATURE " .. os.getenv("HYPRLAND_INSTANCE_SIGNATURE"),
    }

    for _, cmd in ipairs(cmds) do
        hl.exec_cmd(cmd)
    end
end)

--- Settings ---

hl.config({
    general = {
        border_size = 2,
        gaps_in = 0,
        gaps_out = 0,
        ["col.active_border"] = colors.color1,
        ["col.inactive_border"] = colors.color8,
        resize_on_border = false,
        layout = "dwindle",
        allow_tearing = true,
        no_focus_fallback = true,
    },
    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        mouse_move_focuses_monitor = false,
    },
    binds = {
        window_direction_monitor_fallback = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    cursor = {
        no_hardware_cursors = true,
        inactive_timeout = 5,
        default_monitor = PRIMARY,
    },
    input = {
        -- keyboard
        kb_layout = "de",
        kb_variant = "neo_qwertz",
        kb_model = "pc105",
        -- kb_options = caps:escape, shift:both_capslock_cancel
        kb_rules = "evdev",
        numlock_by_default = false,
        repeat_delay = 200,
        repeat_rate = 40,

        -- mouse
        follow_mouse = 2,
        float_switch_override_focus = 0,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification
        accel_profile = "flat",

        -- touchpad
        scroll_method = "2fg",
        touchpad = {
            natural_scroll = true,
            scroll_factor = 1.0,
            clickfinger_behavior = true,
            tap_to_click = true,
            tap_and_drag = true,
        },

        -- tablet
        tablet = {
            output = "current",
        },
    },
    gestures = {
        workspace_swipe_create_new = false,
    },
    decoration = {
        rounding = 0,
        blur = {
            enabled = false,
        },
        shadow = {
            enabled = false,
        },
    },
    animations = {
        enabled = true,
    },
    ecosystem = {
        no_update_news = true,
        no_donation_nag = true,
    },
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
    plugin = {
        split_monitor_workspaces = {
            count = 9,
            enable_wrapping = false,
            keep_focused = true,
            enable_persistent_workspaces = true,
            -- enable_notifications = true,
        },
    },
})

local smw = hl.plugin.split_monitor_workspaces
if SECONDARY then
    smw.monitor_priority({ PRIMARY, SECONDARY })
    smw.max_workspaces({ monitor = SECONDARY, max = 5 })
elseif PRIMARY then
    smw.monitor_priority({ PRIMARY })
    smw.max_workspaces({ monitor = SECONDARY, max = 9 })
end

--- Keybinds ---

local mainMod = "ALT"
local superMod = "SUPER"

--- Convert a table of keybinds to a `+` separated string
--- @param keys string[] List of modifier keys
--- @param ... any
local function bind(keys, ...)
    hl.bind(table.concat(keys, "+"), ...)
end

-- submap for disabling all keybinds (toggle)
bind({ mainMod, superMod, "SHIFT", "CONTROL", "b" }, hl.dsp.submap("clean"))
hl.define_submap("clean", function()
    -- dups for keybinds in disabled mode

    bind({ "XF86AudioStop" }, hl.dsp.exec_cmd("audio.sh stop"))
    bind({ "XF86AudioNext" }, hl.dsp.exec_cmd("audio.sh next"))
    bind({ "XF86AudioPrev" }, hl.dsp.exec_cmd("audio.sh prev"))
    bind({ "XF86AudioPlay" }, hl.dsp.exec_cmd("audio.sh play-pause"))

    bind({ mainMod, "F1" }, hl.dsp.exec_cmd("start-replay.sh"))
    bind({ mainMod, "F2" }, hl.dsp.exec_cmd("stop-replay.sh"))
    bind({ mainMod, "F3" }, hl.dsp.exec_cmd("save-replay.sh"))

    bind({ mainMod, superMod, "SHIFT", "CONTROL", "b" }, hl.dsp.submap("reset"))
end)

-- general
bind({ superMod, "SHIFT", "Z" }, hl.dsp.exec_cmd('dmenu_prompt.sh "Quit hyprland?" "hyprctl dispatch hl.dsp.exit()"'))
bind({ mainMod, "SHIFT", "C" }, hl.dsp.window.close())
-- bind({ mainMod, "SHIFT", "K" }, hl.dsp.window.kill())
bind({ mainMod, "SHIFT", "F" }, hl.dsp.window.float())
bind({ mainMod, "F" }, hl.dsp.window.fullscreen("fullscreen"))
bind({ mainMod, "S" }, hl.dsp.window.fullscreen({ mode = "maximized" }))
bind({ mainMod, "A" }, hl.dsp.window.pin())
bind({ mainMod, "T" }, function()
    local c = hl.get_active_window()
    if not c then
        return
    end

    if c.floating then
        hl.dispatch(hl.dsp.window.float({ action = "unset" }))
    end
    if c.fullscreen == 1 then
        hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "unset" }))
    end
    if c.fullscreen == 2 then
        hl.dispatch(hl.dsp.window.fullscreen({ action = "unset" }))
    end
    if c.pinned then
        hl.dispatch(hl.dsp.window.pin({ action = "unset" }))
    end
end)

---@param layout string
local function set_layout_active_workspace(layout)
    local ws = hl.get_active_workspace()
    if not ws then
        return
    end
    hl.workspace_rule({
        workspace = tostring(ws.id),
        layout = layout,
    })
end

-- system
bind({ superMod, "SHIFT", "R" }, hl.dsp.exec_cmd('dmenu_prompt.sh "Reboot?" "reboot"'))
bind({ superMod, "SHIFT", "D" }, hl.dsp.exec_cmd('dmenu_prompt.sh "Shutdown?" "shutdown -h now"'))
bind({ superMod, "SHIFT", "T" }, hl.dsp.exec_cmd('dmenu_prompt.sh "Hibernate?" "systemctl hibernate"'))
bind({ superMod, "SHIFT", "F" }, hl.dsp.exec_cmd('dmenu_prompt.sh "Suspend?" "systemctl suspend"'))

-- starting programs
bind({ superMod, "T" }, hl.dsp.exec_cmd(terminal))
bind({ mainMod, "SHIFT", "Return" }, hl.dsp.exec_cmd(terminal))
bind({ superMod, "E" }, hl.dsp.exec_cmd(file_manager))
bind({ superMod, "C" }, hl.dsp.exec_cmd(browser))
bind({ superMod, "V" }, hl.dsp.exec_cmd("code"))
bind({ superMod, "D" }, hl.dsp.exec_cmd("ELECTRON_OZONE_PLATFORM_HINT= discord"))
bind({ superMod, "M" }, hl.dsp.exec_cmd("spotify-launcher"))
bind({ superMod, "S" }, hl.dsp.exec_cmd("steam"))
bind({ superMod, "O" }, hl.dsp.exec_cmd("thunderbird"))

-- multimedia keys
bind({ "XF86AudioStop" }, hl.dsp.exec_cmd("audio.sh stop"))
bind({ "XF86AudioNext" }, hl.dsp.exec_cmd("audio.sh next"))
bind({ "XF86AudioPrev" }, hl.dsp.exec_cmd("audio.sh previous"))
bind({ "XF86AudioPlay" }, hl.dsp.exec_cmd("audio.sh play-pause"))

-- util
bind({ "Menu" }, hl.dsp.exec_cmd(menu))
bind({ "Print" }, hl.dsp.exec_cmd("screenshotter.sh"))
bind({ "Scroll_Lock" }, hl.dsp.exec_cmd("audio.sh eww swap"))
bind({ superMod, "F" }, hl.dsp.exec_cmd("emojiselect.sh"))
bind({ superMod, "P" }, hl.dsp.exec_cmd("hyprpicker -na"))
bind({ superMod, "L" }, hl.dsp.exec_cmd("hyprlock"))
bind({ "XF86MonBrightnessUp" }, hl.dsp.exec_cmd("brightness.sh up"))
bind({ "XF86MonBrightnessDown" }, hl.dsp.exec_cmd("brightness.sh down"))
bind({ "SHIFT", "XF86MonBrightnessUp" }, hl.dsp.exec_cmd("brightness.sh sup"))
bind({ "SHIFT", "XF86MonBrightnessDown" }, hl.dsp.exec_cmd("brightness.sh sdown"))
bind({ mainMod, "F12" }, hl.dsp.exec_cmd("mount.sh"))
bind({ mainMod, "F11" }, hl.dsp.exec_cmd("umount.sh"))
bind({ mainMod, "c" }, hl.dsp.exec_cmd("dmenu_calc.sh"))
bind({ mainMod, "m" }, hl.dsp.exec_cmd("tearing.sh ask"))
bind({ mainMod, "SHIFT", "m" }, hl.dsp.exec_cmd("tearing.sh toggle_steam"))
bind({ superMod, "W" }, hl.dsp.exec_cmd('${TERMINAL:-st} -e nvim "+:VimwikiIndex"'))
bind({ mainMod, "y" }, hl.dsp.exec_cmd("clip_manager -l | dmenu -l 10 | clip_manager -g | wl-copy"))
-- TODO: toggle bar

-- volume
bind({ mainMod, "F6" }, hl.dsp.exec_cmd("audio.sh eww mute microphone toggle"))
bind({ mainMod, "F7" }, hl.dsp.exec_cmd("audio.sh eww mute sink toggle"))
bind({ mainMod, "F8" }, hl.dsp.exec_cmd("audio.sh eww mute all"))

-- -- Move focus
bind({ mainMod, "h" }, hl.dsp.focus({ direction = "l" }))
bind({ mainMod, "l" }, hl.dsp.focus({ direction = "r" }))
bind({ mainMod, "k" }, hl.dsp.focus({ direction = "u" }))
bind({ mainMod, "j" }, hl.dsp.focus({ direction = "d" }))
bind({ mainMod, "Tab" }, function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)
bind({ mainMod, "W" }, hl.dsp.focus({ monitor = "+1" }))
bind({ mainMod, "E" }, hl.dsp.focus({ monitor = "-1" }))

-- Move windows
bind({ mainMod, "SHIFT", "h" }, hl.dsp.window.move({ direction = "l" }))
bind({ mainMod, "SHIFT", "l" }, hl.dsp.window.move({ direction = "r" }))
bind({ mainMod, "SHIFT", "k" }, hl.dsp.window.move({ direction = "u" }))
bind({ mainMod, "SHIFT", "j" }, hl.dsp.window.move({ direction = "d" }))
bind({ mainMod, "SHIFT", "W" }, function()
    smw.change_monitor("prev")
end)
bind({ mainMod, "SHIFT", "E" }, function()
    smw.change_monitor("next")
end)

-- Switch workspaces and move active window to a workspace
for i = 1, 9 do
    local key = tostring(i)
    hl.bind(mainMod .. " + " .. key, function()
        return smw.workspace(i)
    end)
    hl.bind(mainMod .. " + SHIFT + " .. key, function()
        return smw.move_to_workspace_silent(i)
    end)
end

-- -- Move/resize windows with mainMod + LMB/RMB and dragging
bind({ mainMod, "mouse:272" }, hl.dsp.window.drag(), { mouse = true })
bind({ mainMod, "mouse:273" }, hl.dsp.window.resize(), { mouse = true })

-- -- pass
-- bind({ mainMod, "F9" }, hl.dsp.pass("class:discord"))
-- bind({ mainMod, "F10" }, hl.dsp.pass("class:discord")})

--- Animations ---

hl.animation({ leaf = "windows", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "default" })
hl.animation({ leaf = "border", enabled = false, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = false, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = false, speed = 6, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default", style = "fade" })

--- Window rules ---

hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize" })

hl.window_rule({
    -- Fix some dragging issues with XWayland
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },

    no_focus = true,
})

-- "smart gaps" / "no gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "w[tv1]" }, rounding = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, border_size = 0 })
hl.window_rule({ match = { float = false, workspace = "f[1]" }, rounding = 0 })

hl.window_rule({ match = { class = "steam" }, float = true })
hl.window_rule({ match = { class = "zenity", title = "Steam setup" }, float = true, center = true })
hl.window_rule({
    match = { class = "steam", title = "Steam" },
    center = true,
    size = "(monitor_w*0.8) (monitor_h*0.8)",
})

hl.window_rule({
    match = { class = "org.prismlauncher.PrismLauncher" },
    float = true,
    size = "(monitor_w*0.7) (monitor_h*0.7)",
})

hl.window_rule({
    match = { class = "blueman-manager" },
    float = true,
    size = "(monitor_w*0.3) (monitor_h*0.6)",
})

hl.window_rule({
    match = { class = "nm-connection-editor" },
    float = true,
    size = "(monitor_w*0.3) (monitor_h*0.6)",
})

hl.window_rule({
    match = { class = "Nsxiv" },
    float = true,
    center = true,
    size = "(monitor_w*0.7) (monitor_h*0.7)",
})

hl.window_rule({
    match = { class = "mpv" },
    float = true,
    center = true,
    size = "(monitor_w*0.7) (monitor_h*0.7)",
})

hl.window_rule({
    match = { class = "localsend" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
    center = true,
})

hl.window_rule({
    match = { class = "system-config-printer" },
    float = true,
    center = true,
})

-- firefox
hl.window_rule({
    match = { class = "firefox" },
    render_unfocused = true,
})

-- tearing
hl.window_rule({
    name = "steam_immediate",
    match = { class = "steam.*" },
    immediate = true,
})
hl.window_rule({
    match = { class = "osu.*" },
    immediate = true,
})

-- ueberzugpp
hl.window_rule({
    match = { class = "ueberzugpp.*" },
    float = true,
    no_anim = true,
    no_blur = true,
    no_focus = true,
    no_shadow = true,
    border_size = 0,
})

-- nextcloud client
hl.window_rule({
    match = { class = "com.nextcloud.desktopclient.nextcloud", title = "Nextcloud" },
    float = true,
    size = "(monitor_w*0.2) (monitor_h*0.5)",
    border_size = 0,
    move = { "(monitor_w*1)-window_w-0", "30" },
    no_anim = true,
})
hl.window_rule({
    match = { class = "com.nextcloud.desktopclient.nextcloud", title = "Nextcloud Settings" },
    float = true,
})

-- thunderbird
hl.window_rule({
    match = { class = "thunderbird", initial_title = "Kalendererinnerungen" },
    float = true,
    center = true,
})
hl.window_rule({
    match = { class = "thunderbird" },
    workspace = 11,
})

-- discord
hl.window_rule({
    match = { class = "com.discordapp.Discord" },
    workspace = 10,
})
hl.window_rule({
    match = { class = "discord" },
    workspace = 10,
})
