--!strict
-- DayNightClient: Master client controller for stylized cartoon day/night cycle, lighting lerp, clouds, 3D planets, audio crossfade, comets, and UI.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local terrain = workspace:WaitForChild("Terrain")
local clouds = terrain:WaitForChild("Clouds", 5) :: Clouds?

-- References to ReplicatedStorage
local folder = ReplicatedStorage:WaitForChild("DayNightSystem", 10)
if not folder then
    warn("[DayNightClient] DayNightSystem folder not found in ReplicatedStorage")
    return
end

local timeOfDayVal = folder:WaitForChild("TimeOfDaySeconds") :: NumberValue
local currentPhaseVal = folder:WaitForChild("CurrentPhase") :: StringValue
local timeUntilNextVal = folder:WaitForChild("TimeUntilNextPhase") :: NumberValue
local dayDurationVal = folder:WaitForChild("DayDuration", 5) :: NumberValue?
local nightDurationVal = folder:WaitForChild("NightDuration", 5) :: NumberValue?

-- SoundService references
local daySound = SoundService:WaitForChild("DayAmbience", 5) :: Sound?
local nightSound = SoundService:WaitForChild("NightAmbience", 5) :: Sound?

if daySound and not daySound.IsPlaying then daySound:Play() end
if nightSound and not nightSound.IsPlaying then nightSound:Play() end

-- Lighting effects references
local atmosphere = Lighting:WaitForChild("Atmosphere", 5) :: Atmosphere?
local bloom = Lighting:WaitForChild("BloomEffect", 5) :: BloomEffect?
local colorCorrection = Lighting:WaitForChild("ColorCorrectionEffect", 5) :: ColorCorrectionEffect?
local sunRays = Lighting:WaitForChild("SunRaysEffect", 5) :: SunRaysEffect?

-- Palette Definitions
local DAY_LIGHTING = {
    Ambient = Color3.fromRGB(110, 115, 130),
    OutdoorAmbient = Color3.fromRGB(140, 150, 165),
    ColorShift_Top = Color3.fromRGB(255, 245, 220),
    ColorShift_Bottom = Color3.fromRGB(200, 225, 235),
    Brightness = 2.2,
    AtmosphereColor = Color3.fromRGB(195, 230, 255),
    AtmosphereDecay = Color3.fromRGB(255, 225, 190),
    AtmosphereDensity = 0.3,
    AtmosphereGlare = 0.25,
    AtmosphereHaze = 0.5,
    SunRaysIntensity = 0.15,
    CloudColor = Color3.fromRGB(255, 255, 255),
}

local SUNSET_LIGHTING = {
    Ambient = Color3.fromRGB(120, 100, 110),
    OutdoorAmbient = Color3.fromRGB(180, 140, 120),
    ColorShift_Top = Color3.fromRGB(255, 190, 130),
    ColorShift_Bottom = Color3.fromRGB(160, 110, 140),
    Brightness = 1.8,
    AtmosphereColor = Color3.fromRGB(255, 175, 140),
    AtmosphereDecay = Color3.fromRGB(255, 110, 80),
    AtmosphereDensity = 0.35,
    AtmosphereGlare = 0.5,
    AtmosphereHaze = 1.2,
    SunRaysIntensity = 0.25,
    CloudColor = Color3.fromRGB(255, 205, 160),
}

local NIGHT_LIGHTING = {
    Ambient = Color3.fromRGB(35, 30, 60),
    OutdoorAmbient = Color3.fromRGB(45, 40, 75),
    ColorShift_Top = Color3.fromRGB(120, 140, 220),
    ColorShift_Bottom = Color3.fromRGB(25, 20, 50),
    Brightness = 1.2,
    AtmosphereColor = Color3.fromRGB(35, 30, 65),
    AtmosphereDecay = Color3.fromRGB(20, 15, 45),
    AtmosphereDensity = 0.35,
    AtmosphereGlare = 0.0,
    AtmosphereHaze = 0.8,
    SunRaysIntensity = 0.02,
    CloudColor = Color3.fromRGB(160, 150, 195),
}

