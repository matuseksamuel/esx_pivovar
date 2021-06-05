-----------------------------------------

-----------------------------------------
ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}
local vine, jus = 1, 1

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'pivovar', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'pivovar', _U('pivovar_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'pivovar', 'Pivovar', 'society_pivovar', 'society_pivovar', 'society_pivovar', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "RaisinFarm" then
			local itemQuantity = xPlayer.getInventoryItem('chmel').count
			if itemQuantity >= 100 then
				xPlayer.showNotification(_U('not_enough_place'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.addInventoryItem('chmel', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_pivovar:startHarvest')
AddEventHandler('esx_pivovar:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~ERROR ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('chmel_taken'))  
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_pivovar:stopHarvest')
AddEventHandler('esx_pivovar:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vyšel jsi ze ~r~zony')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Muzes ~g~sklizet')
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "TraitementVin" then
			local itemQuantity = xPlayer.getInventoryItem('chmel').count

			if itemQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_chmel'))
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('chmel', 1)
						xPlayer.addInventoryItem('plzen', 1)
						xPlayer.showNotification(_U('plzen'))
						Transform(source, zone)
					end)
				else
					SetTimeout(1800, function()
						xPlayer.removeInventoryItem('chmel', 1)
						xPlayer.addInventoryItem('radegast', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "TraitementJus" then
			local itemQuantity = xPlayer.getInventoryItem('chmel').count
			if itemQuantity <= 0 then
				xPlayer.showNotification(_U('not_enough_chmel'))
				return
			else
				SetTimeout(1800, function()
					xPlayer.removeInventoryItem('chmel', 1)
					xPlayer.addInventoryItem('nealko', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_pivovar:startTransform')
AddEventHandler('esx_pivovar:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~ERROR ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_pivovar:stopTransform')
AddEventHandler('esx_pivovar:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vyšel jsi ze ~r~zony')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Muzete transformovat chmel')
		PlayersTransforming[_source]=true
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('radegast').count <= 0 then
				vine = 0
			else
				vine = 1
			end
			
			if xPlayer.getInventoryItem('nealko').count <= 0 then
				jus = 0
			else
				jus = 1
			end
		
			if vine == 0 and jus == 0 then
				xPlayer.showNotification(_U('no_product_sale'))
				return
			elseif xPlayer.getInventoryItem('radegast').count <= 0 and jus == 0 then
				xPlayer.showNotification(_U('no_radegast_sale'))
				vine = 0
				return
			elseif xPlayer.getInventoryItem('nealko').count <= 0 and vine == 0then
				xPlayer.showNotification(_U('no_nealko_sale'))
				jus = 0
				return
			else
				if (jus == 1) then
					SetTimeout(1100, function()
						local money = math.random(18,25)
						xPlayer.removeInventoryItem('nealko', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pivovar', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (vine == 1) then
					SetTimeout(1100, function()
						local money = math.random(30,35)
						xPlayer.removeInventoryItem('radegast', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_pivovar', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_pivovar:startSell')
AddEventHandler('esx_pivovar:startSell', function(zone)
	local _source = source

	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~ERROR ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_pivovar:stopSell')
AddEventHandler('esx_pivovar:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vyšel jsi ze ~r~zony')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Muzete ~g~prodavat')
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_pivovar:getStockItem')
AddEventHandler('esx_pivovar:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pivovar', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end

		xPlayer.showNotification(_U('have_withdrawn') .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_pivovar:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pivovar', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_pivovar:putStockItems')
AddEventHandler('esx_pivovar:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_pivovar', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			xPlayer.showNotification(_U('quantity_invalid'))
		end

		xPlayer.showNotification(_U('added') .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_pivovar:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)

ESX.RegisterUsableItem('nealko', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('nealko', 1)

	TriggerClientEvent('esx_status:add', source, 'hunger', 40000)
	TriggerClientEvent('esx_status:add', source, 'thirst', 120000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification(_U('used_nealko'))
end)

ESX.RegisterUsableItem('plzen', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem('plzen', 1)

	TriggerClientEvent('esx_status:add', source, 'drunk', 400000)
	TriggerClientEvent('esx_basicneeds:onDrink', source)
	xPlayer.showNotification(_U('used_plzen'))
end)
