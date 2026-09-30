--!strict
-- SettingsClient: Complete procedural Settings Panel UI matching promt.txt reference EXACTLY.
-- Meets GEMINI.md tactile standards, mobile scalability, and functional reactive logic.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local LocalizationService = game:GetService("LocalizationService")

local player = Players.LocalPlayer
local gui = script.Parent :: ScreenGui
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

--========================================================
-- LOCALIZATION DICTIONARY (Auto-detects Roblox player language)
--========================================================
local DICTIONARY: { [string]: { [string]: string } } = {
	en = {
		SETTINGS = "SETTINGS",
		HUD_SHOP = "SHOP",
		HUD_INDEX = "INDEX",
		HUD_SETTINGS = "SETTINGS",
		HUD_INVENTORY = "INVENTORY",
		HUD_EGG = "EGGS",
		HUD_GIFT = "GIFTS",
		SUBTITLE = "Customize your game experience",
		AUDIO = "Audio",
		SOUND = "Sound",
		MUSIC = "Music",
		PERFORMANCE = "Performance",
		GRAPHICS = "Graphics",
		PARTICLES = "Particles",
		SHADOWS = "Shadows",
		RESET = "RESET",
		RESET_DONE = "RESET DONE",
		APPLY = "APPLY",
		APPLIED = "APPLIED!",
	},
	ru = {
		SETTINGS = "НАСТРОЙКИ",
		HUD_SHOP = "МАГАЗИН",
		HUD_INDEX = "ИНДЕКС",
		HUD_SETTINGS = "НАСТРОЙКИ",
		HUD_INVENTORY = "ИНВЕНТАРЬ",
		HUD_EGG = "ЯЙЦА",
		HUD_GIFT = "ПОДАРКИ",
		SUBTITLE = "Настройте игровой процесс",
		AUDIO = "Звук",
		SOUND = "Звуки",
		MUSIC = "Музыка",
		PERFORMANCE = "Производительность",
		GRAPHICS = "Графика",
		PARTICLES = "Частицы",
		SHADOWS = "Тени",
		RESET = "СБРОС",
		RESET_DONE = "СБРОШЕНО",
		APPLY = "ПРИМЕНИТЬ",
		APPLIED = "ПРИМЕНЕНО!",
	},
	es = {
		SETTINGS = "AJUSTES",
		HUD_SHOP = "TIENDA",
		HUD_INDEX = "ÍNDICE",
		HUD_SETTINGS = "AJUSTES",
		HUD_INVENTORY = "INVENTARIO",
		HUD_EGG = "HUEVOS",
		HUD_GIFT = "REGALOS",
		SUBTITLE = "Personaliza tu experiencia",
		AUDIO = "Audio",
		SOUND = "Sonido",
		MUSIC = "Música",
		PERFORMANCE = "Rendimiento",
		GRAPHICS = "Gráficos",
		PARTICLES = "Partículas",
		SHADOWS = "Sombras",
		RESET = "REINICIAR",
		RESET_DONE = "REINICIADO",
		APPLY = "APLICAR",
		APPLIED = "¡APLICADO!",
	},
	pt = {
		SETTINGS = "CONFIGURAÇÕES",
		HUD_SHOP = "LOJA",
		HUD_INDEX = "ÍNDICE",
		HUD_SETTINGS = "AJUSTES",
		HUD_INVENTORY = "INVENTÁRIO",
		HUD_EGG = "OVOS",
		HUD_GIFT = "PRESENTES",
		SUBTITLE = "Personalize sua experiência",
		AUDIO = "Áudio",
		SOUND = "Sons",
		MUSIC = "Música",
		PERFORMANCE = "Desempenho",
		GRAPHICS = "Gráficos",
		PARTICLES = "Partículas",
		SHADOWS = "Sombras",
		RESET = "REDEFINIR",
		RESET_DONE = "REDEFINIDO",
		APPLY = "APLICAR",
		APPLIED = "APLICADO!",
	},
	de = {
		SETTINGS = "EINSTELLUNGEN",
		HUD_SHOP = "SHOP",
		HUD_INDEX = "INDEX",
		HUD_SETTINGS = "OPTIONEN",
		HUD_INVENTORY = "INVENTAR",
		HUD_EGG = "EIER",
		HUD_GIFT = "GESCHENKE",
		SUBTITLE = "Passe dein Spielerlebnis an",
		AUDIO = "Audio",
		SOUND = "Sound",
		MUSIC = "Musik",
		PERFORMANCE = "Leistung",
		GRAPHICS = "Grafik",
		PARTICLES = "Partikel",
		SHADOWS = "Schatten",
		RESET = "ZURÜCKSETZEN",
		RESET_DONE = "ZURÜCKGESETZT",
		APPLY = "ANWENDEN",
		APPLIED = "ANGEWENDET!",
	},
	fr = {
		SETTINGS = "PARAMÈTRES",
		HUD_SHOP = "BOUTIQUE",
		HUD_INDEX = "INDEX",
		HUD_SETTINGS = "OPTIONS",
		HUD_INVENTORY = "INVENTAIRE",
		HUD_EGG = "OEUFS",
		HUD_GIFT = "CADEAUX",
		SUBTITLE = "Personnalisez votre expérience",
		AUDIO = "Audio",
		SOUND = "Son",
		MUSIC = "Musique",
		PERFORMANCE = "Performances",
		GRAPHICS = "Graphismes",
		PARTICLES = "Particules",
		SHADOWS = "Ombres",
		RESET = "RÉINITIALISER",
		RESET_DONE = "RÉINITIALISÉ",
		APPLY = "APPLIQUER",
		APPLIED = "APPLIQUÉ !",
	},
	tr = {
		SETTINGS = "AYARLAR",
		HUD_SHOP = "MAĞAZA",
		HUD_INDEX = "DİZİN",
		HUD_SETTINGS = "AYARLAR",
		HUD_INVENTORY = "ENVANTER",
		HUD_EGG = "YUMURTALAR",
		HUD_GIFT = "HEDİYELER",
		SUBTITLE = "Oyun deneyiminizi özelleştirin",
		AUDIO = "Ses",
		SOUND = "Sesler",
		MUSIC = "Música",
		PERFORMANCE = "Performans",
		GRAPHICS = "Grafikler",
		PARTICLES = "Parçacıklar",
		SHADOWS = "Gölgeler",
		RESET = "SIFIRLA",
		RESET_DONE = "SIFIRLANDI",
		APPLY = "UYGULA",
		APPLIED = "UYGULANDI!",
	},
	uk = {
		SETTINGS = "НАЛАШТУВАННЯ",
		HUD_SHOP = "МАГАЗИН",
		HUD_INDEX = "ІНДЕКС",
		HUD_SETTINGS = "НАЛАШТУВАННЯ",
		HUD_INVENTORY = "ІНВЕНТАР",
		HUD_EGG = "ЯЙЦЯ",
		HUD_GIFT = "ПОДАРУНКИ",
		SUBTITLE = "Налаштуйте ігровий процес",
		AUDIO = "Звук",
		SOUND = "Звуки",
		MUSIC = "Музика",
		PERFORMANCE = "Продуктивність",
		GRAPHICS = "Графіка",
		PARTICLES = "Частинки",
		SHADOWS = "Тіні",
		RESET = "СКИДАННЯ",
		RESET_DONE = "СКИHYTO",
		APPLY = "ЗАСТОСУВАТИ",
		APPLIED = "ЗАСТОСОВАНО!",
	},
	pl = {
		SETTINGS = "USTAWIENIA",
		HUD_SHOP = "SKLEP",
		HUD_INDEX = "INDEKS",
		HUD_SETTINGS = "OPCJE",
		HUD_INVENTORY = "EKWIPUNEK",
		HUD_EGG = "JAJKA",
		HUD_GIFT = "PREZENTY",
		SUBTITLE = "Dostosuj swoje wrażenia z gry",
		AUDIO = "Dźwięk",
		SOUND = "Dźwięki",
		MUSIC = "Muzyka",
		PERFORMANCE = "Wydajność",
		GRAPHICS = "Grafika",
		PARTICLES = "Cząsteczki",
		SHADOWS = "Cienie",
		RESET = "ZRESETUJ",
		RESET_DONE = "ZRESETOWANO",
		APPLY = "ZASTOSUJ",
		APPLIED = "ZASTOSOWANO!",
	},
	id = {
		SETTINGS = "PENGATURAN",
		HUD_SHOP = "TOKO",
		HUD_INDEX = "INDEKS",
		HUD_SETTINGS = "PENGATURAN",
		HUD_INVENTORY = "INVENTARIS",
		HUD_EGG = "TELUR",
		HUD_GIFT = "HADIAH",
		SUBTITLE = "Sesuaikan pengalaman bermainmu",
		AUDIO = "Audio",
		SOUND = "Suara",
		MUSIC = "Musik",
		PERFORMANCE = "Performa",
		GRAPHICS = "Grafis",
		PARTICLES = "Partikel",
		SHADOWS = "Bayangan",
		RESET = "RESET",
		RESET_DONE = "SELESAI",
		APPLY = "TERAPKAN",
		APPLIED = "DITERAPKAN!",
	},
	zh = {
		SETTINGS = "设置",
		HUD_SHOP = "商店",
		HUD_INDEX = "图鉴",
		HUD_SETTINGS = "设置",
		HUD_INVENTORY = "背包",
		HUD_EGG = "宠物蛋",
		HUD_GIFT = "礼物",
		SUBTITLE = "自定义您的游戏体验",
		AUDIO = "音频",
		SOUND = "声音",
		MUSIC = "音乐",
		PERFORMANCE = "性能",
		GRAPHICS = "图形",
		PARTICLES = "粒子",
		SHADOWS = "阴影",
		RESET = "重置",
		RESET_DONE = "已重置",
		APPLY = "应用",
		APPLIED = "已应用！",
	},
	ja = {
		SETTINGS = "設定",
		HUD_SHOP = "ショップ",
		HUD_INDEX = "図鑑",
		HUD_SETTINGS = "設定",
		HUD_INVENTORY = "インベントリ",
		HUD_EGG = "タマゴ",
		HUD_GIFT = "プレゼント",
		SUBTITLE = "ゲーム体験をカスタマイズ",
		AUDIO = "オーディオ",
		SOUND = "サウンド",
		MUSIC = "音楽",
		PERFORMANCE = "パフォーマンス",
		GRAPHICS = "グラフィック",
		PARTICLES = "パーティクル",
		SHADOWS = "影",
		RESET = "リセット",
		RESET_DONE = "完了",
		APPLY = "適用",
		APPLIED = "適用済み！",
	},
	ko = {
		SETTINGS = "설정",
		HUD_SHOP = "상점",
		HUD_INDEX = "도감",
		HUD_SETTINGS = "설정",
		HUD_INVENTORY = "인벤토리",
		HUD_EGG = "알",
		HUD_GIFT = "선물",
		SUBTITLE = "게임 환경을 설정하세요",
		AUDIO = "오디오",
		SOUND = "사운드",
		MUSIC = "음악",
		PERFORMANCE = "성능",
		GRAPHICS = "그래픽",
		PARTICLES = "파티클",
		SHADOWS = "그림자",
		RESET = "초기화",
		RESET_DONE = "완료",
		APPLY = "적용",
		APPLIED = "적용됨!",
	},
}

