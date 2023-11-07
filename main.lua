ESX =nil
local Basket = {}
local shoptype
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function loadItems()
    for b,c in pairs(Shop.Pos) do 
        if (GetDistanceBetweenCoords(Shop.Pos[b]["coords"], GetEntityCoords(PlayerPedId()), true) < 3.0) then
            shoptype = Shop.Pos[b].type
        end
    end
    for k,v in pairs(Shop.Items) do
        if v.type == shoptype or v.type == "all" then 
            local info = Shop.Items[k]
            SendNUIMessage({
                type = "addItem",
                name = info.name,
                label = info.label,
                price = info.price,
                category = info.category,
                desc = info.description,
                letypedefou = info.type,
                image = "nui://images/"..info.name..".png",
            })

            
        end 
        
        
    end
end
RegisterNUICallback('addBasket', function(data)
    if Basket[data.name] then
        ESX.ShowNotification("Vous avez ajouté x1 ".. data.label .." dans votre panier ( total : "  .. (Basket[data.name].amount+1).. ")")
        Basket[data.name].amount = Basket[data.name].amount + 1
        Basket[data.name].totalitemsprice = Basket[data.name].totalitemsprice + Shop.Items[data.name].price
        
        
    else
        Basket[data.name] = {
            amount = 1,
            label = data.label,
            image = "nui://images/"..data.name..".png",
            price = Shop.Items[data.name].price,
            totaldupanier = Shop.Items[data.name].price
        }
        Basket[data.name].totalitemsprice = Basket[data.name].price
        ESX.ShowNotification("Vous avez ajouté x1 ".. data.label .." dans votre panier")
    
    end
    
    SendNUIMessage({
        type = "addList",
        name = data.name,
        amount = Basket[data.name].amount,
        label = data.label,
        image = "nui://images/"..data.name..".png",
        total = Basket[data.name].totalitemsprice,
        price = Shop.Items[data.name].price,
        totaldupanier = letotalpanier
    })

   
   
    
end)

function openMarket()
    SetNuiFocus(true, true)
    loadItems()
    for b,c in pairs(Shop.Pos) do 
        if (GetDistanceBetweenCoords(Shop.Pos[b]["coords"], GetEntityCoords(PlayerPedId()), true) < 3.0) then
            shoptype = Shop.Pos[b].type
        end
    end
    SendNUIMessage({
        type = "open",
        letype = shoptype
    })
end
RegisterNUICallback('deleteItem', function(data) 
    SendNUIMessage({
        type = "removeItem",
        name = data.name,
        label = data.label
    })
    Basket[data.name] = nil
end)

RegisterNUICallback('removeAmount', function(data)

    local newAmount = Basket[data.name].amount-1
    ESX.ShowNotification("Vous avez retiré x1 ".. data.label .." dans votre panier ( total : "  .. newAmount.. ")")
    Basket[data.name].amount = newAmount
    Basket[data.name].totalitemsprice = Basket[data.name].totalitemsprice - Shop.Items[data.name].price
    SendNUIMessage({
        type = "removeAmount",
        name = data.name,
        label = data.label,
        amount = newAmount,
        total = Basket[data.name].totalitemsprice,
        price = Shop.Items[data.name].price
    })
end)
function loadBasketPage()
    SendNUIMessage({
        type = "loadbasketpage",
    })
end
RegisterNUICallback('buy', function(data) 
    ESX.TriggerServerCallback('checkprice', function(status)
        if status then
            TriggerServerEvent('zwix_shop:pay', Basket)
            SendNUIMessage({
                type = "close"
            })
        else
            ESX.ShowNotification("Pas assez d'argent")
        end
    end, tonumber(data.cout), data.method)
end)
function CalculateTotalAmount(basket)
    local total = 0
    for _, item in pairs(basket) do
        total = total + item.amount
    end
    return total
end
RegisterNUICallback('exit', function() 
	SetNuiFocus(false, false)
    Basket = {}
    shoptype = ""
end)


local sleep = 1000
Citizen.CreateThread(function()
    while true do
        local find = false
        for k,v in pairs(Shop.Pos) do
            local shopCoord = Shop.Pos[k]["coords"]
            local myCoord = GetEntityCoords(PlayerPedId())
            if (GetDistanceBetweenCoords(shopCoord, myCoord, true) < 3.0) then
                targetShop = k
                find = true
                sleep = 0
            end
        end
        if not find then
            targetShop = nil
            sleep = 1000
        end
        Citizen.Wait(1000)
    end
end)


	
for k,v in pairs(Shop.Pos) do
    local blip = AddBlipForCoord(Shop.Pos[k]["coords"])
    SetBlipSprite (blip, 59)
    SetBlipScale  (blip, 0.8)
    SetBlipColour (blip, 25)
    SetBlipAsShortRange(blip, true)
    
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName("shops")
    EndTextCommandSetBlipName(blip)
end

    

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(sleep)
        if targetShop then
            ESX.ShowHelpNotification("Appuez sur ~INPUT_CONTEXT~ pour accéder au shop")
            local coords = Shop.Pos[targetShop]["coords"]
            DrawMarker(29, vector3(coords.x, coords.y, coords.z+1) - vector3(0.0, 0.0, 0.985), 0.0, 0.0, 0.0, 0, 0.0, 0.0,0.5, 0.5, 0.5, 0, 255, 255, 100, false, false, 2, true, false, false, false)
            if IsControlJustPressed(0, 38) then
                openMarket()
            end
        end
    end
    
end)