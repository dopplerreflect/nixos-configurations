local terminal    = "kitty"
local browser     = "firefox"
local filemanager = "nautilus"

local screenshotFolder = "/home/doppler/Pictures/Screenshots"

hl.monitor({
  output   = "eDP-1",
  mode     = "1920x1080",
  position = "0x0",
  scale    = 1,
})

hl.monitor({
  output   = "DP-1",
  mode     = "1920x1080",
  position = "auto-center-up",
  scale    = 1,
})

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd --all")
  hl.exec_cmd("systemctl --user restart hypridle.service")
  hl.exec_cmd("echo -n bb | gnome-keyring-daemon --replace --unlock")
  hl.exec_cmd("systemctl --user restart hypridle.service")
  hl.exec_cmd("ags")
  -- hl.exec_cmd("swaync") # already running?
  hl.exec_cmd("awww-daemon")
  hl.exec_cmd(terminal)
end)

hl.config({
  decoration = {
    rounding = 5,
    shadow = {
      enabled      = true;
      range        = 8,
      render_power = 1,
      color        = 0xee1a1a1a,
    },
  },
  general = {
    gaps_in     = 2,
    gaps_out    = 5,
    border_size = 1,
    col = {
      active_border = { colors = {"rgba(ff0000e6)", "rgba(ff5900e6)", "rgba(fff900e6)", "rgba(00ff72e6)", "rgba(0093eee6)", "rgba(4300ffe6)"}, angle = 137.5},
      inactive_border = { colors = {"rgba(ffffff33)", "rgba(0000ff88)"}, angle = 90},
    },
  },
  input = {
    kb_layout  = "us",
    kb_variant = "dvorak",
    kb_options = "caps:ctrl_modifier",

    touchpad = {
      natural_scroll       = true,
      clickfinger_behavior = true,
    },
  },
})

hl.bind("SUPER + Q",             hl.dsp.window.close())
hl.bind("SUPER + B",             hl.dsp.exec_cmd(browser))
hl.bind("SUPER + Return",        hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + F",             hl.dsp.exec_cmd(filemanager))
hl.bind("SUPER + SPACE",         hl.dsp.exec_cmd("ags -r \"App.openWindow('app-launcher')\""))
hl.bind("SUPER + SHIFT + L",     hl.dsp.exec_cmd("ags -r \"openSystemControls()\""))
hl.bind("SUPER + SHIFT + B",     hl.dsp.exec_cmd("ags -t bar"))

hl.bind("SUPER + left",          hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right",         hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",            hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",          hl.dsp.focus({ direction = "down" }))

hl.bind("SUPER + SHIFT + left",  hl.dsp.window.move({ direction = "left"}))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right"}))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.move({ direction = "up"}))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.move({ direction = "down"}))


hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("ags -r 'openVolumePopup()' & wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true})
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("ags -r 'openVolumePopup()' & wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true})

hl.bind("SUPER + PRINT", hl.dsp.exec_cmd("hyprshot -o " .. screenshotFolder .. " -m output -m active"))
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("hyprshot -o " .. screenshotFolder .. " -m region"))
hl.bind("PRINT",         hl.dsp.exec_cmd("hyprshot -o " .. screenshotFolder .. " -m window -m active"))

hl.gesture({
  fingers   = 4,
  direction = "horizontal",
  action    = "workspace",
})

for i = 1, 10 do
  local key = i % 10 -- 10 maps to key 0
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i}))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
  local monitor = (i < 3) and "eDP-1" or "DP-1"
  local persistent = (i < 4)
  hl.workspace_rule({ workspace = i, monitor = monitor, persistent = persistent })
end

-- hl.workspace_rule({ workspace = "1", monitor = "eDP-1", persistent = true })
-- hl.workspace_rule({ workspace = "2", monitor = "eDP-1", persistent = true })