local function blendColor3(c1: Color3, c2: Color3, c3: Color3, w1: number, w2: number, w3: number): Color3
    local r = math.clamp(c1.R * w1 + c2.R * w2 + c3.R * w3, 0, 1)
    local g = math.clamp(c1.G * w1 + c2.G * w2 + c3.G * w3, 0, 1)
    local b = math.clamp(c1.B * w1 + c2.B * w2 + c3.B * w3, 0, 1)
    return Color3.new(r, g, b)
end

-- ----------------------------------------------------
-- 1. Lighting & Atmosphere interpolation based on ClockTime
-- ----------------------------------------------------
local function updateLightingVisuals()
    local clock = Lighting.ClockTime

    local dayWeight = 0
    local nightWeight = 0
    local twilightWeight = 0

    if clock >= 7.5 and clock <= 16.5 then
        dayWeight = 1
    elseif clock > 16.5 and clock < 19.5 then
        local progress = (clock - 16.5) / 3.0
        twilightWeight = 1 - math.abs(progress - 0.5) * 2
        if progress < 0.5 then
            dayWeight = 1 - progress * 2
        else
            nightWeight = (progress - 0.5) * 2
        end
    elseif clock >= 19.5 or clock <= 4.5 then
        nightWeight = 1
    elseif clock > 4.5 and clock < 7.5 then
        local progress = (clock - 4.5) / 3.0
        twilightWeight = 1 - math.abs(progress - 0.5) * 2
        if progress < 0.5 then
            nightWeight = 1 - progress * 2
        else
            dayWeight = (progress - 0.5) * 2
        end
    end

    local total = dayWeight + nightWeight + twilightWeight
    if total > 0 then
        dayWeight = dayWeight / total
        nightWeight = nightWeight / total
        twilightWeight = twilightWeight / total
    else
        dayWeight = 1
    end

    local targetAmbient = blendColor3(DAY_LIGHTING.Ambient, NIGHT_LIGHTING.Ambient, SUNSET_LIGHTING.Ambient, dayWeight, nightWeight, twilightWeight)
    local targetOutdoor = blendColor3(DAY_LIGHTING.OutdoorAmbient, NIGHT_LIGHTING.OutdoorAmbient, SUNSET_LIGHTING.OutdoorAmbient, dayWeight, nightWeight, twilightWeight)
    local targetShiftTop = blendColor3(DAY_LIGHTING.ColorShift_Top, NIGHT_LIGHTING.ColorShift_Top, SUNSET_LIGHTING.ColorShift_Top, dayWeight, nightWeight, twilightWeight)
    local targetShiftBottom = blendColor3(DAY_LIGHTING.ColorShift_Bottom, NIGHT_LIGHTING.ColorShift_Bottom, SUNSET_LIGHTING.ColorShift_Bottom, dayWeight, nightWeight, twilightWeight)
    local targetBrightness = DAY_LIGHTING.Brightness * dayWeight + NIGHT_LIGHTING.Brightness * nightWeight + SUNSET_LIGHTING.Brightness * twilightWeight

    Lighting.Ambient = targetAmbient
    Lighting.OutdoorAmbient = targetOutdoor
    Lighting.ColorShift_Top = targetShiftTop
    Lighting.ColorShift_Bottom = targetShiftBottom
    Lighting.Brightness = targetBrightness

    if atmosphere then
        atmosphere.Color = blendColor3(DAY_LIGHTING.AtmosphereColor, NIGHT_LIGHTING.AtmosphereColor, SUNSET_LIGHTING.AtmosphereColor, dayWeight, nightWeight, twilightWeight)
        atmosphere.Decay = blendColor3(DAY_LIGHTING.AtmosphereDecay, NIGHT_LIGHTING.AtmosphereDecay, SUNSET_LIGHTING.AtmosphereDecay, dayWeight, nightWeight, twilightWeight)
        atmosphere.Density = DAY_LIGHTING.AtmosphereDensity * dayWeight + NIGHT_LIGHTING.AtmosphereDensity * nightWeight + SUNSET_LIGHTING.AtmosphereDensity * twilightWeight
        atmosphere.Glare = DAY_LIGHTING.AtmosphereGlare * dayWeight + NIGHT_LIGHTING.AtmosphereGlare * nightWeight + SUNSET_LIGHTING.AtmosphereGlare * twilightWeight
        atmosphere.Haze = DAY_LIGHTING.AtmosphereHaze * dayWeight + NIGHT_LIGHTING.AtmosphereHaze * nightWeight + SUNSET_LIGHTING.AtmosphereHaze * twilightWeight
    end

    if sunRays then
        sunRays.Intensity = DAY_LIGHTING.SunRaysIntensity * dayWeight + NIGHT_LIGHTING.SunRaysIntensity * nightWeight + SUNSET_LIGHTING.SunRaysIntensity * twilightWeight
    end

    if clouds then
        clouds.Color = blendColor3(DAY_LIGHTING.CloudColor, NIGHT_LIGHTING.CloudColor, SUNSET_LIGHTING.CloudColor, dayWeight, nightWeight, twilightWeight)
    end