local function getPlayerLanguageCode(): string
	local locale = player.LocaleId
	if not locale or locale == "" then
		pcall(function()
			locale = LocalizationService.RobloxLocaleId
		end)
	end
	if not locale or locale == "" then
		pcall(function()
			locale = LocalizationService.SystemLocaleId
		end)
	end
	if locale and locale ~= "" then
		local langPrefix = locale:sub(1, 2):lower()
		if DICTIONARY[langPrefix] then
			return langPrefix
		end
	end
	return "en"
end

local function getText(key: string): string
	local lang = getPlayerLanguageCode()
	local dict = DICTIONARY[lang] or DICTIONARY.en
	return dict[key] or DICTIONARY.en[key] or key
end

--========================================================
-- CONSTANTS & COLOR PALETTE
--========================================================
-- MainFrame: Dark deep navy/black RGB(11, 14, 21) with thicker outer border
local COLOR_MAIN_BG = Color3.fromRGB(11, 14, 21)
local MAIN_BG_TRANSPARENCY = 0.04
local COLOR_MAIN_STROKE = Color3.fromRGB(5, 7, 11)
local MAIN_STROKE_THICKNESS = 6

-- Internal Blocks (Audio, Performance, Graphics):
-- Darker card background (RGB 7, 9, 14) and clear stroke
local COLOR_BLOCK_BG = Color3.fromRGB(7, 9, 14)
local COLOR_BLOCK_STROKE = Color3.fromRGB(50, 60, 80)
local BLOCK_STROKE_TRANSPARENCY = 0.25

-- Softer & warmer accent blue (replaces harsh neon cyan)
local COLOR_ACCENT = Color3.fromRGB(95, 170, 235)
local COLOR_ACCENT_HOVER = Color3.fromRGB(115, 185, 245)
local COLOR_ACCENT_STROKE = Color3.fromRGB(160, 210, 255)

local COLOR_TEXT_WHITE = Color3.fromRGB(255, 255, 255)
local COLOR_TEXT_SUBTITLE = Color3.fromRGB(150, 150, 150)
local COLOR_DARK_BTN = Color3.fromRGB(30, 35, 45)
local COLOR_SLIDER_TRACK = Color3.fromRGB(22, 28, 38)
local COLOR_CONTROL_STROKE = Color3.fromRGB(45, 55, 70)

local GEAR_ICON_ID = "rbxassetid://17368089841"
local SHOP_ICON_ID = "rbxassetid://79989192301898" -- 3D Red Shopping Basket (Asset 80349462371432)
local COLOR_SHOP_BG = Color3.fromRGB(0, 145, 235)
local COLOR_SHOP_BG_TOP = Color3.fromRGB(45, 215, 255)
local COLOR_SHOP_BEVEL = Color3.fromRGB(0, 90, 170)
local COLOR_SHOP_STROKE = Color3.fromRGB(160, 240, 255)

local BOOK_ICON_ID = "rbxassetid://127110909372919" -- 3D Blue Book Icon (Asset 113745763810297)
local COLOR_INDEX_BG = Color3.fromRGB(110, 30, 205)
local COLOR_INDEX_BG_TOP = Color3.fromRGB(165, 75, 245)
local COLOR_INDEX_BEVEL = Color3.fromRGB(70, 15, 145)
local COLOR_INDEX_STROKE = Color3.fromRGB(215, 160, 255)

local INVENTORY_ICON_ID = "rbxassetid://18224282235" -- 3D Backpack Icon (Asset 18224282281)
local COLOR_INVENTORY_BG = Color3.fromRGB(18, 145, 95)
local COLOR_INVENTORY_BG_TOP = Color3.fromRGB(42, 205, 135)
local COLOR_INVENTORY_BEVEL = Color3.fromRGB(12, 95, 60)
local COLOR_INVENTORY_STROKE = Color3.fromRGB(140, 245, 190)

local EGG_ICON_ID = "rbxassetid://17368104272" -- 3D Egg with Black Outline (by Matt746_2)
local COLOR_EGG_BG = Color3.fromRGB(225, 45, 95)
local COLOR_EGG_BG_TOP = Color3.fromRGB(255, 95, 145)
local COLOR_EGG_BEVEL = Color3.fromRGB(160, 25, 65)
local COLOR_EGG_STROKE = Color3.fromRGB(255, 175, 210)

local GIFT_ICON_ID = "rbxassetid://114440493073627" -- 3D Gift Box Icon with Ribbon & Black Outline (Asset 123818257119451)
local COLOR_GIFT_BG = Color3.fromRGB(235, 130, 20)
local COLOR_GIFT_BG_TOP = Color3.fromRGB(255, 175, 45)
local COLOR_GIFT_BEVEL = Color3.fromRGB(165, 80, 10)
local COLOR_GIFT_STROKE = Color3.fromRGB(255, 220, 140)

-- Default state values
local State = {
	Sound = 1.0,
	Music = 0.60,
	PerfParticles = true,
	PerfShadows = true,
	GfxParticles = true,
	GfxShadows = true,
	IsOpen = false,
	Busy = false,
	IsDraggingSlider = false, -- Protection against accidental closes while dragging
}

--========================================================
-- HELPER FUNCTIONS
--========================================================
local function corner(parent: Instance, radius: number): UICorner
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function stroke(parent: Instance, thickness: number, color: Color3, transparency: number?): UIStroke
	local s = Instance.new("UIStroke")
	s.Thickness = thickness
	s.Color = color
	s.Transparency = transparency or 0
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function padding(parent: Instance, top: number, bottom: number, left: number, right: number): UIPadding
	local p = Instance.new("UIPadding")
	p.PaddingTop = UDim.new(0, top)
	p.PaddingBottom = UDim.new(0, bottom)
	p.PaddingLeft = UDim.new(0, left)
	p.PaddingRight = UDim.new(0, right)
	p.Parent = parent
	return p
end

local function list(parent: Instance, dir: Enum.FillDirection, pad: number): UIListLayout
	local l = Instance.new("UIListLayout")
	l.FillDirection = dir
	l.SortOrder = Enum.SortOrder.LayoutOrder
	l.Padding = UDim.new(0, pad)
	l.Parent = parent
	return l
end

--========================================================
-- 1. DIM OVERLAY (Backdrop)
--========================================================
local dimOverlay = Instance.new("TextButton")
dimOverlay.Name = "DimOverlay"
dimOverlay.Text = ""
dimOverlay.AutoButtonColor = false
dimOverlay.Size = UDim2.fromScale(1, 1)
dimOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dimOverlay.BackgroundTransparency = 1
dimOverlay.Visible = false
dimOverlay.ZIndex = 1
dimOverlay.Parent = gui

--========================================================
-- 2. MAIN SETTINGS PANEL (Outer Border + Inner Block Architecture)
-- Eliminates corner gaps (просвет) by using UIPadding with matching UICorner
--========================================================
local mainFrame = Instance.new("CanvasGroup")
mainFrame.Name = "SettingsMainFrame"
mainFrame.Active = true -- Sinks all mouse events so clicks inside never fall through to dimOverlay!
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 30)
mainFrame.Size = UDim2.new(0, 460, 0, 440)
mainFrame.BackgroundColor3 = COLOR_MAIN_STROKE -- The outer border color (RGB 5, 7, 11)
mainFrame.GroupTransparency = 1
mainFrame.Visible = false
mainFrame.ZIndex = 2
mainFrame.Parent = gui

