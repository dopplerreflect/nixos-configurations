hl.exec_cmd("echo -n bb | gnome-keyring-daemon --replace --unlock")
hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

local volume_gesture = function(change) hl.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ " .. math.abs(change) .. "%" .. (change<0 and "-" or "+")) end

hl.gesture({
  fingers = 3,
  direction = "vertical",
  action = {
    start = function(e) volume_gesture(-0.25 * e.delta.y) end,
    update = function(e) volume_gesture(-0.25 * e.delta.y) end
  }
})

hl.config({
  input = {
    kb_variant = "dvorak",
    kb_options = "caps:ctrl_modifier",
  }
})
hl.window_rule({ match = { class = "^mpv$" }, fullscreen = true })

require('dms.hyprland')
