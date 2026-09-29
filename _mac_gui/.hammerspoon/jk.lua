-- j and k pressed together type Escape, like the jk_as_esc combo on the Glove80: the first
-- of the two is held back for up to 50 ms, and typed as usual when the other doesn't follow.
-- Caps Lock -> Escape is a plain key remap (infrastructure repo, darwin/preferences).
local timeout = 0.05 -- the combo's timeoutMs
local types = hs.eventtap.event.types
local props = hs.eventtap.event.properties
local keycodes = hs.keycodes.map
local partner = { [keycodes.j] = keycodes.k, [keycodes.k] = keycodes.j }
-- Tags the held back key when the timer posts it, so the tap lets it through
local posted = 0x6a6b

local pending -- the held back j or k key down
local swallowUp = {} -- keycodes whose key up belongs to an Escape
local timer = hs.timer.delayed.new(timeout, function()
  if pending then
    pending:setProperty(props.eventSourceUserData, posted):post()
    pending = nil
  end
end)

local function escape()
  return {
    hs.eventtap.event.newKeyEvent(keycodes.escape, true),
    hs.eventtap.event.newKeyEvent(keycodes.escape, false),
  }
end

-- Global, so the garbage collector doesn't stop the tap
jkEscape = hs.eventtap.new({ types.keyDown, types.keyUp, types.flagsChanged }, function(event)
  if event:getProperty(props.eventSourceUserData) == posted then
    return false
  end
  local kind, code = event:getType(), event:getKeyCode()

  if kind == types.keyUp then
    if swallowUp[code] then
      swallowUp[code] = nil
      return true
    end
    -- Tapped faster than the timeout: the key down has to go out first
    if pending and pending:getKeyCode() == code then
      timer:stop()
      local down = pending
      pending = nil
      return true, { down, event:copy() }
    end
    return false
  end

  local out = {}
  if pending then
    timer:stop()
    local down = pending
    pending = nil
    if kind == types.keyDown and code == partner[down:getKeyCode()] then
      swallowUp[code], swallowUp[down:getKeyCode()] = true, true
      return true, escape()
    end
    out[1] = down
  end

  local plain = next(event:getFlags()) == nil
  if kind == types.keyDown and partner[code] and plain and event:getProperty(props.keyboardEventAutorepeat) == 0 then
    pending = event:copy()
    timer:start()
    return true, out
  end
  -- Any other key flushes the held back one ahead of itself
  if #out > 0 then
    out[2] = event:copy()
    return true, out
  end
  return false
end)
jkEscape:start()

-- macOS disables a tap that is slow to answer; turn it back on
jkEscapeWatchdog = hs.timer.doEvery(5, function()
  if not jkEscape:isEnabled() then
    jkEscape:start()
  end
end)