corner(mainFrame, 18)
-- Outer UIPadding defines the 6px border thickness all around, replacing manual position/size math!
padding(mainFrame, MAIN_STROKE_THICKNESS, MAIN_STROKE_THICKNESS, MAIN_STROKE_THICKNESS, MAIN_STROKE_THICKNESS)

-- Mobile responsive scaling
local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = mainFrame

local function updateScale()
	local vp = gui.AbsoluteSize
	local targetX = vp.X / 500
	local targetY = vp.Y / 480
	local scale = math.clamp(math.min(targetX, targetY), 0.55, 1.0)
	uiScale.Scale = scale
end
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)
updateScale()

-- Inner Block: Fills 100% of the padded area with the exact same UICorner radius (no corner gaps!)
local innerBlock = Instance.new("Frame")
innerBlock.Name = "InnerBlock"
innerBlock.Active = true
innerBlock.Size = UDim2.fromScale(1, 1)
innerBlock.Position = UDim2.fromScale(0, 0)
innerBlock.BackgroundColor3 = COLOR_MAIN_BG
innerBlock.BackgroundTransparency = MAIN_BG_TRANSPARENCY
innerBlock.BorderSizePixel = 0
innerBlock.Parent = mainFrame

corner(innerBlock, 18) -- Same UICorner radius as mainFrame to eliminate any corner gaps!
padding(innerBlock, 10, 10, 12, 12) -- Inner spacing for the content cards

-- Equal spacing between Header, Audio, Performance, Graphics, Footer
local mainLayout = list(innerBlock, Enum.FillDirection.Vertical, 12)

--========================================================
-- HEADER (White Gear Icon + "SETTINGS" + Subtitle + Centered Vector Cross Close Button)
--========================================================
local headerFrame = Instance.new("Frame")
headerFrame.Name = "Header"
headerFrame.Active = true
headerFrame.LayoutOrder = 1
headerFrame.Size = UDim2.new(1, 0, 0, 44)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = innerBlock

local headerLeft = Instance.new("Frame")
headerLeft.Name = "HeaderLeft"
headerLeft.Size = UDim2.new(1, -48, 1, 0)
headerLeft.BackgroundTransparency = 1
headerLeft.Parent = headerFrame

-- Gear Icon: Raised by 3-4px to align perfectly centered with SETTINGS title and subtitle
local gearIcon = Instance.new("ImageLabel")
gearIcon.Name = "GearIcon"
gearIcon.Size = UDim2.new(0, 28, 0, 28)
gearIcon.AnchorPoint = Vector2.new(0, 0.5)
gearIcon.Position = UDim2.new(0, 0, 0, 19) -- Raised to align evenly with title and subtitle
gearIcon.BackgroundTransparency = 1
gearIcon.Image = GEAR_ICON_ID
gearIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
gearIcon.Parent = headerLeft

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Text = "SETTINGS"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 22
titleLabel.TextColor3 = COLOR_TEXT_WHITE
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1
titleLabel.Position = UDim2.new(0, 38, 0, 0)
titleLabel.Size = UDim2.new(1, -38, 0, 22)
titleLabel.Parent = headerLeft

local subLabel = Instance.new("TextLabel")
subLabel.Name = "SubLabel"
subLabel.Text = "Customize your game experience"
subLabel.Font = Enum.Font.GothamMedium
subLabel.TextSize = 13
subLabel.TextColor3 = COLOR_TEXT_SUBTITLE
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.BackgroundTransparency = 1
subLabel.Position = UDim2.new(0, 38, 0, 22)
subLabel.Size = UDim2.new(1, -38, 0, 16)
subLabel.Parent = headerLeft

-- Right Close Button: Dark rounded square with a perfectly centered geometric vector cross
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.AutoButtonColor = false
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, 0, 0.5, 0)
closeBtn.Size = UDim2.new(0, 36, 0, 36)
closeBtn.BackgroundColor3 = COLOR_DARK_BTN
closeBtn.Text = ""
closeBtn.Parent = headerFrame
corner(closeBtn, 8)
stroke(closeBtn, 1, COLOR_CONTROL_STROKE, 0.3)

local crossContainer = Instance.new("Frame")
crossContainer.Name = "CrossContainer"
crossContainer.AnchorPoint = Vector2.new(0.5, 0.5)
crossContainer.Position = UDim2.fromScale(0.5, 0.5)
crossContainer.Size = UDim2.new(0, 14, 0, 14)
crossContainer.BackgroundTransparency = 1
crossContainer.Parent = closeBtn

local crossBar1 = Instance.new("Frame")
crossBar1.Name = "Bar1"
crossBar1.AnchorPoint = Vector2.new(0.5, 0.5)
crossBar1.Position = UDim2.fromScale(0.5, 0.5)
crossBar1.Size = UDim2.new(1, 0, 0, 2)
crossBar1.Rotation = 45
crossBar1.BackgroundColor3 = Color3.fromRGB(180, 195, 215)
crossBar1.BorderSizePixel = 0
crossBar1.Parent = crossContainer
corner(crossBar1, 999)

local crossBar2 = Instance.new("Frame")
crossBar2.Name = "Bar2"
crossBar2.AnchorPoint = Vector2.new(0.5, 0.5)
crossBar2.Position = UDim2.fromScale(0.5, 0.5)
crossBar2.Size = UDim2.new(1, 0, 0, 2)
crossBar2.Rotation = -45
crossBar2.BackgroundColor3 = Color3.fromRGB(180, 195, 215)
crossBar2.BorderSizePixel = 0
crossBar2.Parent = crossContainer
corner(crossBar2, 999)

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(44, 52, 68),
	}):Play()
	TweenService:Create(crossBar1, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}):Play()
	TweenService:Create(crossBar2, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = COLOR_DARK_BTN,
	}):Play()
	TweenService:Create(crossBar1, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(180, 195, 215),
	}):Play()
	TweenService:Create(crossBar2, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(180, 195, 215),
	}):Play()
end)

--========================================================
-- AUDIO MANAGER (Master & Music SoundGroups + Real-Time Sync)
--========================================================
local function applyAudioVolumes()
	local master = SoundService:FindFirstChild("Master") :: SoundGroup?
	if master and master:IsA("SoundGroup") then
		master.Volume = State.Sound
		local music = master:FindFirstChild("Music") or SoundService:FindFirstChild("Music", true)
		if music and music:IsA("SoundGroup") then
			music.Volume = State.Music
		end
	else
		-- Fallback direct volume routing
		local musicGroup = SoundService:FindFirstChild("Music", true)
		if musicGroup and musicGroup:IsA("SoundGroup") then
			musicGroup.Volume = State.Music * State.Sound
		end
		local sfxGroup = SoundService:FindFirstChild("SFX", true)
		if sfxGroup and sfxGroup:IsA("SoundGroup") then
			sfxGroup.Volume = State.Sound
		end
	end
end

local function ensureAudioSetup()
	local master = SoundService:FindFirstChild("Master") :: SoundGroup?
	if not master or not master:IsA("SoundGroup") then
		master = Instance.new("SoundGroup")
		master.Name = "Master"
		master.Parent = SoundService
	end

	local music = master:FindFirstChild("Music") :: SoundGroup?
	if not music or not music:IsA("SoundGroup") then
		local existingMusic = SoundService:FindFirstChild("Music")
		if existingMusic and existingMusic:IsA("SoundGroup") then
			existingMusic.Parent = master
			music = existingMusic
		else
			music = Instance.new("SoundGroup")
			music.Name = "Music"
			music.Parent = master
		end
	end

	local sfx = master:FindFirstChild("SFX") :: SoundGroup?
	if not sfx or not sfx:IsA("SoundGroup") then
		local existingSfx = SoundService:FindFirstChild("SFX")
		if existingSfx and existingSfx:IsA("SoundGroup") then
			existingSfx.Parent = master
			sfx = existingSfx
		else
			sfx = Instance.new("SoundGroup")
			sfx.Name = "SFX"
			sfx.Parent = master
		end
	end

	local function routeSound(s: Sound)
		if s.SoundGroup == nil then
			local name = s.Name:lower()
			if name:find("music") or name:find("ambience") or name:find("day") or name:find("night") or name:find("bgm") then
				s.SoundGroup = music
			else
				s.SoundGroup = sfx
			end
		end
	end

	for _, desc in ipairs(SoundService:GetDescendants()) do
		if desc:IsA("Sound") then
			routeSound(desc)
		end
	end

	for _, desc in ipairs(workspace:GetDescendants()) do
		if desc:IsA("Sound") then
			routeSound(desc)
		end
	end

	SoundService.DescendantAdded:Connect(function(desc)
		if desc:IsA("Sound") then
			routeSound(desc)
		end
	end)

	applyAudioVolumes()
end

