local enabled = false
local cleanupThreadRunning = false

local function notify(msg)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg)
    DrawNotification(false, true)
end

local function getNearbyPeds(radius)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pool = GetGamePool("CPed")
    local nearby = {}

    for i = 1, #pool do
        local ped = pool[i]

        if DoesEntityExist(ped) and ped ~= playerPed then
            local pedCoords = GetEntityCoords(ped)
            local dist = #(playerCoords - pedCoords)

            if dist <= radius then
                nearby[#nearby + 1] = ped
            end
        end
    end

    return nearby
end

local function cleanupThickBloodUnderPed(ped)
    local coords = GetEntityCoords(ped)

    -- Tiny radius aimed right under the ped:
    -- removes the thick center pool while tending to leave wider tiny splatter alone
    RemoveDecalsInRange(coords.x, coords.y, coords.z - 1.0, 0.20)
end

local function shouldCleanPed(ped)
    return IsPedDeadOrDying(ped, true)
end

local function startCleanupThread()
    if cleanupThreadRunning then
        return
    end

    cleanupThreadRunning = true

    CreateThread(function()
        while enabled do
            local peds = getNearbyPeds(Config.ScanRadius)

            for i = 1, #peds do
                local ped = peds[i]

                if shouldCleanPed(ped) then
                    cleanupThickBloodUnderPed(ped)
                end
            end

            local playerPed = PlayerPedId()
            if IsPedDeadOrDying(playerPed, true) then
                cleanupThickBloodUnderPed(playerPed)
            end

            -- Fastest practical client loop
            Wait(0)
        end

        cleanupThreadRunning = false
    end)
end

RegisterNetEvent("bloodcleanup:setEnabled", function(state)
    enabled = state == true

    if enabled then
        startCleanupThread()
        notify(Config.NotifyEnabled)
    else
        notify(Config.NotifyDisabled)
    end
end)

RegisterNetEvent("bloodcleanup:notify", function(msg)
    notify(msg)
end)

CreateThread(function()
    Wait(1000)
    TriggerServerEvent("bloodcleanup:requestState")
end)