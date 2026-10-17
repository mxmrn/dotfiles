-- -----------------------------------------------------
-- Hyprland Lua config
-- Device-specific settings live in local.lua (gitignored).
-- -----------------------------------------------------

local HOME    = os.getenv("HOME")
local DOTS    = HOME .. "/dotfiles/config/hypr"
local mainMod = "SUPER"

-- -----------------------------------------------------
-- Colors (matugen writes hyprlang `$name = value` lines)
-- -----------------------------------------------------

local function readHyprlangVars(path)
    local vars = {}
    local f    = io.open(path, "r")
    if not f then
        return vars
    end
    for line in f:lines() do
        local k, v = line:match("^%s*%$([%w_]+)%s*=%s*(.-)%s*$")
        if k then
            vars[k] = v
        end
    end
    f:close()
    return vars
end

local colors = readHyprlangVars(HOME .. "/.cache/colors-hyprland.conf")

-- -----------------------------------------------------
-- Default applications (defaults.conf)
-- -----------------------------------------------------

local apps = {
    TERMINAL          = "kitty",
    BROWSER           = "zen-browser",
    FILEMANAGER       = "nautilus",
    EDITOR            = "mousepad",
    NETWORKMANAGER    = "nm-connection-editor",
    SOFTWARE          = "alacritty -e pacseek",
    SCREENSHOT_EDITOR = "satty",
    WALLPAPER_ENGINE  = "awww",
    BLUR              = "50x30",
}

for k, v in pairs(apps) do
    hl.env(k, v)
end

-- -----------------------------------------------------
-- Environment (environment.conf)
-- -----------------------------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("GDK_SCALE", "1")
hl.env("GTK_THEME", "adw-gtk3-dark")
-- Отключить DCC-сжатие буферов: chromium/Electron egl_dmabuf не умеет
-- импортировать многоплоскостные DCC-модификаторы (EGL_BAD_MATCH),
-- из-за чего ломается screenshare в Vesktop/Discord.
hl.env("AMD_DEBUG", "nodcc")

-- -----------------------------------------------------
-- Monitors (monitor.conf; per-device overrides in local.lua)
-- -----------------------------------------------------

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- -----------------------------------------------------
-- Autostart (autostart.conf, cursor.conf)
-- -----------------------------------------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service || /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("wl-clip-persist --clipboard regular")
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("sleep 1 && kitty --class dropdown-terminal")
    hl.exec_cmd(DOTS .. "/scripts/autostart.sh")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice-Static 24")
end)

-- -----------------------------------------------------
-- Look and feel (window, decoration, layout, misc)
-- -----------------------------------------------------

hl.config({
    general = {
        gaps_in     = 6,
        gaps_out    = 14,
        border_size = 0,
        col = {
            active_border   = colors.primary or "rgba(adc6ffff)",
            inactive_border = "rgba(ffffffff)",
        },
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        blur = {
            enabled           = true,
            size              = 8,
            passes            = 3,
            new_optimizations = true,
            ignore_opacity    = true,
            xray              = true,
        },
        active_opacity     = 0.99,
        inactive_opacity   = 0.98,
        fullscreen_opacity = 1.0,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        vrr                      = 2,
    },

    animations = {
        enabled = true,
    },
})

-- -----------------------------------------------------
-- Input (keyboard.conf)
-- -----------------------------------------------------

hl.config({
    input = {
        kb_layout          = "us, ru",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "grp:alt_shift_toggle",
        numlock_by_default = true,
        mouse_refocus      = false,
        follow_mouse       = 1,
        sensitivity        = 0,
        accel_profile      = "flat",
        touchpad = {
            natural_scroll = false,
        },
        touchdevice = {
            enabled = false,
        },
    },
})

-- -----------------------------------------------------
-- Animations (animation.conf)
-- -----------------------------------------------------

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier", style = "slide" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default",  style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

-- -----------------------------------------------------
-- Keybindings (keybinding.conf)
-- -----------------------------------------------------

local function exec(cmd)
    return hl.dsp.exec_cmd(cmd)
end

-- Applications
hl.bind("CTRL + ALT + T", exec(apps.TERMINAL))
hl.bind(mainMod .. " + B", exec(apps.BROWSER))
hl.bind(mainMod .. " + E", exec(apps.FILEMANAGER))

-- Windows
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.resize({ x = 100,  y = 0,    relative = true }))
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.resize({ x = -100, y = 0,    relative = true }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.resize({ x = 0,    y = -100, relative = true }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.resize({ x = 0,    y = 100,  relative = true }))
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.window.move({ direction = "down" }))

