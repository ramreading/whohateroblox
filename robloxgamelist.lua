local Players = game:GetService("Players")
local player = Players.LocalPlayer

local allowedPlaces = {
    [4483381587] = "Pet Simulator X",
    [920987237]  = "Blox Fruits",
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