--========================================================
-- SLIDER COMPONENT FACTORY (Symmetric, Sleek 16px Knob, 36px HitArea, Dynamic Drag Connections)
--========================================================
local function createSlider(parent: Instance, labelText: string, initialValue: number)
	local container = Instance.new("Frame")
	container.Name = "Slider_" .. labelText
	container.Active = true
	container.BackgroundTransparency = 1
	container.Size = UDim2.new(0.5, -7, 1, 0)
	container.Parent = parent

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Text = labelText
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextColor3 = COLOR_TEXT_WHITE
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, 0, 0, 18)
	label.Parent = container

	-- Thicker, clearly visible track (6px height), lowered down to Y=28
	local track = Instance.new("Frame")
	track.Name = "Track"
	track.Active = false
	track.Size = UDim2.new(1, 0, 0, 6)
	track.Position = UDim2.new(0, 0, 0, 28)
	track.BackgroundColor3 = COLOR_SLIDER_TRACK
	track.BorderSizePixel = 0
	track.Parent = container
	corner(track, 999)

	local fill = Instance.new("Frame")
	fill.Name = "Fill"
	fill.Active = false
	fill.Size = UDim2.new(initialValue, 0, 1, 0)
	fill.BackgroundColor3 = COLOR_ACCENT
	fill.BorderSizePixel = 0
	fill.Parent = track
	corner(fill, 999)

	-- Sleek, properly proportioned knob (16px diameter, blooms to 18px on hover/drag)
	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.Active = false
	knob.AnchorPoint = Vector2.new(0.5, 0.5)
	knob.Size = UDim2.new(0, 16, 0, 16)
	knob.Position = UDim2.new(initialValue, 0, 0.5, 0)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.ZIndex = 3
	knob.Parent = track
	corner(knob, 999)
	local knobStroke = stroke(knob, 1.2, COLOR_ACCENT, 0.2)

	-- Generous 36px tall HitArea so clicking the whole circle and edges works perfectly
	local hitArea = Instance.new("TextButton")
	hitArea.Name = "HitArea"
	hitArea.Text = ""
	hitArea.AutoButtonColor = false
	hitArea.BackgroundTransparency = 1
	hitArea.AnchorPoint = Vector2.new(0.5, 0.5)
	hitArea.Position = UDim2.new(0.5, 0, 0.5, 0)
	hitArea.Size = UDim2.new(1, 24, 0, 36)
	hitArea.ZIndex = 10
	hitArea.Parent = track

	local value = initialValue
	local isDragging = false
	local isHovered = false
	local onChanged: ((number) -> ())? = nil

	local function updateKnobVisuals()
		local baseSize = (isDragging or isHovered) and 18 or 16
		local targetStrokeTrans = (isDragging or isHovered) and 0.0 or 0.2
		TweenService:Create(knob, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Size = UDim2.new(0, baseSize, 0, baseSize),
		}):Play()
		TweenService:Create(knobStroke, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = targetStrokeTrans,
		}):Play()
	end

	local function setVal(v: number)
		value = math.clamp(v, 0, 1)
		fill.Size = UDim2.new(value, 0, 1, 0)
		knob.Position = UDim2.new(value, 0, 0.5, 0)
		if onChanged then
			onChanged(value)
		end
	end

	local function updateFromPos(posX: number)
		local absX = track.AbsolutePosition.X
		local absW = track.AbsoluteSize.X
		if absW > 0 then
			setVal((posX - absX) / absW)
		end
	end

	hitArea.MouseEnter:Connect(function()
		isHovered = true
		updateKnobVisuals()
	end)

	hitArea.MouseLeave:Connect(function()
		isHovered = false
		if not isDragging then
			updateKnobVisuals()
		end
	end)

	-- Highly optimized dynamic input listeners (0 CPU usage when not dragging)
	local moveConn: RBXScriptConnection? = nil
	local releaseConn: RBXScriptConnection? = nil

	local function cleanupDrag()
		isDragging = false
		if moveConn then
			moveConn:Disconnect()
			moveConn = nil
		end
		if releaseConn then
			releaseConn:Disconnect()
			releaseConn = nil
		end
		updateKnobVisuals()
		task.delay(0.1, function()
			State.IsDraggingSlider = false
		end)
	end

	hitArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			isDragging = true
			State.IsDraggingSlider = true
			updateKnobVisuals()
			updateFromPos(input.Position.X)

			if moveConn then moveConn:Disconnect() end
			if releaseConn then releaseConn:Disconnect() end

			moveConn = UserInputService.InputChanged:Connect(function(moveInput)
				if isDragging and (moveInput.UserInputType == Enum.UserInputType.MouseMovement or moveInput.UserInputType == Enum.UserInputType.Touch) then
					updateFromPos(moveInput.Position.X)
				end
			end)

			releaseConn = UserInputService.InputEnded:Connect(function(endInput)
				if endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch then
					cleanupDrag()
				end
			end)
		end
	end)

	return {
		Get = function() return value end,
		Set = setVal,
		OnChanged = function(fn: (number) -> ())
			onChanged = fn
		end,
		Label = label,
		Container = container,
	}
end

--========================================================
-- SECTION 1 - AUDIO (Sound + Music) - Rounded Card
--========================================================
local audioSection = Instance.new("Frame")
audioSection.Name = "Section_Audio"
audioSection.Active = true
audioSection.LayoutOrder = 2
audioSection.Size = UDim2.new(1, 0, 0, 88)
audioSection.BackgroundColor3 = COLOR_BLOCK_BG
audioSection.BackgroundTransparency = 0
audioSection.BorderSizePixel = 0
audioSection.Parent = innerBlock
corner(audioSection, 14)
stroke(audioSection, 1.2, COLOR_BLOCK_STROKE, BLOCK_STROKE_TRANSPARENCY)
padding(audioSection, 8, 8, 12, 12)
list(audioSection, Enum.FillDirection.Vertical, 6)

local audioTitle = Instance.new("TextLabel")
audioTitle.Name = "SectionTitle"
audioTitle.Text = "Audio"
audioTitle.Font = Enum.Font.GothamBold
audioTitle.TextSize = 15
audioTitle.TextColor3 = COLOR_TEXT_WHITE
audioTitle.TextXAlignment = Enum.TextXAlignment.Left
audioTitle.BackgroundTransparency = 1
audioTitle.Size = UDim2.new(1, 0, 0, 18)
audioTitle.Parent = audioSection

local audioColumns = Instance.new("Frame")
audioColumns.Name = "Columns"
audioColumns.Size = UDim2.new(1, 0, 0, 48)
audioColumns.BackgroundTransparency = 1
audioColumns.Parent = audioSection
list(audioColumns, Enum.FillDirection.Horizontal, 14)

-- Perfectly symmetrical columns for Sound (Master) and Music (BGM)
local soundSlider = createSlider(audioColumns, "Sound", State.Sound)
local musicSlider = createSlider(audioColumns, "Music", State.Music)

-- Real-time reactive audio volume listeners
soundSlider.OnChanged(function(val)
	State.Sound = val
	applyAudioVolumes()
end)

musicSlider.OnChanged(function(val)
	State.Music = val
	applyAudioVolumes()
end)

--========================================================
-- TOGGLE COMPONENT FACTORY (Smaller Toggles)
--========================================================
local function createToggleRow(parent: Instance, labelText: string, initialOn: boolean)
	local row = Instance.new("Frame")
	row.Name = "Row_" .. labelText
	row.Active = true
	row.Size = UDim2.new(1, 0, 0, 26)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Text = labelText
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextColor3 = COLOR_TEXT_WHITE
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(1, -50, 1, 0)
	label.Parent = row

	-- Smaller toggle switch (38x20px)
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "Toggle"
	toggleBtn.AutoButtonColor = false
	toggleBtn.Text = ""
	toggleBtn.AnchorPoint = Vector2.new(1, 0.5)
	toggleBtn.Position = UDim2.new(1, 0, 0.5, 0)
	toggleBtn.Size = UDim2.new(0, 38, 0, 20)
	toggleBtn.BackgroundColor3 = initialOn and COLOR_ACCENT or COLOR_DARK_BTN
	toggleBtn.Parent = row
	corner(toggleBtn, 999)
	stroke(toggleBtn, 1, COLOR_CONTROL_STROKE, 0.3)

	local knob = Instance.new("Frame")
	knob.Name = "Knob"
	knob.AnchorPoint = Vector2.new(0, 0.5)
	knob.Size = UDim2.new(0, 14, 0, 14)
	knob.Position = initialOn and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
	knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	knob.BorderSizePixel = 0
	knob.Parent = toggleBtn
	corner(knob, 999)

	local isOn = initialOn
	local onChanged: ((boolean) -> ())? = nil

	local function setToggle(state: boolean, animate: boolean?)
		isOn = state
		local targetPos = isOn and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
		local targetColor = isOn and COLOR_ACCENT or COLOR_DARK_BTN

		if animate ~= false then
			TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
			TweenService:Create(toggleBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = targetColor}):Play()
		else
			knob.Position = targetPos
			toggleBtn.BackgroundColor3 = targetColor
		end

		if onChanged then
			onChanged(isOn)
		end
	end

	toggleBtn.MouseButton1Click:Connect(function()
		setToggle(not isOn, true)
	end)

	return {
		Get = function() return isOn end,
		Set = setToggle,
		OnChanged = function(fn: (boolean) -> ()) onChanged = fn end,
		Label = label,
		Row = row,
	}