-- Monitors
hl.bind(mainMod .. " + ALT + left",  hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + ALT + right", hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. " + ALT + SHIFT + left",  hl.dsp.window.move({ monitor = "-1" }))
hl.bind(mainMod .. " + ALT + SHIFT + right", hl.dsp.window.move({ monitor = "+1" }))

-- Special workspaces
hl.bind(mainMod .. " + grave",         hl.dsp.workspace.toggle_special("dropdown"))
hl.bind(mainMod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:dropdown" }))

-- ClaudeCode
hl.bind("ALT + C", exec(DOTS .. "/scripts/screenshot_claude.sh"))
hl.bind(mainMod .. " + SHIFT + P", exec("kitty --class=claude-kitty --listen-on unix:/tmp/kitty-claude -e claude"))
hl.bind("ALT + V", exec([[f="$XDG_RUNTIME_DIR/cheating-claude.pid"; [ -f "$f" ] && kill -USR1 "$(cat "$f")"]]))

-- Actions
hl.bind("PRINT", exec(DOTS .. "/scripts/screenshot.sh"))
hl.bind(mainMod .. " + PRINT", exec(DOTS .. "/scripts/screenshot.sh area"))
hl.bind(mainMod .. " + CTRL + Q", exec("wlogout -b 6 -c 16 -r 0 -T 450 -B 450 -L 200 -R 200"))
hl.bind(mainMod .. " + SHIFT + W", exec(DOTS .. "/scripts/wallpaper.sh scheme"))
hl.bind(mainMod .. " + CTRL + W", exec(DOTS .. "/scripts/wallpaper.sh select"))
hl.bind("ALT + SPACE", exec("rofi -show drun -replace -i"))
hl.bind(mainMod .. " + SHIFT + C", exec("hyprpicker -a -n"))
hl.bind(mainMod .. " + SHIFT + B", exec("systemctl --user restart waybar"))
hl.bind(mainMod .. " + V", exec(HOME .. "/dotfiles/scripts/cliphist.sh"))

-- Fn keys
hl.bind("XF86MonBrightnessUp",   exec("brightnessctl -q s +10%"))
hl.bind("XF86MonBrightnessDown", exec("brightnessctl -q s 10%-"))
hl.bind("XF86AudioRaiseVolume",  exec("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"))
hl.bind("XF86AudioLowerVolume",  exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"))
hl.bind("XF86AudioMute",         exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioPlay",         exec("playerctl play-pause"))
hl.bind("XF86AudioPause",        exec("playerctl pause"))
hl.bind("XF86AudioNext",         exec("playerctl next"))
hl.bind("XF86AudioPrev",         exec("playerctl previous"))
hl.bind("XF86AudioMicMute",      exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86Calculator",        exec("qalculate-gtk"))
-- XF86Lock is not a known keysym here ("Unknown key"), so it is left out:
-- hl.bind("XF86Lock", exec("hyprlock"))
hl.bind("XF86Tools",             exec("alacritty --class dotfiles-floating -e ~/dotfiles/config/hypr/settings/settings.sh"))

-- Passthrough SUPER key to a virtual machine
hl.bind(mainMod .. " + P", hl.dsp.submap("passthru"))
hl.define_submap("passthru", function()
    hl.bind("SUPER + Escape", hl.dsp.submap("reset"))
end)

-- -----------------------------------------------------
-- Window / layer rules (windowrule.conf)
-- -----------------------------------------------------

hl.window_rule({ name = "chromium-tile",     match = { title = "^(Chromium)$" },            tile  = true })
hl.window_rule({ name = "pavucontrol-float", match = { title = "^(pavucontrol)$" },         float = true })
hl.window_rule({ name = "nm-editor-float",   match = { title = "^(nm-connection-editor)$" }, float = true })
hl.window_rule({ name = "firefox-float",     match = { class = "firefox" },                 float = true })

-- Dropdown terminal
hl.window_rule({
    name      = "dropdown-terminal",
    match     = { class = "dropdown-terminal" },
    workspace = "special:dropdown silent",
    float     = true,
    size      = { "monitor_w*0.80", "monitor_h*0.60" },
    center    = true,
})

-- Wlogout blur
hl.layer_rule({ name = "wlogout-blur", match = { namespace = "wlogout" }, blur = true, ignore_alpha = 0.3 })

-- Hide claude TUI from screen capture.
-- "exclude" (see-through) only exists in the dev build (~/Development/Hyprland);
-- the packaged Hyprland only knows the boolean form (black box).
local function isDevBuild()
    local p = io.popen("readlink /proc/$PPID/exe")
    if not p then
        return false
    end
    local exe = p:read("*l") or ""
    p:close()
    return exe:find("/Development/Hyprland/", 1, true) ~= nil
end

hl.window_rule({
    name            = "claude-no-screenshare",
    match           = { class = "claude-kitty" },
    no_screen_share = isDevBuild() and "exclude" or true,
})

-- -----------------------------------------------------
-- Device-specific configuration (local.lua, optional)
-- -----------------------------------------------------

local ok, err = pcall(require, "local")
if not ok and not tostring(err):find("module 'local' not found", 1, true) then
    error(err)
end

-- -----------------------------------------------------
-- Default workspace binds (skipped when local.lua set up
-- split-monitor-workspaces, which binds the same keys)
-- -----------------------------------------------------

if not package.loaded["plugins.split-monitor-workspaces"] then
    for i = 1, 10 do
        local key = tostring(i % 10)
        hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
        hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i, follow = false }))
    end

    hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
    hl.bind(mainMod .. " + page_down",  hl.dsp.focus({ workspace = "empty" }))
end
