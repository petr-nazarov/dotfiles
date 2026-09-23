-- Push-to-talk for voxtype: hold cmd+m to record, release to transcribe and type.
-- Lives here and not in skhd because skhd only sees key presses, never releases.
-- voxtype's own hotkey is off (infrastructure repo, darwin/gui_apps).
hs.autoLaunch(true)
hs.menuIcon(false)

local voxtype = "/opt/homebrew/bin/voxtype"
local recording = false
local function record(action)
  hs.task.new(voxtype, nil, { "record", action }):start()
end
local function start()
  if not recording then
    recording = true
    record("start")
  end
end
local function stop()
  if recording then
    recording = false
    record("stop")
  end
end

-- Letting go of either key stops. The hotkey's own release can miss cmd coming up a moment
-- before m, and the recording runs on, so this tap watches both keys while recording.
-- Global, so the garbage collector doesn't stop the tap.
local types = hs.eventtap.event.types
voxtypeRelease = hs.eventtap.new({ types.keyUp, types.flagsChanged }, function(event)
  if recording then
    if event:getType() == types.flagsChanged then
      if not event:getFlags().cmd then
        stop()
      end
    elseif event:getKeyCode() == hs.keycodes.map.m then
      stop()
    end
  end
  return false
end)
voxtypeRelease:start()

hs.hotkey.bind({ "cmd" }, "m", start, stop)
