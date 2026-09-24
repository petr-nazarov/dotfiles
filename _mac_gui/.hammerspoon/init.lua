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

-- LLM cleanup switch in the menu bar, the mac side of the waybar voxtype-cleanup-status
-- module: wand when dictations go through the local model, text when the raw transcript is
-- typed, yellow when cleanup is on but Ollama or the model is missing. A click flips
-- voxtype-postprocess's off switch, read on every dictation, so it applies at once and
-- survives Ansible runs. darwin_voxtype_llm_enabled (infrastructure) decides whether the
-- LLM is set up at all: it passes --llm to voxtype-postprocess in voxtype's config.
local home = os.getenv("HOME")
local voxtypeConfig = home .. "/Library/Application Support/voxtype/config.toml"
-- Same path voxtype-postprocess reads
local llmOff = (os.getenv("XDG_STATE_HOME") or home .. "/.local/state") .. "/voxtype/llm-off"
local wand = utf8.char(0xF0068) -- nf-md-auto_fix
local text = utf8.char(0xF09A8) -- nf-md-text

-- (speech model, llm model or nil), or nil when voxtype is not set up
local function readVoxtypeConfig()
  local file = io.open(voxtypeConfig)
  if not file then
    return nil
  end
  local config = file:read("a")
  file:close()
  return config:match('\nmodel = "([^"]+)"') or "?", config:match("%-%-llm%s+([^%s\"]+)")
end

-- Global, so the garbage collector doesn't take the menu bar item
voxtypeCleanup = hs.menubar.new()
local function show(icon, color, tooltip)
  voxtypeCleanup:setTitle(hs.styledtext.new(icon, {
    font = { name = "Symbols Nerd Font Mono", size = 15 },
    color = color or { list = "System", name = "labelColor" },
  }))
  voxtypeCleanup:setTooltip(tooltip)
end

local function refreshCleanup()
  local whisper, llm = readVoxtypeConfig()
  if not whisper then
    show(text, nil, "Voxtype is not set up")
  elseif not llm then
    show(text, nil, "Raw transcript: typed as spoken\nSpeech: " .. whisper .. "\nLLM: not set up (darwin_voxtype_llm_enabled)")
  elseif hs.fs.attributes(llmOff) then
    show(text, nil, "Raw transcript: typed as spoken\nSpeech: " .. whisper .. "\nLLM: " .. llm .. ", off\nClick to turn LLM cleanup on")
  else
    hs.http.asyncGet("http://127.0.0.1:11434/api/tags", nil, function(status, body)
      local problem
      if status ~= 200 then
        problem = "Ollama is not running"
      else
        problem = llm .. " is not pulled"
        for _, model in ipairs((hs.json.decode(body) or {}).models or {}) do
          if model.name == llm or model.name == llm .. ":latest" then
            problem = nil
          end
        end
      end
      if problem then
        show(wand, { list = "System", name = "systemYellowColor" }, "LLM cleanup: on, but " .. problem .. ", so the raw transcript is typed\nSpeech: " .. whisper .. "\nLLM: " .. llm .. "\nClick to type raw transcripts")
      else
        show(wand, nil, "LLM cleanup: on\nSpeech: " .. whisper .. "\nLLM: " .. llm .. "\nClick to type raw transcripts")
      end
    end)
  end
end

voxtypeCleanup:setClickCallback(function()
  local _, llm = readVoxtypeConfig()
  if not llm then
    hs.alert.show("No LLM is set up: turn on darwin_voxtype_llm_enabled and run the playbook")
  elseif hs.fs.attributes(llmOff) then
    os.remove(llmOff)
  else
    hs.fs.mkdir(home .. "/.local/state")
    hs.fs.mkdir(home .. "/.local/state/voxtype")
    io.open(llmOff, "w"):close()
  end
  refreshCleanup()
end)
refreshCleanup()
-- Picks up Ollama going down and playbook runs; global so the timer isn't collected
voxtypeCleanupTimer = hs.timer.doEvery(30, refreshCleanup)
