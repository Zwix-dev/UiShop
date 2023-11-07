ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback('getMoney', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    cb(xPlayer.getMoney())
end)

ESX.RegisterServerCallback('checkprice', function(source, cb, cost, method)
    local xPlayer = ESX.GetPlayerFromId(source)
    local money = nil
    if method == "cash" then
        money = xPlayer.getMoney()
        if money >= cost then
            xPlayer.removeMoney(cost)
            cb(true)
        else
            cb(false)
        end
    else
        money = xPlayer.getAccount('bank').money
        if money >= cost then
            xPlayer.removeAccountMoney('bank', cost)
            cb(true)
        else
            cb(false)
        end
    end 
end)


RegisterNetEvent('zwix_shop:pay')
AddEventHandler('zwix_shop:pay', function (basket)
   
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(basket) do
        print(k)
        xPlayer.addInventoryItem(k, v.amount)
    end
end)