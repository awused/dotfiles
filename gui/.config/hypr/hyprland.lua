-- vim: set foldmethod=marker foldlevel=0:

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- {{{ Monitors
local m_center = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS FI32U 20480B000000"
local m_left = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS AD27QD 19050B000191"
local m_right = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS AD27QD 19050B000199"
local m_top = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS AD27QD 19050B000068"

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output = "desc:" .. m_center,
    mode = "3840x2160@120Hz",
    position = "2560x1440",
    vrr = 0,
    scale = 1.5,
})

hl.monitor({
    output = "desc:" .. m_left,
    mode = "2560x1440@120Hz",
    position = "0x1440",
    vrr = 0,
    scale = 1,
})

hl.monitor({
    output = "desc:" .. m_top,
    mode = "2560x1440@120Hz",
    position = "2560x0",
    vrr = 0,
    scale = 1,
})

hl.monitor({
    output = "desc:" .. m_right,
    mode = "2560x1440@120Hz",
    position = "5120x1440",
    vrr = 0,
    scale = 1,
})

-- }}}
---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "alacritty"
local fileManager = "aw-fm"
local menu = "rofi"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("wallpapers daemon")
    hl.exec_cmd("waybar")

    -- hl.exec_cmd("hyprpm reload")
    -- Enable in sudoers with
    -- desuwa ALL=(root) NOPASSWD:/usr/bin/nvidia-smi -i 0 -pl 375
    hl.exec_cmd("sudo /usr/bin/nvidia-smi -i 0 -pl 375")
end)

local hy3 = hl.plugin.hy3
-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")

-- {{{ Appearance
-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,

        border_size = 1,

        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = hy3 and "hy3" or "dwindle",
    },

    debug = {
        disable_logs = false,
    },

    decoration = {
        -- rounding = 10,
        -- rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = 0xee1a1a1a,
        },

        blur = {
            enabled = false,
            size = 3,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    group = {
        groupbar = {
            -- enabled = false,
            text_color = "0xff000000",
            gradients = true,
            -- keep_upper_gap = false,
            gradient_rounding = 0,
        },
    },

    cursor = {
        no_warps = true,
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
    name = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
    no_shadow = true,
    rounding = 0,
})
hl.window_rule({
    name = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
    no_shadow = true,
    rounding = 0,
})
hl.workspace_rule({
    workspace = "n[s:aw-man]",
    gaps_out = 0,
    gaps_in = 0,
    border_size = 0,
    no_border = true,
    -- no_gaps = true,
    layout = "scrolling",
    monitor = "desc:" .. m_center,
    no_shadow = true,
})

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
        column_width = 1.0,
        focus_fit_method = 0,
        wrap_swapcol = false,
        wrap_focus = false,
        follow_min_visible = 0.0,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
    },
})

-- }}}
-- {{{ Input
hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",

        follow_mouse = 2,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },

        accel_profile = "flat",
        sensitivity = -0.4,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
-- }}} Input

--for_window [app_id="calibre-gui"] floating enable
--for_window [app_id="gamescope"] floating enable-
--for_window [app_id="emuera.*"] border none, floating enable

hl.window_rule({
    match = { class = "^emuera.*" },
    float = true,
})
hl.window_rule({
    match = { class = "^awused\\.aw-man$" },
    workspace = "name:aw-man",
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER + " -- Sets "Windows" key as main modifier
local shiftMod = "SHIFT + "
local ctrlMod = "CTRL + "
local altMod = "ALT + "

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. "RETURN", hl.dsp.exec_cmd("/home/desuwa/bin/desu-terminal"))
hl.bind(
    mainMod .. shiftMod .. "RETURN",
    hl.dsp.exec_cmd("gnome-terminal || xfce4-terminal || urxvt || i3-sensible-terminal")
)

hl.bind(mainMod .. shiftMod .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. "D", hl.dsp.exec_cmd("rofi -modi drun,run -show drun"))
hl.bind(mainMod .. shiftMod .. "S", hl.dsp.exec_cmd("rofi -modi ssh -show ssh"))

hl.bind(
    altMod .. shiftMod .. "E",
    hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)

-- hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. shiftMod .. "Space", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. "J", function()
    local workspace = hl.get_active_workspace()

    if not workspace then
        return
    elseif workspace.tiled_layout == "scrolling" then
        hl.dispatch(hl.dsp.layout("promote"))
    elseif workspace.tiled_layout == "dwindle" then
        hl.dispatch(hl.dsp.layout("togglesplit"))
    end
end)

if hy3 then
    hl.bind(mainMod .. "left", hy3.move_focus("left", { warp = false }))
    hl.bind(mainMod .. "right", hy3.move_focus("right", { warp = false }))
    hl.bind(mainMod .. "up", hy3.move_focus("up"))
    hl.bind(mainMod .. "down", hy3.move_focus("down"))

    hl.bind(mainMod .. shiftMod .. "left", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. shiftMod .. "right", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mainMod .. shiftMod .. "up", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. shiftMod .. "down", hl.dsp.window.move({ direction = "down" }))