end

--========================================================
-- SECTION 2 - PERFORMANCE - Rounded Dark Card
--========================================================
local perfSection = Instance.new("Frame")
perfSection.Name = "Section_Performance"
perfSection.Active = true
perfSection.LayoutOrder = 3
perfSection.Size = UDim2.new(1, 0, 0, 92)
perfSection.BackgroundColor3 = COLOR_BLOCK_BG
perfSection.BackgroundTransparency = 0
perfSection.BorderSizePixel = 0
perfSection.Parent = innerBlock
corner(perfSection, 14)
stroke(perfSection, 1.2, COLOR_BLOCK_STROKE, BLOCK_STROKE_TRANSPARENCY)
padding(perfSection, 8, 8, 12, 12)
list(perfSection, Enum.FillDirection.Vertical, 5)

local perfTitle = Instance.new("TextLabel")
perfTitle.Name = "SectionTitle"
perfTitle.Text = "Performance"
perfTitle.Font = Enum.Font.GothamBold
perfTitle.TextSize = 15
perfTitle.TextColor3 = COLOR_TEXT_WHITE
perfTitle.TextXAlignment = Enum.TextXAlignment.Left
perfTitle.BackgroundTransparency = 1
perfTitle.Size = UDim2.new(1, 0, 0, 18)
perfTitle.Parent = perfSection

local perfParticles = createToggleRow(perfSection, "Particles", State.PerfParticles)
local perfShadows = createToggleRow(perfSection, "Shadows", State.PerfShadows)

--========================================================
-- SECTION 3 - GRAPHICS - Rounded Dark Card
--========================================================
local gfxSection = Instance.new("Frame")
gfxSection.Name = "Section_Graphics"
gfxSection.Active = true
gfxSection.LayoutOrder = 4
gfxSection.Size = UDim2.new(1, 0, 0, 92)
gfxSection.BackgroundColor3 = COLOR_BLOCK_BG
gfxSection.BackgroundTransparency = 0
gfxSection.BorderSizePixel = 0
gfxSection.Parent = innerBlock
corner(gfxSection, 14)
stroke(gfxSection, 1.2, COLOR_BLOCK_STROKE, BLOCK_STROKE_TRANSPARENCY)
padding(gfxSection, 8, 8, 12, 12)
list(gfxSection, Enum.FillDirection.Vertical, 5)

local gfxTitle = Instance.new("TextLabel")
gfxTitle.Name = "SectionTitle"
gfxTitle.Text = "Graphics"
gfxTitle.Font = Enum.Font.GothamBold
gfxTitle.TextSize = 15
gfxTitle.TextColor3 = COLOR_TEXT_WHITE
gfxTitle.TextXAlignment = Enum.TextXAlignment.Left
gfxTitle.BackgroundTransparency = 1
gfxTitle.Size = UDim2.new(1, 0, 0, 18)
gfxTitle.Parent = gfxSection

local gfxParticles = createToggleRow(gfxSection, "Particles", State.GfxParticles)
local gfxShadows = createToggleRow(gfxSection, "Shadows", State.GfxShadows)

--========================================================
-- FOOTER (RESET ~40% + APPLY ~60% Width Proportions)
--========================================================
local footerFrame = Instance.new("Frame")
footerFrame.Name = "Footer"
footerFrame.Active = true
footerFrame.LayoutOrder = 5
footerFrame.Size = UDim2.new(1, 0, 0, 42)
footerFrame.BackgroundTransparency = 1
footerFrame.Parent = innerBlock
list(footerFrame, Enum.FillDirection.Horizontal, 12)

local resetBtn = Instance.new("TextButton")
resetBtn.Name = "ResetButton"
resetBtn.AutoButtonColor = false
resetBtn.Size = UDim2.new(0.40, -6, 1, 0)
resetBtn.BackgroundColor3 = COLOR_DARK_BTN
resetBtn.Text = "RESET"
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 14
resetBtn.TextColor3 = COLOR_TEXT_WHITE
resetBtn.Parent = footerFrame
corner(resetBtn, 10)
stroke(resetBtn, 1.2, COLOR_CONTROL_STROKE, 0.25)

resetBtn.MouseEnter:Connect(function()
	TweenService:Create(resetBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(45, 53, 68)
	}):Play()
end)
resetBtn.MouseLeave:Connect(function()
	TweenService:Create(resetBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = COLOR_DARK_BTN
	}):Play()
end)

local applyBtn = Instance.new("TextButton")
applyBtn.Name = "ApplyButton"
applyBtn.AutoButtonColor = false
applyBtn.Size = UDim2.new(0.60, -6, 1, 0)
applyBtn.BackgroundColor3 = COLOR_ACCENT
applyBtn.Text = "APPLY"
applyBtn.Font = Enum.Font.GothamBold
applyBtn.TextSize = 14
applyBtn.TextColor3 = COLOR_TEXT_WHITE
applyBtn.Parent = footerFrame
corner(applyBtn, 10)
stroke(applyBtn, 1.2, COLOR_ACCENT_STROKE, 0.35)

applyBtn.MouseEnter:Connect(function()
	TweenService:Create(applyBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = COLOR_ACCENT_HOVER
	}):Play()
end)
applyBtn.MouseLeave:Connect(function()
	TweenService:Create(applyBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = COLOR_ACCENT
	}):Play()
end)

local shopPillLabel: TextLabel? = nil
local indexPillLabel: TextLabel? = nil
local settingsPillLabel: TextLabel? = nil
local inventoryPillLabel: TextLabel? = nil
local eggPillLabel: TextLabel? = nil
local giftPillLabel: TextLabel? = nil

--========================================================
-- LOCALIZATION APPLIER (Binds all UI labels to current player language)
--========================================================
local function applyLocalization()
	titleLabel.Text = getText("SETTINGS")
	subLabel.Text = getText("SUBTITLE")
	audioTitle.Text = getText("AUDIO")
	soundSlider.Label.Text = getText("SOUND")
	musicSlider.Label.Text = getText("MUSIC")
	perfTitle.Text = getText("PERFORMANCE")
	perfParticles.Label.Text = getText("PARTICLES")
	perfShadows.Label.Text = getText("SHADOWS")
	gfxTitle.Text = getText("GRAPHICS")
	gfxParticles.Label.Text = getText("PARTICLES")
	gfxShadows.Label.Text = getText("SHADOWS")
	resetBtn.Text = getText("RESET")
	applyBtn.Text = getText("APPLY")
	if shopPillLabel then
		shopPillLabel.Text = getText("HUD_SHOP")
	end
	if indexPillLabel then
		indexPillLabel.Text = getText("HUD_INDEX")
	end
	if settingsPillLabel then
		settingsPillLabel.Text = getText("HUD_SETTINGS")
	end
	if inventoryPillLabel then
		inventoryPillLabel.Text = getText("HUD_INVENTORY")
	end
	if eggPillLabel then
		eggPillLabel.Text = getText("HUD_EGG")
	end
	if giftPillLabel then
		giftPillLabel.Text = getText("HUD_GIFT")
	end
end

player:GetPropertyChangedSignal("LocaleId"):Connect(applyLocalization)
pcall(function()
	LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(applyLocalization)
end)

--========================================================
-- OPEN / CLOSE ANIMATIONS (Smooth TweenService)
--========================================================
local function openSettings()
	if State.Busy or State.IsOpen then return end
	State.Busy = true
	State.IsOpen = true

	applyLocalization()
	updateScale()
	dimOverlay.Visible = true
	mainFrame.Visible = true

	mainFrame.Position = UDim2.new(0.5, 0, 0.5, 25)
	mainFrame.GroupTransparency = 1

	TweenService:Create(dimOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.55
	}):Play()

	TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		GroupTransparency = 0
	}):Play()

	task.delay(0.26, function()
		State.Busy = false
	end)
end

local function closeSettings()
	if State.Busy or not State.IsOpen then return end
	State.Busy = true
	State.IsOpen = false

	TweenService:Create(dimOverlay, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1
	}):Play()

	local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 25),
		GroupTransparency = 1
	})
	closeTween:Play()

	closeTween.Completed:Connect(function()
		if not State.IsOpen then
			mainFrame.Visible = false
			dimOverlay.Visible = false
		end
		State.Busy = false
	end)
end

closeBtn.MouseButton1Click:Connect(closeSettings)

-- Precision click filtering: Only close if click started OUTSIDE mainFrame and ended OUTSIDE mainFrame!
local function isPointInsideMainFrame(x: number, y: number): boolean
	local absPos = mainFrame.AbsolutePosition
	local absSize = mainFrame.AbsoluteSize
	return x >= absPos.X and x <= (absPos.X + absSize.X) and y >= absPos.Y and y <= (absPos.Y + absSize.Y)
end

local clickStartedOutside = false

dimOverlay.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if not isPointInsideMainFrame(input.Position.X, input.Position.Y) then
			clickStartedOutside = true
		else
			clickStartedOutside = false
		end
	end
end)