end

-- ----------------------------------------------------
-- 2. Sound Ambience Crossfade
-- ----------------------------------------------------
local DAY_AUDIO_VOLUME = 0.15 -- Сниженная громкость дневной музыки (было 0.5)
local NIGHT_AUDIO_VOLUME = 0.35 -- Громкость ночной музыки

local function crossfadeAudio(isNight: boolean, duration: number)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if daySound then
        local target = isNight and 0.0 or DAY_AUDIO_VOLUME
        TweenService:Create(daySound, tweenInfo, { Volume = target }):Play()
    end
    if nightSound then
        local target = isNight and NIGHT_AUDIO_VOLUME or 0.0
        TweenService:Create(nightSound, tweenInfo, { Volume = target }):Play()
    end
end

-- ----------------------------------------------------
-- 4. Stylized Cartoon UI Controller (Bottom-Right)
-- ----------------------------------------------------
local SUN_ICON_ID = "rbxassetid://133820282809732"
local MOON_ICON_ID = "rbxassetid://116374149058909"

local playerGui = player:WaitForChild("PlayerGui")
local dayNightGui = playerGui:WaitForChild("DayNightGui", 10) or playerGui:WaitForChild("MainHUD", 10)

local container = dayNightGui and (dayNightGui:FindFirstChild("DayNightContainer", true) :: Frame?)
local bevelBase = container and (container:FindFirstChild("BevelBase") :: Frame?)
local mainFrame = container and (container:FindFirstChild("MainFrame") :: Frame?) or (dayNightGui and dayNightGui:FindFirstChild("MainFrame", true) :: Frame?)
local cardScale = mainFrame and (mainFrame:FindFirstChild("CardScale") :: UIScale?)
local bgGradient = mainFrame and (mainFrame:FindFirstChild("BgGradient") :: UIGradient?)
local frameStroke = mainFrame and (mainFrame:FindFirstChild("FrameStroke") :: UIStroke?)
local iconContainer = mainFrame and (mainFrame:FindFirstChild("IconContainer") :: Frame?)
local iconStroke = iconContainer and (iconContainer:FindFirstChild("IconStroke") :: UIStroke?)
local iconLabel = iconContainer and (iconContainer:FindFirstChild("IconLabel") :: ImageLabel?)
local textContainer = mainFrame and (mainFrame:FindFirstChild("TextContainer") :: Frame?)
local titleLabel = textContainer and (textContainer:FindFirstChild("TitleLabel") :: TextLabel?)
local titleStroke = titleLabel and (titleLabel:FindFirstChild("TitleStroke") :: UIStroke?)
local timerLabel = textContainer and (textContainer:FindFirstChild("TimerLabel") :: TextLabel?)
local timerStroke = timerLabel and (timerLabel:FindFirstChild("TimerStroke") :: UIStroke?)
local progressTrack = textContainer and (textContainer:FindFirstChild("ProgressTrack") :: Frame?)
local progressFill = progressTrack and (progressTrack:FindFirstChild("ProgressFill") :: Frame?)

