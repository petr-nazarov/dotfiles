-- Push-to-talk for voxtype: hold cmd+m to record, release to transcribe and type.
-- Lives here and not in skhd because skhd only sees key presses, never releases.
-- voxtype's own hotkey is off (infrastructure repo, darwin/gui_apps).
hs.autoLaunch(true)
hs.menuIcon(false)

local voxtype = "/opt/homebrew/bin/voxtype"
local function record(action)
  return function()
    hs.task.new(voxtype, nil, { "record", action }):start()
  end
end

hs.hotkey.bind({ "cmd" }, "m", record("start"), record("stop"))
