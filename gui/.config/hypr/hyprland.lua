-- vim: set foldmethod=marker foldlevel=0:

-- TODO:
--  - idle
--  - locking
--  - missing hotkeys
--  -- hyprlock/hyprlidle
--  - Something for better tabbed aw-man (hy3 just for that? seems unstable too)

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("__GL_SYNC_TO_VBLANK", "0")

local mainMod = "SUPER + " -- Sets "Windows" key as main modifier
local shiftMod = "SHIFT + "
local ctrlMod = "CTRL + "
local altMod = "ALT + "

-- Keep in sync with toggle-monitors
local m_center = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS FI32U 20480B000000"
local m_left = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS AD27QD 19050B000191"
local m_right = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS AD27QD 19050B000199"
local m_top = "GIGA-BYTE TECHNOLOGY CO. LTD. AORUS AD27QD 19050B000068"

-- {{{ Monitors

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
    transform = 0,
})

-- }}}
---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local hy3 = hl.plugin.hy3

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

        layout = "dwindle",
    },

    debug = {
        disable_logs = false,
        -- watchdog_timeout = 10,
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

    plugin = {
        hy3 = {
            -- tab_first_window = true,
            tabs = {
                height = 20,
                padding = 0,
                radius = 0,
                text_height = 10,
                colors = {
                    active = "rgba(285577ce)",
                    active_border = "rgba(33ccffc0)",
                    active_text = "rgba(ffffffff)",

                    active_alt_monitor = "rgba(000000bf)",
                    active_alt_monitor_border = "rgba(33ccffc0)",
                    active_alt_monitor_text = "rgba(ffffffff)",

                    focused = "rgba(000000bf)",
                    focused_border = "rgba(33ccffc0)",
                    focused_text = "rgba(ffffffff)",

                    inactive = "rgba(000000bf)",
                    inactive_border = "rgba(000000df)",
                    inactive_text = "rgba(ffffffff)",
                },
            },
        },
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
hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 4.1,
    spring = "easy",
    style = "popin 87%",
})
hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 1.49,
    bezier = "linear",
    style = "popin 87%",
})
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({
    leaf = "layersIn",
    enabled = true,
    speed = 4,
    bezier = "easeOutQuint",
    style = "fade",
})
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})
hl.animation({
    leaf = "workspacesIn",
    enabled = true,
    speed = 1.21,
    bezier = "almostLinear",
    style = "fade",
})
hl.animation({
    leaf = "workspacesOut",
    enabled = true,
    speed = 1.94,
    bezier = "almostLinear",
    style = "fade",
})
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0, no_border = true })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0, no_border = true })
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

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        force_split = 2,
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
        column_width = 0.5,
        -- focus_fit_method = 0,
        wrap_swapcol = false,
        wrap_focus = false,
        follow_min_visible = 0.0,
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo = true, -- If true disables the random hyprland logo / anime girl background. :(
        disable_splash_rendering = true,
        mouse_move_focuses_monitor = false,
        render_unfocused_fps = 120,
        -- enable_swallow = true,
        -- swallow_regex = "^(Alacritty)$",
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

        touchpad = {
            natural_scroll = false,
        },

        accel_profile = "flat",
        sensitivity = -0.66,
        float_switch_override_focus = 0,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})