local function formatMMSS(seconds: number): string
    local s = math.max(0, math.floor(seconds))
    local m = math.floor(s / 60)
    local rem = s % 60
    return string.format("%02d:%02d", m, rem)
end

local DAY_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(245, 125, 25))
})

local NIGHT_GRADIENT = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(44, 32, 85)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 14, 40))
})

local function applyUiPhase(isNight: boolean, isInitial: boolean)
    if not mainFrame then return end

    local duration = isInitial and 0.1 or 0.6
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    if bgGradient then
        bgGradient.Color = isNight and NIGHT_GRADIENT or DAY_GRADIENT
    end

    if bevelBase then
        local targetBevel = isNight and Color3.fromRGB(10, 8, 26) or Color3.fromRGB(185, 75, 12)
        TweenService:Create(bevelBase, tweenInfo, { BackgroundColor3 = targetBevel }):Play()
    end

    if frameStroke then
        local targetStroke = isNight and Color3.fromRGB(165, 140, 245) or Color3.fromRGB(255, 255, 255)
        TweenService:Create(frameStroke, tweenInfo, { Color = targetStroke }):Play()
    end

    if iconContainer then
        local targetIconBg = isNight and Color3.fromRGB(28, 20, 56) or Color3.fromRGB(255, 255, 255)
        TweenService:Create(iconContainer, tweenInfo, { BackgroundColor3 = targetIconBg }):Play()
    end

    if iconStroke then
        local targetIconStroke = isNight and Color3.fromRGB(180, 150, 255) or Color3.fromRGB(255, 210, 85)
        TweenService:Create(iconStroke, tweenInfo, { Color = targetIconStroke }):Play()
    end

    if iconLabel and iconLabel:IsA("ImageLabel") then
        iconLabel.Image = isNight and MOON_ICON_ID or SUN_ICON_ID
        iconLabel.Size = UDim2.new(0, 42, 0, 42)
    end

    if titleLabel then
        titleLabel.Text = isNight and "НОЧЬ" or "ДЕНЬ"
        local targetTitleColor = isNight and Color3.fromRGB(225, 220, 255) or Color3.fromRGB(255, 255, 255)
        TweenService:Create(titleLabel, tweenInfo, { TextColor3 = targetTitleColor }):Play()
    end

    if titleStroke then
        local targetTitleStroke = isNight and Color3.fromRGB(15, 10, 35) or Color3.fromRGB(160, 65, 10)
        TweenService:Create(titleStroke, tweenInfo, { Color = targetTitleStroke }):Play()
    end

    if timerLabel then
        local targetTimerColor = isNight and Color3.fromRGB(165, 225, 255) or Color3.fromRGB(255, 255, 255)
        TweenService:Create(timerLabel, tweenInfo, { TextColor3 = targetTimerColor }):Play()
    end

    if timerStroke then
        local targetTimerStroke = isNight and Color3.fromRGB(15, 10, 35) or Color3.fromRGB(150, 55, 10)
        TweenService:Create(timerStroke, tweenInfo, { Color = targetTimerStroke }):Play()
    end

    if progressTrack then
        local targetTrackColor = isNight and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(140, 50, 10)
        TweenService:Create(progressTrack, tweenInfo, { BackgroundColor3 = targetTrackColor }):Play()
    end

    if progressFill then
        local targetFillColor = isNight and Color3.fromRGB(155, 125, 250) or Color3.fromRGB(255, 245, 140)
        TweenService:Create(progressFill, tweenInfo, { BackgroundColor3 = targetFillColor }):Play()
    end
