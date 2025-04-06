Citizen.CreateThread(function()
    local pedModel = "s_m_y_dealer_01"
    local pedCoords = vector3(1544.46, 6331.06, 23.08)
    local drawTextCoords = vector3(1544.55, 6331.25, 24.08)
    
    local function SpawnNPC(model, coords)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
        
        local npc = CreatePed(4, model, coords.x, coords.y, coords.z, 0.0, false, true)
        SetEntityHeading(npc, 0.0)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        
        Citizen.CreateThread(function()
            while true do
                Wait(0)
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local distance = #(playerCoords - coords)
                
                if distance < 2 then
                    DrawText3D(drawTextCoords.x, drawTextCoords.y, drawTextCoords.z, "[E] Kenevir Sat")
                    
                    if IsControlJustReleased(0, 38) then
                        TriggerEvent("animation:kenevir", playerPed)
                    end
                end
            end
        end)
    end
    
    SpawnNPC(pedModel, pedCoords)
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end

RegisterNetEvent("animation:kenevir")
AddEventHandler("animation:kenevir", function(playerPed)
    local src = source
    
    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_DRUG_DEALER", 0, true)
    Citizen.Wait(5000)
    ClearPedTasks(playerPed)
    FreezeEntityPosition(playerPed, false)
    
    TriggerServerEvent('removeWeedBaggy')
end)
