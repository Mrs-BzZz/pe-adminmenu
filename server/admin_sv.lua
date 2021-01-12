
PE = {}

local PEAdmins = { -- Your identifier
    'steam:110000118fe7433',
}

ESX = nil 

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

PE.isAdmin = function()
    local PE_identifier = GetPlayerIdentifiers(src)
    PE_identifier = PE_identifier[1]
    for i, v in pairs(PEAdmins) do 
        if v == PE_identifier then 
            return true 
        end
    end 
    return false
end

RegisterServerEvent('PE-admin:announce')
AddEventHandler('PE-admin:announce', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style       =  'info',
            duration    =  10000,
            title       =  _U('admin_news'),
            message     =  _U('ten_min_close'),
            sound       =  true
        })
    end
end)

ESX.RegisterServerCallback('PE-admin:playersonline', function(source, cb)
	local xPlayers = ESX.GetPlayers()
	local players  = {}

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		table.insert(players, {
			source     = xPlayer.source,
			identifier = xPlayer.identifier,
            name       = xPlayer.name,
			job        = xPlayer.job
		})
	end

	cb(players)
end)

--Not tested
RegisterServerEvent('PE-admin:clearchat')
AddEventHandler('PE-admin:clearchat', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('PE-admin:clearchat', xPlayers[i], -1)
    end
end)

RegisterServerEvent('PE-admin:delallcars')
AddEventHandler('PE-admin:delallcars', function()
    local xPlayers    = ESX.GetPlayers()
    for i=1, #xPlayers, 1 do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('10_min')
        })
        Citizen.Wait(420000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('3_min')
        })
        Citizen.Wait(150000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style = 'info', 
            duration = 5000,
            message = _U('30_sec')
        })
        Citizen.Wait(30000)
        TriggerClientEvent('t-notify:client:Custom', xPlayers[i], {
            style  =  'success',
            duration = 5000,
            message  =  _U('success_delall')
        })
        TriggerClientEvent('PE-admin:delallveh', -1)
    end
end)

RegisterServerEvent("PE-admin:kickall")
AddEventHandler("PE-admin:kickall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		DropPlayer(xPlayers[i], _U('kick_msg'))
	end
end)

RegisterServerEvent("PE-admin:reviveall")
AddEventHandler("PE-admin:reviveall", function()
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            TriggerClientEvent('esx_ambulancejob:revive', xPlayers[i])
            sendDisc(webhook, "Revive", "Se ha revivido a todos.", 56108)
	end
end)

RegisterServerEvent('PE-admin:isAdministrator')
AddEventHandler('PE-admin:isAdministrator', function()
    local PEidentifier = GetPlayerIdentifiers(source)
    PEidentifier = PEidentifier[1]
    for a, v in pairs(PEAdmins) do 
        if v == PEidentifier then 
            TriggerClientEvent('PE-admin:checkAdmin', source, true)
            return true 
        end
    end 
    return false 
end)

RegisterCommand("admin", function(source, args, rawCommand)
	if source ~= 0 then
		local xPlayer = ESX.GetPlayerFromId(source)
        TriggerClientEvent('t-notify:client:Custom', source, {
            style  =  'info',
            duration = 5000,
            message  =  _U('your_rank', xPlayer.getGroup())
        })
	end
end, false)

function sendDisc (webhook, name, message, color)
    local webhook = "https://discord.com/api/webhooks/798525432818434048/soEpjUXu260Jg37zOL_0DuDmCD-dLFQtWWL-3IkBNetdDylYhE_g45L01S61InHyIXto"
    local embeds = {
        {
            ["title"]           = "Your server",
            ["type"]            = "rich",
            ["color"]           = color,
            ["description"]     = message,
            ["footer"]          = {
            ["text"]            = "Project-Entity",
            ["icon_url"]        = "https://imgur.com/nmKOlgxg.jpg",
           },
        }
    }
    
      if message == nil or message == '' then return FALSE end
      PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
    end
