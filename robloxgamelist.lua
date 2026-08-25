local Players = game:GetService("Players")
local player = Players.LocalPlayer

local allowedPlaces = {
    [139252529145498]  = "https://raw.githubusercontent.com/ramreading/rescripts/refs/heads/main/blooddebt.lua",
    [87541610558346] = "https://raw.githubusercontent.com/ramreading/rescripts/refs/heads/main/blooddebt.lua",
}

local function showNotification(text)
    local success, err = pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "RamHub",
            Text = "Unsupported game.",
            Duration = 5,
        })
    end)
end
