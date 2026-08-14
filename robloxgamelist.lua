local Players = game:GetService("Players")
local player = Players.LocalPlayer

local allowedPlaces = {
    [139252529145498]  = "https://raw.githubusercontent.com/ramreading/rescripts/refs/heads/main/blooddebt.lua",
    [87541610558346] = "https://raw.githubusercontent.com/ramreading/rescripts/refs/heads/main/blooddebt.lua",
}

local currentPlaceId = game.PlaceId
local gameName = allowedPlaces[currentPlaceId]

if not gameName then
    local names = {}
    for _, name in pairs(allowedPlaces) do
        table.insert(names, name)
    end
    pcall(function()
        player:Kick(msg)
    end)

    return 
end
