-- Push-to-talk for voxtype: hold cmd+m to record, release to transcribe and type.
-- Lives here and not in skhd because skhd only sees key presses, never releases.
-- voxtype's own hotkey is off (infrastructure repo, darwin/gui_apps).
hs.autoLaunch(true)
hs.menuIcon(false)

require("jk")

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

-- Dictation in the menu bar, the mac side of waybar's dictation button and net-popover's
-- Dictation panel. One item shows where speech is transcribed (chip: this mac, server: the
-- desktop's voxtype server) and whether dictations get LLM cleanup (wand) or are typed raw
-- (text), yellow when something is wrong; its menu switches both.
-- LLM cleanup flips voxtype-postprocess's off switch, read on every dictation, so it applies at
-- once and survives Ansible runs. darwin_voxtype_llm_enabled (infrastructure) decides whether the
-- LLM is set up at all: it passes --llm to voxtype-postprocess in voxtype's config.
-- voxtype-target (dotfiles _common_gui) reports where speech goes as waybar JSON and does the
-- switch, which restarts voxtype.
local home = os.getenv("HOME")
local voxtypeConfig = home .. "/Library/Application Support/voxtype/config.toml"
-- Same path voxtype-postprocess reads
local llmOff = (os.getenv("XDG_STATE_HOME") or home .. "/.local/state") .. "/voxtype/llm-off"
local target = home .. "/.local/bin/voxtype-target"
local wand = utf8.char(0xF0068) -- nf-md-auto_fix
local text = utf8.char(0xF09A8) -- nf-md-text
local chip = utf8.char(0xF061A) -- nf-md-chip
local yellow = { list = "System", name = "systemYellowColor" }

-- The [whisper] table's quoted settings: model, and mode / remote_endpoint / remote_api_key
-- while voxtype-target has voxtype on the desktop's voxtype server
local function whisperSettings(config)
  local section = ("\n" .. config .. "\n["):match("\n%[whisper%]%s*\n(.-)\n%[") or ""
  local settings = {}
  for key, value in ("\n" .. section):gmatch('\n([%w_]+)%s*=%s*"([^"]*)"') do
    settings[key] = value
  end
  return settings
end

-- (speech model, llm model or nil, whisper settings), or nil when voxtype is not set up
local function readVoxtypeConfig()
  local file = io.open(voxtypeConfig)
  if not file then
    return nil
  end
  local config = file:read("a")
  file:close()
  local settings = whisperSettings(config)
  return settings.model or "?", config:match("%-%-llm%s+([^%s\"]+)"), settings
end

-- The two halves of the item: icon, color and tooltip, plus what the menu needs
local where = { icon = chip, tooltip = "" } -- problem: what is wrong with the voxtype server
local cleanup = { icon = text, tooltip = "" } -- problem: why cleanup can't run while it is on

-- Global, so the garbage collector doesn't take the menu bar item
dictation = hs.menubar.new()

local function styled(icon, color)
  return hs.styledtext.new(icon, {
    font = { name = "Symbols Nerd Font Mono", size = 15 },
    color = color or { list = "System", name = "labelColor" },
  })
end

-- The scripts' tooltips end in click hints for the bar; here clicks open the menu
local function withoutClickHints(tooltip)
  local lines = {}
  for line in (tooltip or ""):gmatch("[^\n]+") do
    if not line:match("^Click") then
      table.insert(lines, line)
    end
  end
  return table.concat(lines, "\n")
end

local function render()
  dictation:setTitle(styled(where.icon, where.color) .. styled(" ") .. styled(cleanup.icon, cleanup.color))
  dictation:setTooltip(withoutClickHints(where.tooltip) .. "\n\n" .. withoutClickHints(cleanup.tooltip))
end

local function setCleanup(icon, color, tooltip, problem)
  cleanup = { icon = icon, color = color, tooltip = tooltip, problem = problem }
  render()
end

local function refreshCleanup()
  local whisper, llm, settings = readVoxtypeConfig()
  -- voxtype-postprocess cleans up where voxtype transcribes
  local url, headers, place = "http://127.0.0.1:11434/api/tags", nil, "the local Ollama"
  if whisper and settings.mode == "remote" and settings.remote_endpoint then
    url = (settings.remote_endpoint:gsub("/$", "")) .. "/api/tags"
    headers = { Authorization = "Bearer " .. (settings.remote_api_key or "") }
    place = "the voxtype server"
    whisper = whisper .. ", on the voxtype server"
  end
  if not whisper then
    setCleanup(text, nil, "Voxtype is not set up")
  elseif not llm then
    setCleanup(text, nil, "Raw transcript: typed as spoken\nSpeech: " .. whisper .. "\nLLM: not set up (darwin_voxtype_llm_enabled)")
  elseif hs.fs.attributes(llmOff) then
    setCleanup(text, nil, "Raw transcript: typed as spoken\nSpeech: " .. whisper .. "\nLLM: " .. llm .. ", off")
  else
    hs.http.asyncGet(url, headers, function(status, body)
      local problem
      if status ~= 200 then
        problem = place .. " is not reachable"
      else
        problem = llm .. " is not pulled"
        for _, model in ipairs((hs.json.decode(body) or {}).models or {}) do
          if model.name == llm or model.name == llm .. ":latest" then
            problem = nil
          end
        end
      end
      if problem then
        setCleanup(wand, yellow, "LLM cleanup: on, but " .. problem .. ", so the raw transcript is typed\nSpeech: " .. whisper .. "\nLLM: " .. llm, problem)
      else
        setCleanup(wand, nil, "LLM cleanup: on\nSpeech: " .. whisper .. "\nLLM: " .. llm .. ", on " .. place)
      end
    end)
  end
end

local function refreshTarget(announce)
  hs.task.new(target, function(code, out)
    local state = code == 0 and hs.json.decode(out) or nil
    if not state or state.text == "" then
      where = { icon = chip, color = yellow, tooltip = "Voxtype is not set up" }
    else
      local degraded = state.class == "degraded"
      where = {
        icon = state.text,
        color = degraded and yellow or nil,
        tooltip = state.tooltip,
        problem = degraded and state.tooltip:match("^[^\n]-, but ([^\n]+)") or nil,
      }
      if announce then
        hs.alert.show(state.tooltip:match("^[^\n]+"))
      end
    end
    render()
  end, { "status" }):start()
end

local function switchTarget(mode)
  hs.task.new(target, function(code)
    if code ~= 0 then
      hs.alert.show("No voxtype server set up: set voxtype_server_url and run the playbook")
    end
    refreshTarget(code == 0)
    refreshCleanup()
  end, { mode }):start()
end

local function toggleCleanup()
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
end

-- The same restart voxtype-target does after a switch
local function restartVoxtype()
  hs.task.new("/bin/sh", function()
    refreshTarget()
    refreshCleanup()
  end, { "-c", "pkill -f /Applications/Voxtype.app/Contents/MacOS/; sleep 1; open -g /Applications/Voxtype.app" }):start()
end

-- Built on each click, so it shows the config as it is now
dictation:setMenu(function()
  local model, llm, settings = readVoxtypeConfig()
  if not model then
    return { { title = "Voxtype is not set up", disabled = true } }
  end
  local remote = settings.mode == "remote"
  local server = "Voxtype server"
  if not settings.remote_endpoint then
    server = server .. " (not set up: voxtype_server_url)"
  elseif remote and where.problem then
    server = server .. ": " .. where.problem
  end
  local cleanupOn = llm ~= nil and not hs.fs.attributes(llmOff)
  local llmLine
  if not llm then
    llmLine = "No LLM set up (darwin_voxtype_llm_enabled)"
  elseif cleanupOn and cleanup.problem then
    llmLine = cleanup.problem .. ": typing raw transcripts"
  else
    llmLine = llm .. (remote and " on the voxtype server" or " on this Mac")
  end
  return {
    { title = "Speech model: " .. model, disabled = true },
    { title = "-" },
    { title = "Transcribe On", disabled = true },
    { title = "This Mac", checked = not remote, fn = function()
      if remote then switchTarget("local") end
    end },
    { title = server, checked = remote, disabled = not settings.remote_endpoint, fn = function()
      if not remote then switchTarget("remote") end
    end },
    { title = "-" },
    { title = "LLM Cleanup", checked = cleanupOn, disabled = not llm, fn = toggleCleanup },
    { title = llmLine, disabled = true, indent = 1 },
    { title = "-" },
    { title = "Restart Voxtype", fn = restartVoxtype },
  }
end)

refreshTarget()
refreshCleanup()

-- Picks up Ollama or the voxtype server going down and playbook runs; global so the timer
-- isn't collected
voxtypeCleanupTimer = hs.timer.doEvery(30, function()
  refreshCleanup()
  refreshTarget()
end)