dimOverlay.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if State.IsDraggingSlider then
			clickStartedOutside = false
			return
		end
		local x, y = input.Position.X, input.Position.Y
		-- Only close if click both started outside AND ended outside the menu!
		if clickStartedOutside and not isPointInsideMainFrame(x, y) then
			closeSettings()
		end
		clickStartedOutside = false
	end
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.M then
		if State.IsOpen then
			closeSettings()
		else
			openSettings()
		end
	end
end)

-- RESET Logic
resetBtn.MouseButton1Click:Connect(function()
	soundSlider.Set(1.0)
	musicSlider.Set(0.60)
	perfParticles.Set(true)
	perfShadows.Set(true)
	gfxParticles.Set(true)
	gfxShadows.Set(true)

	applyAudioVolumes()

	resetBtn.Text = getText("RESET_DONE")
	task.delay(0.9, function()
		resetBtn.Text = getText("RESET")
	end)
end)

-- APPLY Logic
applyBtn.MouseButton1Click:Connect(function()
	State.Sound = soundSlider.Get()
	State.Music = musicSlider.Get()
	State.PerfParticles = perfParticles.Get()
	State.PerfShadows = perfShadows.Get()
	State.GfxParticles = gfxParticles.Get()
	State.GfxShadows = gfxShadows.Get()

	Lighting.GlobalShadows = State.PerfShadows and State.GfxShadows
	applyAudioVolumes()

	applyBtn.Text = getText("APPLIED")
	task.delay(1.0, function()
		applyBtn.Text = getText("APPLY")
	end)
end)

--========================================================
-- 3. HUD BUTTONS (per GEMINI.md tactile standards)
--========================================================
local bevelDepth = 5

local function createEmbeddedPill(parentButton: GuiObject, strokeColor: Color3): (Frame, TextLabel)
	local pill = Instance.new("Frame")
	pill.Name = "TextPill"
	pill.AnchorPoint = Vector2.new(0.5, 0.5)
	pill.Position = UDim2.new(0.5, 0, 1, 0)
	pill.Size = UDim2.new(0, 80, 0, 24)
	pill.BackgroundColor3 = COLOR_MAIN_BG
	pill.BorderSizePixel = 0
	pill.ZIndex = 5
	pill.Parent = parentButton

	corner(pill, 7)

	local pStroke = stroke(pill, 1.5, strokeColor, 0.15)
	pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 3)
	padding.PaddingRight = UDim.new(0, 3)
	padding.PaddingTop = UDim.new(0, 1)
	padding.PaddingBottom = UDim.new(0, 1)
	padding.Parent = pill

	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.FredokaOne
	label.TextSize = 14
	label.TextScaled = false
	label.TextWrapped = false
	label.TextColor3 = COLOR_TEXT_WHITE
	label.ZIndex = 6
	label.Parent = pill

	return pill, label
end

-- 3A. SHOP HUD BUTTON (Positioned above Settings with bright golden theme)
local shopContainer = Instance.new("Frame")
shopContainer.Name = "ShopHUDButtonContainer"
shopContainer.AnchorPoint = Vector2.new(0, 0.5)
shopContainer.Position = UDim2.new(0, 24, 0.5, -112)
shopContainer.Size = UDim2.new(0, 86, 0, 86)
shopContainer.BackgroundTransparency = 1
shopContainer.ClipsDescendants = false
shopContainer.ZIndex = 5
shopContainer.Parent = gui

local shopBevel = Instance.new("Frame")
shopBevel.Name = "BevelBase"
shopBevel.AnchorPoint = Vector2.new(0.5, 0.5)
shopBevel.Position = UDim2.new(0.5, 0, 0.5, bevelDepth)
shopBevel.Size = UDim2.new(1, 0, 1, 0)
shopBevel.BackgroundColor3 = COLOR_SHOP_BEVEL
shopBevel.BorderSizePixel = 0
shopBevel.ClipsDescendants = false
shopBevel.Parent = shopContainer
corner(shopBevel, 20)

local shopButton = Instance.new("ImageButton")
shopButton.Name = "ShopHUDButton"
shopButton.AutoButtonColor = false
shopButton.AnchorPoint = Vector2.new(0.5, 0.5)
shopButton.Position = UDim2.new(0.5, 0, 0.5, 0)
shopButton.Size = UDim2.new(1, 0, 1, 0)
shopButton.BackgroundColor3 = COLOR_SHOP_BG
shopButton.BorderSizePixel = 0
shopButton.ClipsDescendants = false
shopButton.Parent = shopContainer
corner(shopButton, 20)

local shopGradient = Instance.new("UIGradient")
shopGradient.Rotation = 90
shopGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_SHOP_BG_TOP),
	ColorSequenceKeypoint.new(1, COLOR_SHOP_BG),
})
shopGradient.Parent = shopButton

local shopStroke = stroke(shopButton, 2, COLOR_SHOP_STROKE, 0.20)

local shopIcon = Instance.new("ImageLabel")
shopIcon.Name = "Icon"
shopIcon.AnchorPoint = Vector2.new(0.5, 0.5)
shopIcon.Position = UDim2.new(0.5, 0, 0.5, -6)
shopIcon.Size = UDim2.new(0, 62, 0, 62)
shopIcon.BackgroundTransparency = 1
shopIcon.Image = SHOP_ICON_ID
shopIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
shopIcon.ZIndex = 3
shopIcon.Parent = shopButton

local shopPill, sLabel = createEmbeddedPill(shopButton, COLOR_SHOP_STROKE)
shopPillLabel = sLabel
shopPillLabel.Text = getText("HUD_SHOP")

local shopScale = Instance.new("UIScale")
shopScale.Scale = 1
shopScale.Parent = shopButton

local isShopHovered = false
local isShopPressed = false

local function updateShopButtonFX()
	local targetScale = 1.0
	local targetY = 0
	local targetStrokeTrans = 0.20

	if isShopPressed then
		targetScale = 0.96
		targetY = bevelDepth
		targetStrokeTrans = 0.0
	elseif isShopHovered then
		targetScale = 1.04
		targetY = -2
		targetStrokeTrans = 0.0
	end

	TweenService:Create(shopScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = targetScale
	}):Play()

	TweenService:Create(shopButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, targetY)
	}):Play()

	TweenService:Create(shopStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = targetStrokeTrans
	}):Play()
end

shopButton.MouseEnter:Connect(function()
	isShopHovered = true
	updateShopButtonFX()
end)

shopButton.MouseLeave:Connect(function()
	isShopHovered = false
	isShopPressed = false
	updateShopButtonFX()
end)

shopButton.MouseButton1Down:Connect(function()
	isShopPressed = true
	updateShopButtonFX()
end)

shopButton.MouseButton1Up:Connect(function()
	isShopPressed = false
	updateShopButtonFX()
end)

shopButton.MouseButton1Click:Connect(function()
	print("[ShopHUDButton] Clicked - Shop UI integration ready.")
end)

-- 3B. INDEX HUD BUTTON (Positioned between Shop and Settings with cosmic amethyst theme)
local indexContainer = Instance.new("Frame")
indexContainer.Name = "IndexHUDButtonContainer"
indexContainer.AnchorPoint = Vector2.new(0, 0.5)
indexContainer.Position = UDim2.new(0, 24, 0.5, 0)
indexContainer.Size = UDim2.new(0, 86, 0, 86)
indexContainer.BackgroundTransparency = 1
indexContainer.ClipsDescendants = false
indexContainer.ZIndex = 5
indexContainer.Parent = gui

local indexBevel = Instance.new("Frame")
indexBevel.Name = "BevelBase"
indexBevel.AnchorPoint = Vector2.new(0.5, 0.5)
indexBevel.Position = UDim2.new(0.5, 0, 0.5, bevelDepth)
indexBevel.Size = UDim2.new(1, 0, 1, 0)
indexBevel.BackgroundColor3 = COLOR_INDEX_BEVEL
indexBevel.BorderSizePixel = 0
indexBevel.ClipsDescendants = false
indexBevel.Parent = indexContainer
corner(indexBevel, 20)

local indexButton = Instance.new("ImageButton")
indexButton.Name = "IndexHUDButton"
indexButton.AutoButtonColor = false
indexButton.AnchorPoint = Vector2.new(0.5, 0.5)
indexButton.Position = UDim2.new(0.5, 0, 0.5, 0)
indexButton.Size = UDim2.new(1, 0, 1, 0)
indexButton.BackgroundColor3 = COLOR_INDEX_BG
indexButton.BorderSizePixel = 0
indexButton.ClipsDescendants = false
indexButton.Parent = indexContainer
corner(indexButton, 20)

local indexGradient = Instance.new("UIGradient")
indexGradient.Rotation = 90
indexGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_INDEX_BG_TOP),
	ColorSequenceKeypoint.new(1, COLOR_INDEX_BG),
})
indexGradient.Parent = indexButton

local indexStroke = stroke(indexButton, 2, COLOR_INDEX_STROKE, 0.20)

local indexIcon = Instance.new("ImageLabel")
indexIcon.Name = "Icon"
indexIcon.AnchorPoint = Vector2.new(0.5, 0.5)
indexIcon.Position = UDim2.new(0.5, 0, 0.5, -6)
indexIcon.Size = UDim2.new(0, 62, 0, 62)
indexIcon.BackgroundTransparency = 1
indexIcon.Image = BOOK_ICON_ID
indexIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
indexIcon.ZIndex = 3
indexIcon.Parent = indexButton

