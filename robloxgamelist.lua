local HubName = "Ramread1ng Hub"

local SupportedGames = {
    [139252529145498] = "https://raw.githubusercontent.com/ramreading/rescripts/refs/heads/main/blooddebt.lua"
}


--// ============================================
--// MODERN NOTIFICATION UI
--// ============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Remove previous notification GUI if it exists
local oldGui = playerGui:FindFirstChild((HubName or "Hub") .. "Notifications")
if oldGui then
    oldGui:Destroy()
end

--// Configuration
local UI_CONFIG = {
    Width = 360,
    Height = 92,

    Background = Color3.fromRGB(18, 20, 26),
    BackgroundSecondary = Color3.fromRGB(25, 28, 36),

    Accent = Color3.fromRGB(115, 90, 255),
    AccentLight = Color3.fromRGB(155, 135, 255),

    Text = Color3.fromRGB(245, 245, 250),
    SubText = Color3.fromRGB(170, 174, 190),

    Success = Color3.fromRGB(80, 220, 140),
    Error = Color3.fromRGB(255, 85, 105),

    CornerRadius = 12,

    SlideTime = 0.45,
    ExitTime = 0.35,

    AutoClose = true,
    Duration = 6
}

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = (HubName or "Hub") .. "Notifications"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

--// Notification container
local mainFrame = Instance.new("Frame")
mainFrame.Name = "NotificationContainer"
mainFrame.AnchorPoint = Vector2.new(1, 1)
mainFrame.Position = UDim2.new(1, -24, 1, -24)
mainFrame.Size = UDim2.new(0, UI_CONFIG.Width, 0, 500)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = mainFrame

--// Utility
local function tween(object, time, properties, style, direction)
    local info = TweenInfo.new(
        time,
        style or Enum.EasingStyle.Quart,
        direction or Enum.EasingDirection.Out
    )

    local animation = TweenService:Create(object, info, properties)
    animation:Play()

    return animation
end

local notificationCounter = 0

