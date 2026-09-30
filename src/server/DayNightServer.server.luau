--!strict
-- DayNightServer: Master server controller for 10-minute cycle (5m day / 5m night)
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local folder = ReplicatedStorage:WaitForChild("DayNightSystem")
local cycleDurationVal = folder:WaitForChild("CycleDuration") :: NumberValue
local dayDurationVal = folder:WaitForChild("DayDuration") :: NumberValue
local nightDurationVal = folder:WaitForChild("NightDuration") :: NumberValue
local timeOfDayVal = folder:WaitForChild("TimeOfDaySeconds") :: NumberValue
local currentPhaseVal = folder:WaitForChild("CurrentPhase") :: StringValue
local timeUntilNextVal = folder:WaitForChild("TimeUntilNextPhase") :: NumberValue

-- Durations (5 min = 300 sec, total = 600 sec)
local DAY_DURATION = dayDurationVal.Value
local NIGHT_DURATION = nightDurationVal.Value
local TOTAL_DURATION = DAY_DURATION + NIGHT_DURATION

local currentTime = timeOfDayVal.Value

-- Time multiplier (useful for testing or fast preview: 1 = normal real-time)
local TIME_SCALE = folder:GetAttribute("TimeScale") or 1

folder:GetAttributeChangedSignal("TimeScale"):Connect(function()
    TIME_SCALE = folder:GetAttribute("TimeScale") or 1
end)

-- Sync external updates to TimeOfDaySeconds (e.g. from debug or admin commands)
timeOfDayVal:GetPropertyChangedSignal("Value"):Connect(function()
    if math.abs(timeOfDayVal.Value - currentTime) > 0.5 then
        currentTime = timeOfDayVal.Value % TOTAL_DURATION
    end
end)

-- Main server synchronization loop
RunService.Heartbeat:Connect(function(dt)
    currentTime = (currentTime + dt * TIME_SCALE) % TOTAL_DURATION
    timeOfDayVal.Value = currentTime

    -- ClockTime calculation: 6:00 (dawn) to 18:00 (dusk) during day, 18:00 to 6:00 during night
    local clockTime = (currentTime / TOTAL_DURATION) * 24 + 6
    if clockTime >= 24 then
        clockTime = clockTime - 24
    end
    Lighting.ClockTime = clockTime

    -- Determine phase and remaining time
    if currentTime < DAY_DURATION then
        currentPhaseVal.Value = "Day"
        timeUntilNextVal.Value = math.max(0, DAY_DURATION - currentTime)
    else
        currentPhaseVal.Value = "Night"
        timeUntilNextVal.Value = math.max(0, TOTAL_DURATION - currentTime)
    end
end)

print("[DayNightServer] Master cycle initiated (Day: " .. DAY_DURATION .. "s, Night: " .. NIGHT_DURATION .. "s).")