local indexPill, iLabel = createEmbeddedPill(indexButton, COLOR_INDEX_STROKE)
indexPillLabel = iLabel
indexPillLabel.Text = getText("HUD_INDEX")

local indexScale = Instance.new("UIScale")
indexScale.Scale = 1
indexScale.Parent = indexButton

local isIndexHovered = false
local isIndexPressed = false

local function updateIndexButtonFX()
	local targetScale = 1.0
	local targetY = 0
	local targetStrokeTrans = 0.20

	if isIndexPressed then
		targetScale = 0.96
		targetY = bevelDepth
		targetStrokeTrans = 0.0
	elseif isIndexHovered then
		targetScale = 1.04
		targetY = -2
		targetStrokeTrans = 0.0
	end

	TweenService:Create(indexScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = targetScale
	}):Play()

	TweenService:Create(indexButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, targetY)
	}):Play()

	TweenService:Create(indexStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = targetStrokeTrans
	}):Play()
end

indexButton.MouseEnter:Connect(function()
	isIndexHovered = true
	updateIndexButtonFX()
end)

indexButton.MouseLeave:Connect(function()
	isIndexHovered = false
	isIndexPressed = false
	updateIndexButtonFX()
end)

indexButton.MouseButton1Down:Connect(function()
	isIndexPressed = true
	updateIndexButtonFX()
end)

indexButton.MouseButton1Up:Connect(function()
	isIndexPressed = false
	updateIndexButtonFX()
end)

indexButton.MouseButton1Click:Connect(function()
	print("[IndexHUDButton] Clicked - Index UI integration ready.")
end)

-- 3C. SETTINGS HUD BUTTON
local hudContainer = Instance.new("Frame")
hudContainer.Name = "SettingsHUDButtonContainer"
hudContainer.AnchorPoint = Vector2.new(0, 0.5)
hudContainer.Position = UDim2.new(0, 24, 0.5, 112)
hudContainer.Size = UDim2.new(0, 86, 0, 86)
hudContainer.BackgroundTransparency = 1
hudContainer.ClipsDescendants = false
hudContainer.ZIndex = 5
hudContainer.Parent = gui
local bevelBase = Instance.new("Frame")
bevelBase.Name = "BevelBase"
bevelBase.AnchorPoint = Vector2.new(0.5, 0.5)
bevelBase.Position = UDim2.new(0.5, 0, 0.5, bevelDepth)
bevelBase.Size = UDim2.new(1, 0, 1, 0)
bevelBase.BackgroundColor3 = Color3.fromRGB(50, 105, 155)
bevelBase.BorderSizePixel = 0
bevelBase.ClipsDescendants = false
bevelBase.Parent = hudContainer
corner(bevelBase, 20)

local hudButton = Instance.new("ImageButton")
hudButton.Name = "SettingsHUDButton"
hudButton.AutoButtonColor = false
hudButton.AnchorPoint = Vector2.new(0.5, 0.5)
hudButton.Position = UDim2.new(0.5, 0, 0.5, 0)
hudButton.Size = UDim2.new(1, 0, 1, 0)
hudButton.BackgroundColor3 = COLOR_MAIN_BG
hudButton.BorderSizePixel = 0
hudButton.ClipsDescendants = false
hudButton.Parent = hudContainer
corner(hudButton, 20)

local hudStroke = stroke(hudButton, 2, COLOR_ACCENT, 0.25)

local hudGear = Instance.new("ImageLabel")
hudGear.Name = "Icon"
hudGear.AnchorPoint = Vector2.new(0.5, 0.5)
hudGear.Position = UDim2.new(0.5, 0, 0.5, -6)
hudGear.Size = UDim2.new(0, 54, 0, 54)
hudGear.BackgroundTransparency = 1
hudGear.Image = GEAR_ICON_ID
hudGear.ImageColor3 = Color3.fromRGB(255, 255, 255)
hudGear.ZIndex = 3
hudGear.Parent = hudButton

local settingsPill, setLabel = createEmbeddedPill(hudButton, COLOR_ACCENT_STROKE)
settingsPillLabel = setLabel
settingsPillLabel.Text = getText("HUD_SETTINGS")

local hudScale = Instance.new("UIScale")
hudScale.Scale = 1
hudScale.Parent = hudButton

local isHovered = false
local isPressed = false

local function updateButtonFX()
	local targetScale = 1.0
	local targetY = 0
	local targetStrokeTrans = 0.25

	if isPressed then
		targetScale = 0.96
		targetY = bevelDepth
		targetStrokeTrans = 0.0
	elseif isHovered then
		targetScale = 1.04
		targetY = -2
		targetStrokeTrans = 0.0
	end

	TweenService:Create(hudScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = targetScale
	}):Play()

	TweenService:Create(hudButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, targetY)
	}):Play()

	TweenService:Create(hudStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = targetStrokeTrans
	}):Play()
end

hudButton.MouseEnter:Connect(function()
	isHovered = true
	updateButtonFX()
end)

hudButton.MouseLeave:Connect(function()
	isHovered = false
	isPressed = false
	updateButtonFX()
end)

hudButton.MouseButton1Down:Connect(function()
	isPressed = true
	updateButtonFX()
end)

hudButton.MouseButton1Up:Connect(function()
	isPressed = false
	updateButtonFX()
end)

hudButton.MouseButton1Click:Connect(function()
	if State.IsOpen then
		closeSettings()
	else
		openSettings()
	end
end)

-- 3D. INVENTORY HUD BUTTON (Positioned on the right screen edge, opposite the Shop button)
local inventoryContainer = Instance.new("Frame")
inventoryContainer.Name = "InventoryHUDButtonContainer"
inventoryContainer.AnchorPoint = Vector2.new(1, 0.5)
inventoryContainer.Position = UDim2.new(1, -24, 0.5, -112)
inventoryContainer.Size = UDim2.new(0, 86, 0, 86)
inventoryContainer.BackgroundTransparency = 1
inventoryContainer.ClipsDescendants = false
inventoryContainer.ZIndex = 5
inventoryContainer.Parent = gui

local inventoryBevel = Instance.new("Frame")
inventoryBevel.Name = "BevelBase"
inventoryBevel.AnchorPoint = Vector2.new(0.5, 0.5)
inventoryBevel.Position = UDim2.new(0.5, 0, 0.5, bevelDepth)
inventoryBevel.Size = UDim2.new(1, 0, 1, 0)
inventoryBevel.BackgroundColor3 = COLOR_INVENTORY_BEVEL
inventoryBevel.BorderSizePixel = 0
inventoryBevel.ClipsDescendants = false
inventoryBevel.Parent = inventoryContainer
corner(inventoryBevel, 20)

local inventoryButton = Instance.new("ImageButton")
inventoryButton.Name = "InventoryHUDButton"
inventoryButton.AutoButtonColor = false
inventoryButton.AnchorPoint = Vector2.new(0.5, 0.5)
inventoryButton.Position = UDim2.new(0.5, 0, 0.5, 0)
inventoryButton.Size = UDim2.new(1, 0, 1, 0)
inventoryButton.BackgroundColor3 = COLOR_INVENTORY_BG
inventoryButton.BorderSizePixel = 0
inventoryButton.ClipsDescendants = false
inventoryButton.Parent = inventoryContainer
corner(inventoryButton, 20)

local inventoryGradient = Instance.new("UIGradient")
inventoryGradient.Rotation = 90
inventoryGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_INVENTORY_BG_TOP),
	ColorSequenceKeypoint.new(1, COLOR_INVENTORY_BG),
})
inventoryGradient.Parent = inventoryButton

local inventoryStroke = stroke(inventoryButton, 2, COLOR_INVENTORY_STROKE, 0.20)

local inventoryIcon = Instance.new("ImageLabel")
inventoryIcon.Name = "Icon"
inventoryIcon.AnchorPoint = Vector2.new(0.5, 0.5)
inventoryIcon.Position = UDim2.new(0.5, 0, 0.5, -6)
inventoryIcon.Size = UDim2.new(0, 62, 0, 62)
inventoryIcon.BackgroundTransparency = 1
inventoryIcon.Image = INVENTORY_ICON_ID
inventoryIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
inventoryIcon.ZIndex = 3
inventoryIcon.Parent = inventoryButton

local inventoryPill, invLabel = createEmbeddedPill(inventoryButton, COLOR_INVENTORY_STROKE)
inventoryPillLabel = invLabel
inventoryPillLabel.Text = getText("HUD_INVENTORY")

local inventoryScale = Instance.new("UIScale")
inventoryScale.Scale = 1
inventoryScale.Parent = inventoryButton

local isInventoryHovered = false
local isInventoryPressed = false

local function updateInventoryButtonFX()
	local targetScale = 1.0
	local targetY = 0
	local targetStrokeTrans = 0.20

	if isInventoryPressed then
		targetScale = 0.96
		targetY = bevelDepth
		targetStrokeTrans = 0.0
	elseif isInventoryHovered then
		targetScale = 1.04
		targetY = -2
		targetStrokeTrans = 0.0
	end

	TweenService:Create(inventoryScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = targetScale
	}):Play()

	TweenService:Create(inventoryButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, targetY)
	}):Play()

	TweenService:Create(inventoryStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = targetStrokeTrans
	}):Play()
