---@module 'hl'

hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "0x0", scale = 1.5 })
hl.monitor({ output = "HDMI-A-2", mode = "preferred", position = "2560x0", scale = 1 })

-- Workspaces 1-9 live on the secondary display, 10 on the primary.
for i = 1, 9 do
    hl.workspace_rule({
        workspace  = tostring(i),
        monitor    = "HDMI-A-2",
        default    = i == 1,
        persistent = true,
    })
end

hl.workspace_rule({
    workspace  = "10",
    monitor    = "HDMI-A-1",
    default    = true,
    persistent = true,
})
