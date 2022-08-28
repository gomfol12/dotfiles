-- ==================== Global Keys ==================== --

-- Default libs
local gears = require("gears")
local gfs = require("gears.filesystem")
local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
-- local menubar = require("menubar")
-- local naughty = require("naughty")

local helper = require("lib.helper")
local c_widgets = require("appearance.widgets")

-- vars
local modkey = RC.vars.modkey
local super = RC.vars.superkey
local terminal = RC.vars.terminal

-- hotkey popup
hotkeys_popup.widget.merge_duplicates = true

return gears.table.join(
    -- awesome
    awful.key({ modkey }, "q", function()
        hotkeys_popup.show_help({}, nil, { show_awesome_keys = true })
    end, { description = "show help for awesome only", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", function()
        hotkeys_popup.show_help(nil, nil, { show_awesome_keys = false })
    end, { description = "show help for current app", group = "awesome" }),
    awful.key({ super, "Shift" }, "g", function()
        awesome.restart()
    end, { description = "reload awesome", group = "awesome" }),
    awful.key({ super, "Shift" }, "z", function()
        helper.dmenu_prompt("Quit awesome?", function()
            awesome.quit()
        end)
    end, { description = "quit awesome", group = "awesome" }),

    -- starting programs
    awful.key({ super }, "t", function()
        awful.spawn(terminal)
    end, { description = "start " .. terminal, group = "programs" }),
    awful.key({ modkey, "Shift" }, "Return", function()
        awful.spawn(terminal)
    end, { description = "start " .. terminal, group = "programs" }),
    awful.key({ super }, "c", function()
        awful.spawn(RC.vars.browser)
    end, { description = "start " .. RC.vars.browser, group = "programs" }),
    awful.key({ super }, "v", function()
        awful.spawn("/usr/bin/code")
    end, { description = "start vscode", group = "programs" }),
    awful.key({ super }, "d", function()
        awful.spawn("/usr/bin/discord")
    end, { description = "start discord", group = "programs" }),
    awful.key({ super }, "e", function()
        awful.spawn("/usr/bin/nemo")
    end, { description = "start nemo", group = "programs" }),
    awful.key({ super }, "m", function()
        awful.spawn("/usr/bin/spotify")
    end, { description = "start spotify", group = "programs" }),
    awful.key({ super }, "s", function()
        awful.spawn("/usr/bin/steam")
    end, { description = "start steam", group = "programs" }),
    awful.key({ super }, "o", function()
        awful.spawn("/usr/bin/thunderbird")
    end, { description = "start thunderbird", group = "programs" }),

    -- multimedia keys
    awful.key({}, "XF86AudioStop", function()
        awful.spawn({ "audio.sh", "stop" })
    end, { description = "stop", group = "multimedia" }),
    awful.key({}, "XF86AudioNext", function()
        awful.spawn({ "audio.sh", "next" })
    end, { description = "next track", group = "multimedia" }),
    awful.key({}, "XF86AudioPrev", function()
        awful.spawn({ "audio.sh", "previous" })
    end, { description = "previous track", group = "multimedia" }),
    awful.key({}, "XF86AudioPlay", function()
        awful.spawn({ "audio.sh", "play-pause" })
    end, { description = "play/pause track", group = "multimedia" }),

    awful.key({ "Shift" }, "XF86AudioStop", function()
        awful.spawn({ "audio.sh", "spotify", "stop" })
    end, { description = "spotify stop", group = "multimedia" }),
    awful.key({ "Shift" }, "XF86AudioNext", function()
        awful.spawn({ "audio.sh", "spotify", "next" })
    end, { description = "spotify next track", group = "multimedia" }),
    awful.key({ "Shift" }, "XF86AudioPrev", function()
        awful.spawn({ "audio.sh", "spotify", "previous" })
    end, { description = "spotify previous track", group = "multimedia" }),
    awful.key({ "Shift" }, "XF86AudioPlay", function()
        awful.spawn({ "audio.sh", "spotify", "play-pause" })
    end, { description = "spotify play/pause track", group = "multimedia" }),

    -- util
    awful.key({ modkey }, "x", function()
        awful.spawn.with_shell("xclip -selection c -o | xclip -selection c")
    end, { description = "remove formating from copied text", group = "util" }),
    awful.key({ modkey }, "y", function()
        awful.spawn("clipmenu")
    end, { description = "open clipboard history", group = "util" }),
    awful.key({ super }, "w", function()
        awful.spawn("dmenu_websearch.sh")
    end, { description = "dmenu web search", group = "util" }),
    awful.key({}, "Menu", function()
        awful.spawn("dmenu_run")
    end, { description = "dmenu run", group = "util" }),
    awful.key({}, "Print", function()
        awful.spawn("screenshotter.sh")
    end, { description = "screenshotter", group = "util" }),
    awful.key({}, "Pause", function()
        awful.spawn({ "picom.sh", "-tn" })
    end, { description = "toggle picom", group = "util" }),
    awful.key({}, "Scroll_Lock", function()
        awful.spawn.easy_async({ "audio.sh", "swap" }, function()
            c_widgets.audio_timer:emit_signal("timeout")
        end)
    end, { description = "swap audio output", group = "util" }),
    awful.key({ super }, "n", function()
        awful.spawn.with_shell("colorpicker --short --one-shot --preview | xclip -selection c")
    end, { description = "color picker", group = "util" }),
    awful.key({ super }, "f", function()
        awful.spawn("emojiselect.sh")
    end, { description = "emoji select", group = "util" }),
    awful.key({ modkey }, "p", function()
        local actions = {
            t = function(cmd)
                return { terminal, "-e", cmd }
            end,
            s = function(cmd)
                return { awful.util.shell, "-c", cmd }
            end,
        }
        awful.prompt.run({
            prompt = " Run: ",
            hooks = {
                {
                    {},
                    "Return",
                    function(input)
                        if not input or input:sub(1, 1) ~= ":" then
                            return input
                        end
                        local act, cmd = input:gmatch(":([a-zA-Z1-9]+)[ ]+(.*)")()
                        if not act then
                            return input
                        end
                        return actions[act](cmd)
                    end,
                },
            },
            textbox = awful.screen.focused().promptbox.widget,
            history_path = gfs.get_cache_dir() .. "/history",
            exe_callback = function(input)
                awful.spawn.easy_async(input, function(stdout, stderr, reason, exit_code)
                    if exit_code ~= 0 then
                        if stderr or not stderr == "" then
                            awful.screen.focused().promptbox.widget:set_markup_silently(" " .. stderr)
                        end
                    else
                        if stdout or not stdout == "" then
                            awful.screen.focused().promptbox.widget:set_markup_silently(" " .. stdout)
                        end
                    end
                end)
            end,
        })
    end, { description = "default run prompt", group = "util" }),
    awful.key({ modkey }, "o", function()
        awful.prompt.run({
            prompt = "Run Lua code: ",
            textbox = awful.screen.focused().promptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        })
    end, { description = "lua execute prompt", group = "util" }),
    awful.key({ super }, "l", function()
        awful.spawn({ "betterlockscreen", "-l" })
    end, { description = "lock the screen", group = "util" }),

    -- focus nav client
    awful.key({ modkey }, "j", function()
        awful.client.focus.bydirection("down")
        client.focus:raise()
    end, { description = "focus by direction down", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.bydirection("up")
        client.focus:raise()
    end, { description = "focus by direction up", group = "client" }),
    awful.key({ modkey }, "h", function()
        awful.client.focus.bydirection("left")
        client.focus:raise()
    end, { description = "focus by direction left", group = "client" }),
    awful.key({ modkey }, "l", function()
        awful.client.focus.bydirection("right")
        client.focus:raise()
    end, { description = "focus by direction right", group = "client" }),
    awful.key({ modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey, "Shift" }, "m", function()
        local c = awful.client.restore()
        -- Focus restored client
        if c then
            c:emit_signal("request::activate", "key.unminimize", { raise = true })
        end
    end, { description = "restore minimized", group = "client" }),

    awful.key({ super, modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus by direction right", group = "client" }),
    awful.key({ super, modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus by direction right", group = "client" }),

    -- swap nav client
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.bydirection("down")
    end, { description = "swap by direction down", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.bydirection("up")
    end, { description = "swap by direction up", group = "client" }),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.client.swap.bydirection("left")
    end, { description = "swap by direction left", group = "client" }),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.client.swap.bydirection("right")
    end, { description = "swap by direction right", group = "client" }),

    -- focus nav screen
    awful.key({ modkey }, "w", function()
        awful.screen.focus_relative(1)
    end, { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey }, "e", function()
        awful.screen.focus_relative(-1)
    end, { description = "focus the previous screen", group = "screen" }),

    -- focus nav tag
    awful.key(
        { modkey },
        "dead_grave",
        awful.tag.history.restore,
        { description = "go back in tag history", group = "tag" }
    ),
    awful.key({ modkey }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then
            client.focus:raise()
        end
    end, { description = "go back in client focus history", group = "tag" }),

    -- layout manipulation
    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),
    awful.key({ modkey, super }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, super }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, super }, "i", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, super }, "u", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, super }, "n", function()
        awful.tag.incncol(1, nil, true)
    end, { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, super }, "m", function()
        awful.tag.incncol(-1, nil, true)
    end, { description = "decrease the number of columns", group = "layout" }),

    -- move resize
    awful.key({ modkey, "Shift" }, "Down", function()
        awful.client.moveresize(0, 0, 0, 20)
    end, { description = "resize down", group = "client" }),
    awful.key({ modkey, "Shift" }, "Up", function()
        awful.client.moveresize(0, 0, 0, -20)
    end, { description = "resize up", group = "client" }),
    awful.key({ modkey, "Shift" }, "Left", function()
        awful.client.moveresize(0, 0, -20, 0)
    end, { description = "resize left", group = "client" }),
    awful.key({ modkey, "Shift" }, "Right", function()
        awful.client.moveresize(0, 0, 20, 0)
    end, { description = "resize right", group = "client" }),

    awful.key({ modkey }, "Down", function()
        awful.client.moveresize(0, 20, 0, 0)
    end, { description = "move down", group = "client" }),
    awful.key({ modkey }, "Up", function()
        awful.client.moveresize(0, -20, 0, 0)
    end, { description = "move up", group = "client" }),
    awful.key({ modkey }, "Left", function()
        awful.client.moveresize(-20, 0, 0, 0)
    end, { description = "move left", group = "client" }),
    awful.key({ modkey }, "Right", function()
        awful.client.moveresize(20, 0, 0, 0)
    end, { description = "move right", group = "client" }),

    -- toggle bar
    awful.key({ modkey }, "b", function()
        local s = awful.screen.focused()
        s.wibox.visible = not s.wibox.visible
    end, { description = "toggle statusbar", group = "screen" }),

    -- volume control
    awful.key({ modkey, "Shift" }, "=", function()
        awful.spawn.easy_async({ "audio.sh", "volume", "inc" }, function()
            c_widgets.audio_timer:emit_signal("timeout")
        end)
    end, { description = "increase volume", group = "volume" }),
    awful.key({ modkey }, "-", function()
        awful.spawn.easy_async({ "audio.sh", "volume", "dec" }, function()
            c_widgets.audio_timer:emit_signal("timeout")
        end)
    end, { description = "decrease volume", group = "volume" }),
    awful.key({ modkey }, "=", function()
        awful.spawn.easy_async({ "audio.sh", "volume", "100%" }, function()
            c_widgets.audio_timer:emit_signal("timeout")
        end)
    end, { description = "volume to 100%", group = "volume" }),
    awful.key({}, "F8", function()
        awful.spawn.easy_async({ "audio.sh", "mute" }, function()
            c_widgets.audio_timer:emit_signal("timeout")
        end)
    end, { description = "toggle mute", group = "volume" })
)
