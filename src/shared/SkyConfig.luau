--!strict
-- SkyConfig: Configuration and asset metadata for Anime Sky (Asset ID: 13107361022)

export type SkyProperties = {
	AssetId: string,
	Name: string,
	SkyboxBk: string,
	SkyboxDn: string,
	SkyboxFt: string,
	SkyboxLf: string,
	SkyboxRt: string,
	SkyboxUp: string,
	SunTextureId: string,
	MoonTextureId: string,
	SunAngularSize: number,
	MoonAngularSize: number,
	StarCount: number,
	CelestialBodiesShown: boolean,
}

local SkyConfig = {
	AssetId = "13107361022",
	Name = "AnimeSky",
	SkyboxBk = "rbxassetid://13107325341",
	SkyboxDn = "rbxassetid://13107329809",
	SkyboxFt = "rbxassetid://13107334845",
	SkyboxLf = "rbxassetid://13107337703",
	SkyboxRt = "rbxassetid://13107340396",
	SkyboxUp = "rbxassetid://13107344387",
	SunTextureId = "rbxasset://sky/sun.jpg",
	MoonTextureId = "rbxasset://sky/moon.jpg",
	SunAngularSize = 21,
	MoonAngularSize = 11,
	StarCount = 3000,
	CelestialBodiesShown = true,
}

--- Creates and returns a new Sky instance configured with Anime Sky properties
function SkyConfig.createSkyInstance(): Sky
	local sky = Instance.new("Sky")
	sky.Name = SkyConfig.Name
	sky.SkyboxBk = SkyConfig.SkyboxBk
	sky.SkyboxDn = SkyConfig.SkyboxDn
	sky.SkyboxFt = SkyConfig.SkyboxFt
	sky.SkyboxLf = SkyConfig.SkyboxLf
	sky.SkyboxRt = SkyConfig.SkyboxRt
	sky.SkyboxUp = SkyConfig.SkyboxUp
	sky.SunTextureId = SkyConfig.SunTextureId
	sky.MoonTextureId = SkyConfig.MoonTextureId
	sky.SunAngularSize = SkyConfig.SunAngularSize
	sky.MoonAngularSize = SkyConfig.MoonAngularSize
	sky.StarCount = SkyConfig.StarCount
	sky.CelestialBodiesShown = SkyConfig.CelestialBodiesShown
	return sky
end

--- Applies Anime Sky to the Lighting service, replacing any existing Sky or updating it
function SkyConfig.applyToLighting(lightingService: Lighting?): Sky
	local targetLighting = lightingService or game:GetService("Lighting")
	local existingSky = targetLighting:FindFirstChildOfClass("Sky")

	if existingSky then
		existingSky.SkyboxBk = SkyConfig.SkyboxBk
		existingSky.SkyboxDn = SkyConfig.SkyboxDn
		existingSky.SkyboxFt = SkyConfig.SkyboxFt
		existingSky.SkyboxLf = SkyConfig.SkyboxLf
		existingSky.SkyboxRt = SkyConfig.SkyboxRt
		existingSky.SkyboxUp = SkyConfig.SkyboxUp
		existingSky.SunTextureId = SkyConfig.SunTextureId
		existingSky.MoonTextureId = SkyConfig.MoonTextureId
		existingSky.SunAngularSize = SkyConfig.SunAngularSize
		existingSky.MoonAngularSize = SkyConfig.MoonAngularSize
		existingSky.StarCount = SkyConfig.StarCount
		existingSky.CelestialBodiesShown = SkyConfig.CelestialBodiesShown
		existingSky.Name = SkyConfig.Name
		return existingSky
	else
		local newSky = SkyConfig.createSkyInstance()
		newSky.Parent = targetLighting
		return newSky
	end
end

return SkyConfig
