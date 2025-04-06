local isHarvesting = false
local isProcessing = false
local isWaitingForHarvest = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, location in pairs(Config.CollectPoints) do
            local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, location.pos.x, location.pos.y, location.pos.z)

            if dist < 2.0 then
                DrawText3D(location.pos.x, location.pos.y, location.pos.z, "[E] Kenevir Topla")

                if IsControlJustReleased(0, 38) then
                    if not isHarvesting and not isWaitingForHarvest then
                        TriggerEvent('startWeedHarvesting')
                    elseif isHarvesting and not isWaitingForHarvest then
                        isWaitingForHarvest = true
                        TriggerEvent('notifyUser', 'Lütfen İşleminizin Bitmesini Bekleyin', 'error')
                    end
                end
            end
        end

        for _, location in pairs(Config.ProcessingPoints) do
            local dist = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, location.pos.x, location.pos.y, location.pos.z)

            if dist < 2.0 then
                DrawText3D(location.pos.x, location.pos.y, location.pos.z, "[E] Kenevir Isle")

                if IsControlJustReleased(0, 38) then
                    if not isProcessing then
                        TriggerEvent('startWeedProcessing')
                    else
                        TriggerEvent('notifyUser', 'Lütfen İşleminizin Bitmesini Bekleyin', 'error')
                    end
                end
            end
        end

        if isProcessing and IsControlJustReleased(0, 177) then
            TriggerEvent('cancelWeedProcessing')
        end

        if isHarvesting and IsControlJustReleased(0, 177) then
            TriggerEvent('cancelWeedHarvesting')
        end

        if isWaitingForHarvest and IsControlJustReleased(0, 38) then 
            TriggerEvent('notifyUser', 'Lütfen İşleminizin Bitmesini Bekleyin', 'error')
        end
    end
end)

RegisterNetEvent('startWeedHarvesting')
AddEventHandler('startWeedHarvesting', function()
    local playerPed = PlayerPedId()
    isHarvesting = true
    TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    SendNUIMessage({
        action = 'startProgressBar',
        duration = 10000
    })
    Citizen.Wait(10000)
    if isHarvesting then
        ClearPedTasksImmediately(playerPed)
        TriggerServerEvent('giveWeedItem')
    end
    isHarvesting = false
    isWaitingForHarvest = false
end)

RegisterNetEvent('cancelWeedHarvesting')
AddEventHandler('cancelWeedHarvesting', function()
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    SendNUIMessage({
        action = 'cancelProgressBar'
    })
    isHarvesting = false
    isWaitingForHarvest = false
end)

RegisterNetEvent('startWeedProcessing')
AddEventHandler('startWeedProcessing', function()
    local playerPed = PlayerPedId()
    isProcessing = true
    TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
    
    SendNUIMessage({
        action = 'startProgressBar',
        duration = 10000
    })
    
    SendNUIMessage({
        action = 'updateProgressText',
        text = 'Kenevir İşleniyor..'
    })
    
    Citizen.Wait(10000)
    
    if isProcessing then
        ClearPedTasksImmediately(playerPed)
        TriggerServerEvent('processWeedItem')
    end
    
    isProcessing = false
end)

RegisterNetEvent('cancelWeedProcessing')
AddEventHandler('cancelWeedProcessing', function()
    local playerPed = PlayerPedId()
    ClearPedTasksImmediately(playerPed)
    SendNUIMessage({
        action = 'cancelProgressBar'
    })
    isProcessing = false
end)

RegisterNetEvent('notifyUser')
AddEventHandler('notifyUser', function(message, type)
    TriggerEvent('QBCore:Notify', message, type)
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())

    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)

        local factor = (string.len(text)) / 370

        SetDrawOrigin(x, y, z + 0.2, 0)
        DrawRect(0.0, 0.0125, 0.0175 + factor, 0.03, 0, 0, 0, 100)
        DrawText(0.0, 0.0)
        ClearDrawOrigin()
    end
end