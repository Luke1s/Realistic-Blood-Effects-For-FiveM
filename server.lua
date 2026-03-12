local bloodCleanupEnabled = Config.DefaultEnabled

local function isAllowed(src)
    -- Server console always allowed
    if src == 0 then
        return true
    end

    return IsPlayerAceAllowed(src, Config.AdminAce)
end

RegisterCommand(Config.ToggleCommand, function(source)
    if not isAllowed(source) then
        if source ~= 0 then
            TriggerClientEvent("bloodcleanup:notify", source, "You do not have permission to use this command.")
        else
            print("[bloodcleanup] Console does not need ACE permission, but this was denied unexpectedly.")
        end
        return
    end

    bloodCleanupEnabled = not bloodCleanupEnabled

    print(("[bloodcleanup] Global state changed: %s"):format(bloodCleanupEnabled and "ENABLED" or "DISABLED"))

    -- Push the same setting to everyone
    TriggerClientEvent("bloodcleanup:setEnabled", -1, bloodCleanupEnabled)
end, true)

-- When a player joins/spawns their client resource, they ask for the current state
RegisterNetEvent("bloodcleanup:requestState", function()
    local src = source
    TriggerClientEvent("bloodcleanup:setEnabled", src, bloodCleanupEnabled)
end)

AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then
        return
    end

    print(("[bloodcleanup] Started. Default global state: %s"):format(bloodCleanupEnabled and "ENABLED" or "DISABLED"))
end)