else
    -- Move focus with mainMod + arrow keys
    hl.bind(mainMod .. "left", function()
        focus_left_right("left")
    end)
    hl.bind(mainMod .. "right", function()
        focus_left_right("right")
    end)
    hl.bind(mainMod .. "up", hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. "down", hl.dsp.focus({ direction = "down" }))

    hl.bind(mainMod .. shiftMod .. "left", hl.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. shiftMod .. "right", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mainMod .. shiftMod .. "up", hl.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. shiftMod .. "down", hl.dsp.window.move({ direction = "down" }))

    hl.bind(mainMod .. "E", hl.dsp.group.toggle())
end

-- group > scrolling workspace > regular focus
function focus_left_right(dir)
    local win = hl.get_active_window()
    local grp = win and win.group

    local workspace = hl.get_active_workspace()
    -- dump(workspace)

    if grp then
        local idx = grp.current_index
        if not ((idx == 1 and dir == "left") or (idx == grp.size and dir == "right")) then
            if dir == "left" then
                idx = idx - 1
            else
                idx = idx + 1
            end

            hl.dispatch(hl.dsp.group.active({ index = idx }))
            return
        end
    end

    if workspace and workspace.tiled_layout == "scrolling" then
        local windows = hl.get_windows()
        local min_x = win.at.x
        local max_x = win.at.x + win.size.x

        for k, w in pairs(windows) do
            if w.workspace.id == workspace.id then
                if w.at.x < min_x and dir == "left" then
                    hl.dispatch(hl.dsp.layout("focus left"))
                    return
                elseif w.at.x + w.size.x > max_x and dir == "right" then
                    hl.dispatch(hl.dsp.layout("focus right"))
                    return
                end
            end
        end
    end

    hl.dispatch(hl.dsp.focus({ direction = dir }))
end

hl.bind(altMod .. shiftMod .. "left", function()
    move_workspace("left")
end)
hl.bind(altMod .. shiftMod .. "right", function()
    move_workspace("right")
end)
hl.bind(altMod .. shiftMod .. "up", function()
    move_workspace("up")
end)
hl.bind(altMod .. shiftMod .. "down", function()
    move_workspace("down")
end)

function move_workspace(dir)
    local monitor = hl.get_active_monitor()
    if not monitor then
        return
    end

    local map = {}
    if dir == "left" then
        map[m_left] = m_right
        map[m_center] = m_left
        map[m_right] = m_center
    elseif dir == "right" then
        map[m_left] = m_center
        map[m_center] = m_right
        map[m_right] = m_left
    elseif dir == "up" or dir == "down" then
        map[m_center] = m_top
        map[m_top] = m_center
    end

    monitor = map[monitor.description]
    if monitor then
        hl.dispatch(hl.dsp.workspace.move({ monitor = "desc:" .. monitor }))
        return
    end
end

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. shiftMod .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. ctrlMod .. "S", hl.dsp.exec_cmd("mpc toggle"))
hl.bind(mainMod .. ctrlMod .. shiftMod .. "S", hl.dsp.exec_cmd("mpc stop"))
hl.bind(mainMod .. ctrlMod .. "U", hl.dsp.exec_cmd("mpc update"))
hl.bind(mainMod .. ctrlMod .. "left", hl.dsp.exec_cmd("mpc prev"))
hl.bind(mainMod .. ctrlMod .. "right", hl.dsp.exec_cmd("mpc next"))
hl.bind(
    mainMod .. ctrlMod .. "up",
    hl.dsp.exec_cmd(
        'mpc volume +5; notify-send Volume \\"$(mpc volume)\\" -t 1000 -i /usr/share/icons/Adwaita/32x32/status/audio-volume-high.png'
    )
)
hl.bind(
    mainMod .. ctrlMod .. "down",
    hl.dsp.exec_cmd(
        'mpc volume -5; notify-send Volume \\"$(mpc volume)\\" -t 1000 -i /usr/share/icons/Adwaita/32x32/status/audio-volume-high.png'
    )
)

hl.bind(mainMod .. ctrlMod .. "M", hl.dsp.exec_cmd("~/.config/i3/mpd-fzf"))
hl.window_rule({
    name = "forced-float",
    match = { title = "^aw-i3-forced-float$" },

    float = true,
})

--bindsym $mod+Control+m exec ~/.config/i3/mpd-fzf
--bindsym $mod+Mod1+m exec mpd-rofi

-- Laptop multimedia keys for volume and LCD brightness

-- Requires playerctl
-- hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
-- hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
-- hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
--
--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name = "fix-xwayland-drags",
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

-- Hyprland-run windowrule
hl.window_rule({
    name = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move = "20 monitor_h-120",
    float = true,
})

hl.config({
    xwayland = {
        force_zero_scaling = true,
    },
})
