local HubName = "Ramread1ng Hub"

local SupportedGames = {
    [139252529145498] = "https://raw.githubusercontent.com/ramreading/rescripts/refs/heads/main/blooddebt.lua"
}

local gameObject = game
local playersService = gameObject:GetService("Players")
local marketplaceService = gameObject:GetService("MarketplaceService")
local tweenService = gameObject:GetService("TweenService")
local localPlayer = playersService.LocalPlayer
local currentPlaceId = gameObject.PlaceId

local coreGui = nil
pcall(function()
    coreGui = gameObject:GetService("CoreGui")
end)

if not coreGui then
    coreGui = localPlayer:WaitForChild("PlayerGui")
end

-- Create notification GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = HubName .. "Notifications"
screenGui.Parent = coreGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 1, 0)
mainFrame.Position = UDim2.new(1, -340, 0, 0)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = mainFrame
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
uiListLayout.Padding = UDim.new(0, 10)

local uiPadding = Instance.new("UIPadding")
uiPadding.Parent = mainFrame
uiPadding.PaddingBottom = UDim.new(0, 20)

-- Function to create a notification
local function createNotification(title, description, imageId)
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Size = UDim2.new(1, 0, 0, 80)
    notificationFrame.BackgroundTransparency = 1
    notificationFrame.Parent = mainFrame

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.Position = UDim2.new(1.2, 0, 0, 0)
    contentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = notificationFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = contentFrame

    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Size = UDim2.new(0, 60, 0, 60)
    imageLabel.Position = UDim2.new(0, 10, 0, 10)
    imageLabel.BackgroundTransparency = 1
    if imageId and imageId ~= 0 then
        imageLabel.Image = "rbxassetid://" .. imageId
    else
        imageLabel.Image = "rbxassetid://0"
    end
    imageLabel.Parent = contentFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -110, 0, 20)
    titleLabel.Position = UDim2.new(0, 80, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = contentFrame

    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Size = UDim2.new(1, -90, 0, 40)
    descriptionLabel.Position = UDim2.new(0, 80, 0, 30)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Text = description
    descriptionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    descriptionLabel.TextSize = 14
    descriptionLabel.Font = Enum.Font.Gotham
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.TextWrapped = true
    descriptionLabel.Parent = contentFrame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 24, 0, 24)
    closeButton.Position = UDim2.new(1, -30, 0, 8)
    closeButton.BackgroundTransparency = 1
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 80, 80)
    closeButton.TextSize = 18
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = contentFrame

    -- Animate in
    local slideIn = tweenService:Create(
        contentFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = UDim2.new(0, 0, 0, 0) }
    )
    slideIn:Play()

    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        closeButton.Active = false

        local slideOut = tweenService:Create(
            contentFrame,
            TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            { Position = UDim2.new(1.2, 0, 0, 0) }
        )
        slideOut:Play()
        slideOut.Completed:Wait()

        local shrink = tweenService:Create(
            notificationFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Size = UDim2.new(1, 0, 0, 0) }
        )
        shrink:Play()
        shrink.Completed:Wait()

        notificationFrame:Destroy()
    end)
end

-- Show suggestions for other supported games
local function showGameSuggestions()
    for placeId, _ in pairs(SupportedGames) do
        if placeId ~= currentPlaceId then
            local success, productInfo = pcall(function()
                return marketplaceService:GetProductInfo(placeId)
            end)

            if success and productInfo then
                createNotification(
                    HubName .. " Suggestion",
                    "This script also supports: " .. productInfo.Name,
                    productInfo.IconImageAssetId
                )
            end
        end
    end
end

-- Main loader function
local function loadScript()
    local scriptUrl = SupportedGames[currentPlaceId]

    if scriptUrl then
        createNotification(HubName, "Script loaded for this game!", 0)
        showGameSuggestions()

        local success, result = pcall(function()
            return gameObject:HttpGet(scriptUrl)
        end)

        if success and result then
            local loadSuccess, loadError = pcall(function()
                loadstring(result)()
            end)

            if not loadSuccess then
                warn("[" .. HubName .. "] Error running script: " .. tostring(loadError))
            end
        else
            warn("[" .. HubName .. "] Failed to fetch script from GitHub.")
        end
    else
        warn("[" .. HubName .. "] Game not supported.")
        createNotification(HubName, "Game not supported, but try our other games!", 0)
        showGameSuggestions()
    end
end

loadScript()