-- }}} Input
-- {{{ Application Overrides
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
    match = { class = "org.mozilla.firefox" },
    workspace = "name:firefox",
})
hl.workspace_rule({
    workspace = "name:firefox",
    monitor = "desc:" .. m_center,
    default = true,
})
hl.bind(mainMod .. "Z", hl.dsp.focus({ workspace = "name:firefox" }))
hl.bind(
    mainMod .. shiftMod .. "Z",
    hl.dsp.window.move({ workspace = "name:firefox", follow = false })
)

-- hl.workspace_rule({
--     workspace = "name:test",
--     -- My 1.5x scale monitor
--     monitor = "desc:" .. m_center,
-- })
-- hl.window_rule({
--     match = { title = "XDG Subsurface Scale Test" },
--     workspace = "name:test",
-- })
--
hl.workspace_rule({
    workspace = "name:mpv",
    monitor = "desc:" .. m_center,
})
hl.window_rule({
    match = { class = "mpv" },
    workspace = "name:mpv",
    float = true,
    opaque = true,
    no_anim = true,
    border_size = 0,
    render_unfocused = true,
    -- animation = false,
    -- pseudo = true,
})
--for_window [app_id="calibre-gui"] floating enable
--for_window [app_id="gamescope"] floating enable-
--for_window [app_id="emuera.*"] border none, floating enable

-- hl.window_rule({
--     match = { class = ".*" },
--     no_initial_focus = true,
-- })
hl.window_rule({
    match = { class = "^emuera.*" },
    float = true,
})

hl.window_rule({
    match = { title = ".*Weechat.*" },
    workspace = "name:chat",
})
hl.window_rule({
    match = { class = "com.slack.Slack" },
    workspace = "name:chat",
})
hl.workspace_rule({
    workspace = "name:chat",
    monitor = "desc:" .. m_right,
    -- layout = "master",
})
hl.bind(mainMod .. "C", hl.dsp.focus({ workspace = "name:chat" }))
hl.bind(mainMod .. shiftMod .. "C", hl.dsp.window.move({ workspace = "name:chat", follow = false }))
-- assign [class="Slack"] $wsct
-- assign [class="TeamSpeak 3"] $wsct
-- workspace $wsct output $m_right
--
-- set $wsst "steam"
-- bindsym $mod+Mod1+t workspace $wsst
-- for_window [class="steam"] move container to workspace $wsst
-- for_window [class="steam"] floating enable
-- for_window [class="Steam"] move container to workspace $wsst
-- for_window [class="Steam"] floating enable
-- workspace $wsst output $m_center
--
-- set $wsnm "aw-fm"
-- assign [class="Caja"] $wsnm
-- assign [class="aw-fm"] $wsnm
-- for_window [class="Caja"] focus
-- for_window [class="aw-fm"] focus
-- bindsym $mod+x workspace $wsnm
-- workspace $wsnm output $m_left
hl.window_rule({
    match = { class = "^awused\\.aw-man$" },
    workspace = "name:aw-man",
    scrolling_width = 1.0,
    no_initial_focus = true,
})
hl.workspace_rule({
    workspace = "name:aw-man",
    gaps_out = 0,
    gaps_in = 0,
    border_size = 0,
    no_border = true,
    -- layout = "master",
    -- layout = "scrolling",
    layout = hy3 and "hy3" or "scrolling",
    monitor = "desc:" .. m_center,
    no_shadow = true,
})

hl.bind(
    mainMod .. shiftMod .. "K",
    hl.dsp.exec_cmd("~/.config/hypr/exec-once 'org.keepassxc.KeePassXC' keepassxc")
)

hl.bind(
    mainMod .. shiftMod .. "F",
    hl.dsp.exec_cmd(
        '~/.config/hypr/exec-once "foobar2000.exe" "wine144 foobar2000.exe" "$HOME/.foobar2000"'
    )
)

hl.window_rule({
    match = { class = "net-runelite-client-RuneLite", initial_title = "RuneLite" },
    float = true,
    no_shadow = true,
    border_size = 0,
    -- 1701/1200 / 1.5 scale + sidebar
    size = { 1295, 800 },
})

-- All the one-off floating windows
hl.window_rule({
    match = { class = "(KADOKAWA/RPGMV)|(foobar2000.exe)|(org.keepassxc.KeePassXC)" },
    float = true,
})
hl.window_rule({
    match = { class = "(BoltLauncher)" },
    float = true,
    no_shadow = true,
    border_size = 0,
})

-- }}}
-- {{{ Keybindings

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. "RETURN", hl.dsp.exec_cmd("/home/desuwa/bin/desu-terminal"))
hl.bind(
    mainMod .. shiftMod .. "RETURN",
    hl.dsp.exec_cmd(
        "gnome-terminal || xfce4-terminal || "
            .. "urxvt || foot || kitty || alacritty || i3-sensible-terminal"
    )
)

hl.bind(mainMod .. shiftMod .. "Q", hl.dsp.window.close())

hl.bind(mainMod .. "D", hl.dsp.exec_cmd("rofi -modi drun,run -show drun"))
hl.bind(mainMod .. shiftMod .. "S", hl.dsp.exec_cmd("rofi -modi ssh -show ssh"))

hl.bind(
    altMod .. shiftMod .. "E",
    hl.dsp.exec_cmd(
        "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown ||"
            .. " hyprctl dispatch 'hl.dsp.exit()'"
    )
)

hl.bind(mainMod .. shiftMod .. "Space", hl.dsp.window.float({ action = "toggle" }))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. "J", function()
    local workspace = hl.get_active_workspace()

    if not workspace then
        return
    elseif workspace.tiled_layout == "scrolling" then
        hl.dispatch(hl.dsp.layout("consume_or_expel next"))
    elseif workspace.tiled_layout == "dwindle" then
        hl.dispatch(hl.dsp.layout("togglesplit"))
    end
end)
hl.bind(mainMod .. shiftMod .. "J", function()
    -- Cycle workspace layouts
    local workspace = hl.get_active_workspace()
    if not workspace then
        return
    end

    local layouts = { "dwindle", "scrolling", "monocle" }
    for i, l in pairs(layouts) do
        if l == workspace.tiled_layout then
            local rule = "'hl.workspace_rule({ workspace = \""
                .. workspace.id
                .. '", layout = "'
                .. layouts[i % #layouts + 1]
                .. "\" })'"
            hl.dispatch(hl.dsp.exec_cmd("hyprctl eval " .. rule))
        end
    end
end)

--- {{{ Custom movement methods
-- group > monocole or scrolling workspace > regular focus
function focus_left_right(dir)
    local win = hl.get_active_window()
    local grp = win and win.group

    local workspace = hl.get_active_workspace()

    if grp then
        local idx = grp.current_index
        if not ((idx == 1 and dir == "left") or (idx == grp.size and dir == "right")) then
            if dir == "left" then
                print("group left")
                idx = idx - 1
            else
                print("group right")
                idx = idx + 1
            end

            hl.dispatch(hl.dsp.group.active({ index = idx }))
            return
        end
    end

    if not win or win.floating then
        print("Floating window, ignoring workspace")
    elseif workspace and workspace.tiled_layout == "scrolling" then
        local windows = hl.get_windows()
        local min_x = win.at.x
        local max_x = win.at.x + win.size.x

        for k, w in pairs(windows) do
            if w.workspace.id == workspace.id and w.floating == false and w.hidden == false then
                if w.at.x < min_x and dir == "left" then
                    print("scrolling focus left")
                    hl.dispatch(hl.dsp.layout("focus left"))
                    return
                elseif w.at.x + w.size.x > max_x and dir == "right" then
                    print("scrolling focus right")
                    hl.dispatch(hl.dsp.layout("focus right"))
                    return
                end
            end
        end
    elseif workspace and workspace.tiled_layout == "monocle" then
        local windows = hl.get_windows()

        local first = true
        local found = false
        local last = true
        for k, w in pairs(windows) do
            if w.workspace.id == workspace.id and w.hidden == false and w.floating == false then
                last = not found

                if w.address == win.address then
                    found = true
                    if first and dir == "left" then
                        break
                    end
                end

                first = false
            end
        end

        if dir == "left" and not first then
            print("monocle cyceprev")
            -- hl.dispatch(hl.dsp.window.cycle_prev({ tiled = true }))
            hl.dispatch(hl.dsp.layout("cycleprev"))
            return
        elseif dir == "right" and not last then
            print("monocle cyclenext")
            hl.dispatch(hl.dsp.layout("cyclenext"))
            -- hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
            return
        end
    elseif workspace and workspace.tiled_layout == "hy3" and hy3 then
        hl.dispatch(hy3.move_focus(dir, { warp = false }))
        -- hl.dispatch(hy3.focus_tab({ direction = dir }))
        return
    end

    hl.dispatch(hl.dsp.focus({ direction = dir }))
end

-- TODO
function move_left_right(dir)
    local win = hl.get_active_window()
    local grp = win and win.group

    local workspace = hl.get_active_workspace()

    if grp then
        local idx = grp.current_index
        if not ((idx == 1 and dir == "left") or (idx == grp.size and dir == "right")) then
            hl.dispatch(hl.dsp.group.move_window({ forward = (dir == "right") }))
            return
        end
    end

    if not win or win.floating then
        print("Floating window, ignoring workspace")
    elseif workspace and workspace.tiled_layout == "scrolling" then
        local windows = hl.get_windows()
        local min_x = win.at.x
        local max_x = win.at.x + win.size.x

        -- TODO
        for k, w in pairs(windows) do
            if w.workspace.id == workspace.id and w.floating == false and w.hidden == false then
                if w.at.x < min_x and dir == "left" then
                    print("scrolling focus left")
                    hl.dispatch(hl.dsp.layout("focus left"))
                    return
                elseif w.at.x + w.size.x > max_x and dir == "right" then
                    print("scrolling focus right")
                    hl.dispatch(hl.dsp.layout("focus right"))
                    return
                end
            end
        end
    elseif workspace and workspace.tiled_layout == "monocle" then
        -- TODO There is currently no way to cycle windows in monocle
        -- local windows = hl.get_windows()
        --
        -- local first = true
        -- local found = false
        -- local last = true
        -- for k, w in pairs(windows) do
        --     if w.workspace.id == workspace.id and w.hidden == false and w.floating == false then
        --         last = not found
        --
        --         if w.address == win.address then
        --             found = true
        --             if first and dir == "left" then
        --                 break
        --             end
        --         end
        --
        --         first = false
        --     end
        -- end
        --
        -- if dir == "left" and not first then
        --     print("monocle cyceprev")
        --     hl.dispatch(hl.dsp.layout("cycleprev"))
        --     return
        -- elseif dir == "right" and not last then
        --     print("monocle cyclenext")
        --     hl.dispatch(hl.dsp.layout("cyclenext"))
        --     return
        -- end
    end

    hl.dispatch(hl.dsp.window.move({ direction = dir }))
end

local function dispatch_if_hy3(disp)
    return function()
        local workspace = hl.get_active_workspace()
        if not workspace or workspace.tiled_layout ~= "hy3" then
            return
        end

        hl.dispatch(disp)
    end
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
-- }}}
-- if hy3 then
--     hl.bind(mainMod .. "left", hy3.move_focus("left", { warp = false }))
--     hl.bind(mainMod .. "right", hy3.move_focus("right", { warp = false }))
--     hl.bind(mainMod .. "up", hy3.move_focus("up"))
--     hl.bind(mainMod .. "down", hy3.move_focus("down"))
--
-- hl.bind(mainMod .. shiftMod .. "left", hl.dsp.window.move({ direction = "left" }))
-- hl.bind(mainMod .. shiftMod .. "right", hl.dsp.window.move({ direction = "right" }))
-- hl.bind(mainMod .. shiftMod .. "up", hl.dsp.window.move({ direction = "up" }))
-- hl.bind(mainMod .. shiftMod .. "down", hl.dsp.window.move({ direction = "down" }))
-- else
-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. "left", function()
    focus_left_right("left")
end)
hl.bind(mainMod .. "right", function()
    focus_left_right("right")
end)
hl.bind(mainMod .. "up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. "down", hl.dsp.focus({ direction = "down" }))

-- TODO -- move left/right overrides
hl.bind(mainMod .. shiftMod .. "left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. shiftMod .. "right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. shiftMod .. "up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. shiftMod .. "down", hl.dsp.window.move({ direction = "down" }))

if hy3 then
    hl.bind(mainMod .. "W", dispatch_if_hy3(hy3.change_group("toggletab")))
    hl.bind(mainMod .. "E", dispatch_if_hy3(hy3.change_group("opposite")))
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

-- }}}

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
        use_nearest_neighbor = true,
    },
})

hl.window_rule({
    name = "forced-float",
    match = { title = "^aw-i3-forced-float$" },

    float = true,
})

-- hl.workspace_rule({ workspace = "special:scratchpad", animation = "no" })

-- {{{ AUTOSTART

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--

hl.on("hyprland.start", function()
    hl.exec_cmd("mako")
    hl.exec_cmd("wallpapers daemon")
    hl.exec_cmd("waybar")
    -- TODO: vmprpc, mpd, mpd-shuffler, udevadm trigger

    hl.exec_cmd("hyprpm reload")
    hl.exec_cmd("xdg-desktop-portal-aw-fm")
    -- Enable in sudoers with
    -- desuwa ALL=(root) NOPASSWD:/usr/bin/nvidia-smi -i 0 -pl 375
    hl.exec_cmd("sudo /usr/bin/nvidia-smi -i 0 -pl 375")
end)

-- }}}
