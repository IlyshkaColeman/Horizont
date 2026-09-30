--!strict
-- build_daynight_gui.lua
-- Builds and configures the stylized Day/Night HUD widget in StarterGui.DayNightGui

local StarterGui = game:GetService("StarterGui")

-- 1. Remove existing DayNightGui if any
local existing = StarterGui:FindFirstChild("DayNightGui")
if existing then
    existing:Destroy()
end

-- 2. Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DayNightGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.DisplayOrder = 10
screenGui.Parent = StarterGui

-- 3. Widget Container (Bottom-Right, 24px margins)
local container = Instance.new("Frame")
container.Name = "DayNightContainer"
container.AnchorPoint = Vector2.new(1, 1)
container.Position = UDim2.new(1, -24, 1, -24)
container.Size = UDim2.new(0, 208, 0, 66)
container.BackgroundTransparency = 1
container.ClipsDescendants = false
container.ZIndex = 5
container.Parent = screenGui

-- 4. 3D Bevel Base (Tactile depth, 4px)
local bevelBase = Instance.new("Frame")
bevelBase.Name = "BevelBase"
bevelBase.AnchorPoint = Vector2.new(0.5, 0.5)
bevelBase.Position = UDim2.new(0.5, 0, 0.5, 4)
bevelBase.Size = UDim2.new(1, 0, 1, 0)
bevelBase.BackgroundColor3 = Color3.fromRGB(185, 75, 12) -- Deep warm burnt orange bevel
bevelBase.BorderSizePixel = 0
bevelBase.ClipsDescendants = false
bevelBase.ZIndex = 5
bevelBase.Parent = container

local bevelCorner = Instance.new("UICorner")
bevelCorner.CornerRadius = UDim.new(0, 18)
bevelCorner.Parent = bevelBase

-- 5. Main Card Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(250, 150, 35) -- Sunny warm orange
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = false
mainFrame.ZIndex = 6
mainFrame.Parent = container

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local bgGradient = Instance.new("UIGradient")
bgGradient.Name = "BgGradient"
bgGradient.Rotation = 90
bgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 65)), -- Sunny bright gold
    ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 125, 25))  -- Warm cartoon orange
})
bgGradient.Parent = mainFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Name = "FrameStroke"
frameStroke.Thickness = 2
frameStroke.Color = Color3.fromRGB(255, 255, 255) -- Clean crisp white cartoon stroke
frameStroke.Transparency = 0.15
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
frameStroke.Parent = mainFrame

local cardScale = Instance.new("UIScale")
cardScale.Name = "CardScale"
cardScale.Scale = 1.0
cardScale.Parent = mainFrame

-- 6. Icon Container (Left Badge)
local iconContainer = Instance.new("Frame")
iconContainer.Name = "IconContainer"
iconContainer.AnchorPoint = Vector2.new(0, 0.5)
iconContainer.Position = UDim2.new(0, 9, 0.5, 0)
iconContainer.Size = UDim2.new(0, 48, 0, 48)
iconContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Crisp white rounded badge
iconContainer.BorderSizePixel = 0
iconContainer.ZIndex = 7
iconContainer.Parent = mainFrame

local iconCorner = Instance.new("UICorner")
iconCorner.CornerRadius = UDim.new(0, 14)
iconCorner.Parent = iconContainer

local iconStroke = Instance.new("UIStroke")
iconStroke.Name = "IconStroke"
iconStroke.Thickness = 1.5
iconStroke.Color = Color3.fromRGB(255, 210, 85) -- Soft golden rim
iconStroke.Transparency = 0.20
iconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
iconStroke.Parent = iconContainer

-- 7. Icon ImageLabel
local iconLabel = Instance.new("ImageLabel")
iconLabel.Name = "IconLabel"
iconLabel.AnchorPoint = Vector2.new(0.5, 0.5)
iconLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
iconLabel.Size = UDim2.new(0, 42, 0, 42)
iconLabel.BackgroundTransparency = 1
iconLabel.Image = "rbxassetid://133820282809732" -- New 3D Cartoon Sun Icon
iconLabel.ScaleType = Enum.ScaleType.Fit
iconLabel.ZIndex = 8
iconLabel.Parent = iconContainer

-- 8. Text Container (Right Area)
local textContainer = Instance.new("Frame")
textContainer.Name = "TextContainer"
textContainer.AnchorPoint = Vector2.new(0, 0.5)
textContainer.Position = UDim2.new(0, 66, 0.5, 0)
textContainer.Size = UDim2.new(1, -76, 1, -12)
textContainer.BackgroundTransparency = 1
textContainer.ZIndex = 7
textContainer.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.AnchorPoint = Vector2.new(0, 0)
titleLabel.Position = UDim2.new(0, 0, 0, 2)
titleLabel.Size = UDim2.new(1, 0, 0, 16)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.Text = "ДЕНЬ"
titleLabel.TextSize = 13
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.ZIndex = 8
titleLabel.Parent = textContainer

local titleStroke = Instance.new("UIStroke")
titleStroke.Name = "TitleStroke"
titleStroke.Thickness = 1.2
titleStroke.Color = Color3.fromRGB(160, 65, 10)
titleStroke.Transparency = 0.35
titleStroke.Parent = titleLabel

local timerLabel = Instance.new("TextLabel")
timerLabel.Name = "TimerLabel"
timerLabel.AnchorPoint = Vector2.new(0, 0)
timerLabel.Position = UDim2.new(0, 0, 0, 19)
timerLabel.Size = UDim2.new(1, 0, 0, 22)
timerLabel.BackgroundTransparency = 1
timerLabel.Font = Enum.Font.FredokaOne
timerLabel.Text = "05:00"
timerLabel.TextSize = 21
timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
timerLabel.TextXAlignment = Enum.TextXAlignment.Left
timerLabel.ZIndex = 8
timerLabel.Parent = textContainer

local timerStroke = Instance.new("UIStroke")
timerStroke.Name = "TimerStroke"
timerStroke.Thickness = 1.5
timerStroke.Color = Color3.fromRGB(150, 55, 10)
timerStroke.Transparency = 0.35
timerStroke.Parent = timerLabel

-- 9. Progress Bar Track & Fill (Bottom of Content)
local progressTrack = Instance.new("Frame")
progressTrack.Name = "ProgressTrack"
progressTrack.AnchorPoint = Vector2.new(0, 1)
progressTrack.Position = UDim2.new(0, 0, 1, -2)
progressTrack.Size = UDim2.new(1, -4, 0, 4)
progressTrack.BackgroundColor3 = Color3.fromRGB(140, 50, 10)
progressTrack.BackgroundTransparency = 0.45
progressTrack.BorderSizePixel = 0
progressTrack.ZIndex = 8
progressTrack.Parent = textContainer

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = progressTrack

local progressFill = Instance.new("Frame")
progressFill.Name = "ProgressFill"
progressFill.AnchorPoint = Vector2.new(0, 0)
progressFill.Position = UDim2.new(0, 0, 0, 0)
progressFill.Size = UDim2.new(1, 0, 1, 0)
progressFill.BackgroundColor3 = Color3.fromRGB(255, 245, 140)
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 9
progressFill.Parent = progressTrack

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(1, 0)
fillCorner.Parent = progressFill

return "DayNightGui created successfully in StarterGui"