end

inventoryButton.MouseEnter:Connect(function()
	isInventoryHovered = true
	updateInventoryButtonFX()
end)

inventoryButton.MouseLeave:Connect(function()
	isInventoryHovered = false
	isInventoryPressed = false
	updateInventoryButtonFX()
end)

inventoryButton.MouseButton1Down:Connect(function()
	isInventoryPressed = true
	updateInventoryButtonFX()
end)

inventoryButton.MouseButton1Up:Connect(function()
	isInventoryPressed = false
	updateInventoryButtonFX()
end)

inventoryButton.MouseButton1Click:Connect(function()
	print("[InventoryHUDButton] Clicked - Inventory UI integration ready.")
end)

-- 3E. EGG HUD BUTTON (Positioned on the right screen edge, under the Inventory button)
local eggContainer = Instance.new("Frame")
eggContainer.Name = "EggHUDButtonContainer"
eggContainer.AnchorPoint = Vector2.new(1, 0.5)
eggContainer.Position = UDim2.new(1, -24, 0.5, 0)
eggContainer.Size = UDim2.new(0, 86, 0, 86)
eggContainer.BackgroundTransparency = 1
eggContainer.ClipsDescendants = false
eggContainer.ZIndex = 5
eggContainer.Parent = gui

local eggBevel = Instance.new("Frame")
eggBevel.Name = "BevelBase"
eggBevel.AnchorPoint = Vector2.new(0.5, 0.5)
eggBevel.Position = UDim2.new(0.5, 0, 0.5, bevelDepth)
eggBevel.Size = UDim2.new(1, 0, 1, 0)
eggBevel.BackgroundColor3 = COLOR_EGG_BEVEL
eggBevel.BorderSizePixel = 0
eggBevel.ClipsDescendants = false
eggBevel.Parent = eggContainer
corner(eggBevel, 20)

local eggButton = Instance.new("ImageButton")
eggButton.Name = "EggHUDButton"
eggButton.AutoButtonColor = false
eggButton.AnchorPoint = Vector2.new(0.5, 0.5)
eggButton.Position = UDim2.new(0.5, 0, 0.5, 0)
eggButton.Size = UDim2.new(1, 0, 1, 0)
eggButton.BackgroundColor3 = COLOR_EGG_BG
eggButton.BorderSizePixel = 0
eggButton.ClipsDescendants = false
eggButton.Parent = eggContainer
corner(eggButton, 20)

local eggGradient = Instance.new("UIGradient")
eggGradient.Rotation = 90
eggGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_EGG_BG_TOP),
	ColorSequenceKeypoint.new(1, COLOR_EGG_BG),
})
eggGradient.Parent = eggButton

local eggStroke = stroke(eggButton, 2, COLOR_EGG_STROKE, 0.20)

local eggIcon = Instance.new("ImageLabel")
eggIcon.Name = "Icon"
eggIcon.AnchorPoint = Vector2.new(0.5, 0.5)
eggIcon.Position = UDim2.new(0.5, 0, 0.5, -6)
eggIcon.Size = UDim2.new(0, 62, 0, 62)
eggIcon.BackgroundTransparency = 1
eggIcon.Image = EGG_ICON_ID
eggIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
eggIcon.ZIndex = 3
eggIcon.Parent = eggButton

local eggPill, eLabel = createEmbeddedPill(eggButton, COLOR_EGG_STROKE)
eggPillLabel = eLabel
eggPillLabel.Text = getText("HUD_EGG")

local eggScale = Instance.new("UIScale")
eggScale.Scale = 1
eggScale.Parent = eggButton

local isEggHovered = false
local isEggPressed = false

local function updateEggButtonFX()
	local targetScale = 1.0
	local targetY = 0
	local targetStrokeTrans = 0.20

	if isEggPressed then
		targetScale = 0.96
		targetY = bevelDepth
		targetStrokeTrans = 0.0
	elseif isEggHovered then
		targetScale = 1.04
		targetY = -2
		targetStrokeTrans = 0.0
	end

	TweenService:Create(eggScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = targetScale
	}):Play()

	TweenService:Create(eggButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, targetY)
	}):Play()

	TweenService:Create(eggStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = targetStrokeTrans
	}):Play()
end

eggButton.MouseEnter:Connect(function()
	isEggHovered = true
	updateEggButtonFX()
end)

eggButton.MouseLeave:Connect(function()
	isEggHovered = false
	isEggPressed = false
	updateEggButtonFX()
end)

eggButton.MouseButton1Down:Connect(function()
	isEggPressed = true
	updateEggButtonFX()
end)

eggButton.MouseButton1Up:Connect(function()
	isEggPressed = false
	updateEggButtonFX()
end)

eggButton.MouseButton1Click:Connect(function()
	print("[EggHUDButton] Clicked - Egg UI integration ready.")
end)

-- 3F. GIFT HUD BUTTON (Positioned on the right screen edge, under the Egg button)
local giftContainer = Instance.new("Frame")
giftContainer.Name = "GiftHUDButtonContainer"
giftContainer.AnchorPoint = Vector2.new(1, 0.5)
giftContainer.Position = UDim2.new(1, -24, 0.5, 112)
giftContainer.Size = UDim2.new(0, 86, 0, 86)
giftContainer.BackgroundTransparency = 1
giftContainer.ClipsDescendants = false
giftContainer.ZIndex = 5
giftContainer.Parent = gui

local giftBevel = Instance.new("Frame")
giftBevel.Name = "BevelBase"
giftBevel.AnchorPoint = Vector2.new(0.5, 0.5)
giftBevel.Position = UDim2.new(0.5, 0, 0.5, bevelDepth)
giftBevel.Size = UDim2.new(1, 0, 1, 0)
giftBevel.BackgroundColor3 = COLOR_GIFT_BEVEL
giftBevel.BorderSizePixel = 0
giftBevel.ClipsDescendants = false
giftBevel.Parent = giftContainer
corner(giftBevel, 20)

local giftButton = Instance.new("ImageButton")
giftButton.Name = "GiftHUDButton"
giftButton.AutoButtonColor = false
giftButton.AnchorPoint = Vector2.new(0.5, 0.5)
giftButton.Position = UDim2.new(0.5, 0, 0.5, 0)
giftButton.Size = UDim2.new(1, 0, 1, 0)
giftButton.BackgroundColor3 = COLOR_GIFT_BG
giftButton.BorderSizePixel = 0
giftButton.ClipsDescendants = false
giftButton.Parent = giftContainer
corner(giftButton, 20)

local giftGradient = Instance.new("UIGradient")
giftGradient.Rotation = 90
giftGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, COLOR_GIFT_BG_TOP),
	ColorSequenceKeypoint.new(1, COLOR_GIFT_BG),
})
giftGradient.Parent = giftButton

local giftStroke = stroke(giftButton, 2, COLOR_GIFT_STROKE, 0.20)

local giftIcon = Instance.new("ImageLabel")
giftIcon.Name = "Icon"
giftIcon.AnchorPoint = Vector2.new(0.5, 0.5)
giftIcon.Position = UDim2.new(0.5, 0, 0.5, -6)
giftIcon.Size = UDim2.new(0, 62, 0, 62)
giftIcon.BackgroundTransparency = 1
giftIcon.Image = GIFT_ICON_ID
giftIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
giftIcon.ZIndex = 3
giftIcon.Parent = giftButton

local giftPill, gLabel = createEmbeddedPill(giftButton, COLOR_GIFT_STROKE)
giftPillLabel = gLabel
giftPillLabel.Text = getText("HUD_GIFT")

local giftScale = Instance.new("UIScale")
giftScale.Scale = 1
giftScale.Parent = giftButton

local isGiftHovered = false
local isGiftPressed = false

local function updateGiftButtonFX()
	local targetScale = 1.0
	local targetY = 0
	local targetStrokeTrans = 0.20

	if isGiftPressed then
		targetScale = 0.96
		targetY = bevelDepth
		targetStrokeTrans = 0.0
	elseif isGiftHovered then
		targetScale = 1.04
		targetY = -2
		targetStrokeTrans = 0.0
	end

	TweenService:Create(giftScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = targetScale
	}):Play()

	TweenService:Create(giftButton, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, targetY)
	}):Play()

	TweenService:Create(giftStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Transparency = targetStrokeTrans
	}):Play()
end

giftButton.MouseEnter:Connect(function()
	isGiftHovered = true
	updateGiftButtonFX()
end)

giftButton.MouseLeave:Connect(function()
	isGiftHovered = false
	isGiftPressed = false
	updateGiftButtonFX()
end)

giftButton.MouseButton1Down:Connect(function()
	isGiftPressed = true
	updateGiftButtonFX()
end)

giftButton.MouseButton1Up:Connect(function()
	isGiftPressed = false
	updateGiftButtonFX()
end)

giftButton.MouseButton1Click:Connect(function()
	print("[GiftHUDButton] Clicked - Gift/Rewards UI integration ready.")
end)

applyLocalization()
ensureAudioSetup()

print("[SettingsClient] Settings UI initialized successfully with unified corner architecture, audio manager, and auto-localization.")