--// Create notification
local function createNotification(title, description, imageId)
    notificationCounter += 1

    -- Notification holder
    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification_" .. notificationCounter
    notificationFrame.Size = UDim2.new(1, 0, 0, UI_CONFIG.Height)
    notificationFrame.BackgroundTransparency = 1
    notificationFrame.LayoutOrder = notificationCounter
    notificationFrame.ClipsDescendants = false
    notificationFrame.Parent = mainFrame

    -- Main card
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "Card"
    contentFrame.AnchorPoint = Vector2.new(1, 0)
    contentFrame.Position = UDim2.new(1, UI_CONFIG.Width + 30, 0, 0)
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundColor3 = UI_CONFIG.Background
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = notificationFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, UI_CONFIG.CornerRadius)
    corner.Parent = contentFrame

    -- Subtle border
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(55, 58, 72)
    stroke.Thickness = 1
    stroke.Transparency = 0.25
    stroke.Parent = contentFrame

    -- Accent strip
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 4, 1, -20)
    accent.Position = UDim2.new(0, 0, 0, 10)
    accent.BackgroundColor3 = UI_CONFIG.Accent
    accent.BorderSizePixel = 0
    accent.Parent = contentFrame

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 3)
    accentCorner.Parent = accent

    -- Icon holder
    local iconHolder = Instance.new("Frame")
    iconHolder.Size = UDim2.new(0, 52, 0, 52)
    iconHolder.Position = UDim2.new(0, 15, 0.5, -26)
    iconHolder.BackgroundColor3 = UI_CONFIG.BackgroundSecondary
    iconHolder.BorderSizePixel = 0
    iconHolder.Parent = contentFrame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 10)
    iconCorner.Parent = iconHolder

    local iconStroke = Instance.new("UIStroke")
    iconStroke.Color = UI_CONFIG.Accent
    iconStroke.Transparency = 0.7
    iconStroke.Thickness = 1
    iconStroke.Parent = iconHolder

    -- Icon
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Name = "Icon"
    imageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    imageLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
    imageLabel.Size = UDim2.new(0, 38, 0, 38)
    imageLabel.BackgroundTransparency = 1
    imageLabel.ScaleType = Enum.ScaleType.Fit

    if imageId and imageId ~= 0 then
        imageLabel.Image = "rbxassetid://" .. tostring(imageId)
    else
        imageLabel.Image = "rbxassetid://0"
    end

    imageLabel.Parent = iconHolder

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Position = UDim2.new(0, 82, 0, 14)
    titleLabel.Size = UDim2.new(1, -125, 0, 22)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = tostring(title or HubName or "Notification")
    titleLabel.TextColor3 = UI_CONFIG.Text
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = contentFrame

    -- Description
    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Name = "Description"
    descriptionLabel.Position = UDim2.new(0, 82, 0, 37)
    descriptionLabel.Size = UDim2.new(1, -105, 0, 38)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Text = tostring(description or "")
    descriptionLabel.TextColor3 = UI_CONFIG.SubText
    descriptionLabel.TextSize = 13
    descriptionLabel.Font = Enum.Font.Gotham
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.TextYAlignment = Enum.TextYAlignment.Top
    descriptionLabel.TextWrapped = true
    descriptionLabel.Parent = contentFrame

    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "Close"
    closeButton.AnchorPoint = Vector2.new(1, 0)
    closeButton.Position = UDim2.new(1, -10, 0, 10)
    closeButton.Size = UDim2.new(0, 26, 0, 26)
    closeButton.BackgroundColor3 = Color3.fromRGB(35, 38, 48)
    closeButton.BackgroundTransparency = 0.25
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(160, 164, 180)
    closeButton.TextSize = 20
    closeButton.Font = Enum.Font.GothamMedium
    closeButton.AutoButtonColor = false
    closeButton.Parent = contentFrame

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 7)
    closeCorner.Parent = closeButton

    -- Progress bar
    local progressBackground = Instance.new("Frame")
    progressBackground.Name = "ProgressBackground"
    progressBackground.Position = UDim2.new(0, 82, 1, -8)
    progressBackground.Size = UDim2.new(1, -105, 0, 3)
    progressBackground.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    progressBackground.BorderSizePixel = 0
    progressBackground.Parent = contentFrame

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressBackground

    local progress = Instance.new("Frame")
    progress.Name = "Progress"
    progress.Size = UDim2.new(1, 0, 1, 0)
    progress.BackgroundColor3 = UI_CONFIG.Accent
    progress.BorderSizePixel = 0
    progress.Parent = progressBackground

    local progressCorner2 = Instance.new("UICorner")
    progressCorner2.CornerRadius = UDim.new(1, 0)
    progressCorner2.Parent = progress

    -- Hover effects
    closeButton.MouseEnter:Connect(function()
        tween(
            closeButton,
            0.15,
            {
                BackgroundColor3 = Color3.fromRGB(55, 40, 48),
                TextColor3 = UI_CONFIG.Error
            },
            Enum.EasingStyle.Quad
        )
    end)

    closeButton.MouseLeave:Connect(function()
        tween(
            closeButton,
            0.15,
            {
                BackgroundColor3 = Color3.fromRGB(35, 38, 48),
                TextColor3 = Color3.fromRGB(160, 164, 180)
            },
            Enum.EasingStyle.Quad
        )
    end)

    -- Entrance animation
    contentFrame.Position = UDim2.new(1, UI_CONFIG.Width + 30, 0, 0)

    tween(
        contentFrame,
        UI_CONFIG.SlideTime,
        {
            Position = UDim2.new(1, 0, 0, 0)
        },
        Enum.EasingStyle.Quart,
        Enum.EasingDirection.Out
    )

    -- Small icon pop
    iconHolder.Size = UDim2.new(0, 42, 0, 42)
    iconHolder.Position = UDim2.new(0, 20, 0.5, -21)

    tween(
        iconHolder,
        0.35,
        {
            Size = UDim2.new(0, 52, 0, 52),
            Position = UDim2.new(0, 15, 0.5, -26)
        },
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    )

    local closed = false

    local function closeNotification()
        if closed then
            return
        end

        closed = true
        closeButton.Active = false

        -- Slide away
        local exitTween = tween(
            contentFrame,
            UI_CONFIG.ExitTime,
            {
                Position = UDim2.new(1, UI_CONFIG.Width + 30, 0, 0)
            },
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.In
        )

        -- Fade
        tween(
            contentFrame,
            UI_CONFIG.ExitTime,
            {
                BackgroundTransparency = 1
            },
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        )

        exitTween.Completed:Wait()

        -- Collapse notification slot
        local shrinkTween = tween(
            notificationFrame,
            0.25,
            {
                Size = UDim2.new(1, 0, 0, 0)
            },
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        )

        shrinkTween.Completed:Wait()

        notificationFrame:Destroy()
    end

    -- Close button
    closeButton.MouseButton1Click:Connect(closeNotification)

    -- Auto close
    if UI_CONFIG.AutoClose then
        task.spawn(function()
            local progressTween = tween(
                progress,
                UI_CONFIG.Duration,
                {
                    Size = UDim2.new(0, 0, 1, 0)
                },
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out
            )

            progressTween.Completed:Wait()

            if not closed then
                closeNotification()
            end
        end)
    end

    return notificationFrame
end