end

local lastPhase = ""
local function checkPhaseChange(newPhase: string, isInitial: boolean)
    if newPhase == lastPhase then return end
    lastPhase = newPhase
    local isNight = (newPhase == "Night")

    local transitionDuration = isInitial and 0.1 or 4.0
    crossfadeAudio(isNight, transitionDuration)
    applyUiPhase(isNight, isInitial)
end

-- ----------------------------------------------------
-- 5. Shooting Star / Comet Spawner
-- ----------------------------------------------------
local function spawnComet()
    local startPos = Vector3.new(
        math.random(-500, 500),
        math.random(320, 460),
        math.random(-500, 500)
    )

    local angle = math.random() * math.pi * 2
    local travelDistance = math.random(400, 600)
    local dropDistance = math.random(100, 200)

    local endPos = startPos + Vector3.new(
        math.cos(angle) * travelDistance,
        -dropDistance,
        math.sin(angle) * travelDistance
    )

    local comet = Instance.new("Part")
    comet.Name = "ShootingStar"
    comet.Shape = Enum.PartType.Ball
    comet.Size = Vector3.new(2.5, 2.5, 2.5)
    comet.Position = startPos
    comet.Color = Color3.fromRGB(255, 255, 220)
    comet.Material = Enum.Material.Neon
    comet.Anchored = true
    comet.CanCollide = false
    comet.CanTouch = false
    comet.CanQuery = false
    comet.CastShadow = false

    local att0 = Instance.new("Attachment")
    att0.Position = Vector3.new(0, 1, 0)
    att0.Parent = comet

    local att1 = Instance.new("Attachment")
    att1.Position = Vector3.new(0, -1, 0)
    att1.Parent = comet

    local trail = Instance.new("Trail")
    trail.Attachment0 = att0
    trail.Attachment1 = att1
    trail.Lifetime = 0.85
    trail.LightEmission = 1
    trail.LightInfluence = 0
    trail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 225, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 215, 255))
    })
    trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 0.4),
        NumberSequenceKeypoint.new(1, 1)
    })
    trail.Parent = comet

    comet.Parent = workspace

    local flyTime = 1.8 + math.random() * 0.7
    local tween = TweenService:Create(
        comet,
        TweenInfo.new(flyTime, Enum.EasingStyle.Linear),
        { Position = endPos }
    )
    tween:Play()

    task.delay(flyTime, function()
        comet.Transparency = 1
        task.wait(trail.Lifetime + 0.1)
        comet:Destroy()
    end)
end

task.spawn(function()
    while true do
        local isNight = (currentPhaseVal.Value == "Night")
        local delaySeconds = isNight and math.random(25, 45) or math.random(40, 60)
        task.wait(delaySeconds)
        pcall(spawnComet)
    end
end)

-- ----------------------------------------------------
-- Main Render / Update Loop
-- ----------------------------------------------------
checkPhaseChange(currentPhaseVal.Value, true)

currentPhaseVal.Changed:Connect(function(newPhase)
    checkPhaseChange(newPhase, false)
end)

RunService.RenderStepped:Connect(function()
    updateLightingVisuals()

    local remaining = timeUntilNextVal.Value
    local phase = currentPhaseVal.Value
    local isNight = (phase == "Night")

    if timerLabel then
        timerLabel.Text = formatMMSS(remaining)
    end

    if titleLabel then
        titleLabel.Text = isNight and "НОЧЬ" or "ДЕНЬ"
    end

    if progressFill then
        local duration = isNight and (nightDurationVal and nightDurationVal.Value or 300) or (dayDurationVal and dayDurationVal.Value or 300)
        local progress = math.clamp(1 - (remaining / duration), 0, 1)
        progressFill.Size = UDim2.new(progress, 0, 1, 0)
    end
end)

print("[DayNightClient] Restored original system initialized successfully.")
