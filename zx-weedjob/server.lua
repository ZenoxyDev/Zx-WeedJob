QBCore = exports['qb-core']:GetCoreObject()

function RemoveWeedBaggyFromInventory(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if Player ~= nil and Player.Functions ~= nil then
        local hasWeedBaggy = Player.Functions.GetItemByName('weed_baggy')
        if hasWeedBaggy and hasWeedBaggy.amount > 0 then
            Player.Functions.RemoveItem('weed_baggy', hasWeedBaggy.amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weed_baggy'], 'remove')

            local payment = hasWeedBaggy.amount * 1000
            Player.Functions.AddMoney('cash', payment, "weed_baggy_sold")
            TriggerClientEvent('QBCore:Notify', src, 'Kenevir satışından dolayı $' .. payment .. ' nakit aldınız.')

        else

            TriggerClientEvent('QBCore:Notify', src, 'Yeterli miktarda paketlenmiş kenevir bulunamadı.', 'error')
        end
    end
end


RegisterServerEvent('removeWeedBaggy')
AddEventHandler('removeWeedBaggy', function()
    RemoveWeedBaggyFromInventory(source)
end)

RegisterNetEvent('giveWeedItem')
AddEventHandler('giveWeedItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(1, 5)
    Player.Functions.AddItem('weed', amount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weed'], 'add')
    TriggerClientEvent('QBCore:Notify', src, 'Kenevir topladınız: ' .. amount)
end)

RegisterNetEvent('processWeedItem')
AddEventHandler('processWeedItem', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)


    local hasWeed = Player.Functions.GetItemByName('weed')
    local hasEmptyBaggy = Player.Functions.GetItemByName('weed_baggy_empty')

    if hasWeed and hasEmptyBaggy and hasWeed.amount >= 2 and hasEmptyBaggy.amount >= 1 then

        Player.Functions.AddItem('weed_baggy', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weed_baggy'], 'add')
        TriggerClientEvent('QBCore:Notify', src, 'Kenevir işlediniz: 1')


        Player.Functions.RemoveItem('weed', 2)
        Player.Functions.RemoveItem('weed_baggy_empty', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['weed'], 'remove')

    else

        TriggerClientEvent('QBCore:Notify', src, 'Yeterli miktarda kenevir veya boş poşet bulunamadı.', 'error')
    end
end)
