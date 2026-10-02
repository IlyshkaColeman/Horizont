--!strict
-- IndexClient.client.luau
-- Manages the Index / Bestiary menu: responsive scaling (Mobile/PC/Console),
-- smooth pop-in animations, INDEX HUD button integration, custom scrollbar,
-- side tabs, and performance-optimized visibility culling.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")

local player = Players.LocalPlayer
local screenGui = script.Parent :: ScreenGui

-- =========================================================================
-- 1. ССЫЛКИ НА ЭЛЕМЕНТЫ ИНТЕРФЕЙСА
-- =========================================================================

local dimOverlay: GuiObject
local existingDim = screenGui:FindFirstChild("DimOverlay")
if existingDim and (existingDim:IsA("Frame") or existingDim:IsA("GuiButton")) then
	dimOverlay = existingDim
	dimOverlay.Active = true
else
	local newDim = Instance.new("Frame")
	newDim.Name = "DimOverlay"
	newDim.Size = UDim2.fromScale(1, 1)
	newDim.Position = UDim2.fromScale(0, 0)
	newDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	newDim.BackgroundTransparency = 1
	newDim.Visible = false
	newDim.ZIndex = 1
	newDim.Active = true
	newDim.Parent = screenGui
	dimOverlay = newDim
end

local indexContainer = screenGui:WaitForChild("IndexContainer") :: CanvasGroup
local uiScale = indexContainer:WaitForChild("UIScale") :: UIScale
local mainFrame = indexContainer:WaitForChild("MainFrame") :: Frame
mainFrame.Active = true -- Sinks all mouse events so clicks inside never fall through to dimOverlay!
local sideTabs = indexContainer:WaitForChild("SideTabs") :: Frame
local contentArea = mainFrame:WaitForChild("ContentArea") :: Frame

-- Ссылки на 3 страницы карточек
local cardsScroll1 = (contentArea:WaitForChild("CardsScroll_1", 3) or contentArea:WaitForChild("CardsScroll")) :: ScrollingFrame
local cardsScroll2 = contentArea:WaitForChild("CardsScroll_2", 3) :: ScrollingFrame?
local cardsScroll3 = contentArea:WaitForChild("CardsScroll_3", 3) :: ScrollingFrame?

-- Очистка встроенных текстур скроллбара Roblox, чтобы избежать белых полос
local function sanitizeScroll(scroll: ScrollingFrame?)
	if not scroll then return end
	scroll.ScrollBarThickness = 0
	scroll.ScrollBarImageTransparency = 1
	scroll.TopImage = ""
	scroll.MidImage = ""
	scroll.BottomImage = ""
end

sanitizeScroll(cardsScroll1)
sanitizeScroll(cardsScroll2)
sanitizeScroll(cardsScroll3)

local activeScroll: ScrollingFrame = cardsScroll1

local track = contentArea:WaitForChild("ScrollBarTrack") :: Frame
local thumb = track:WaitForChild("ScrollThumb") :: Frame
local dragBtn = thumb:WaitForChild("DragButton") :: TextButton
local trackBtn = track:WaitForChild("TrackButton") :: TextButton

local closeButtonFrame = mainFrame:WaitForChild("CloseButton") :: Frame
local closeHitbox = closeButtonFrame:WaitForChild("Hitbox") :: TextButton
local closeBg = closeButtonFrame:WaitForChild("Background") :: Frame

local accentPlate = mainFrame:WaitForChild("AccentPlate", 3) :: Frame?
local cardCountTotal = accentPlate and accentPlate:WaitForChild("CardCount", 2) and accentPlate.CardCount:WaitForChild("Total", 2) :: TextLabel?

local thumbStroke = thumb:FindFirstChildWhichIsA("UIStroke")
local headerTitle = mainFrame:WaitForChild("HeaderTitle", 3) :: TextLabel?
local filterBar = contentArea:WaitForChild("FilterBar", 3) :: Frame?

-- =========================================================================
-- 2. СИСТЕМА ЛОКАЛИЗАЦИИ И ЯЗЫКОВ (АВТОМАТИЧЕСКИЙ ВЫБОР ЯЗЫКА ИЗ ROBLOX)
-- =========================================================================

local DICTIONARY: { [string]: { [string]: string } } = {
	en = {
		TITLE_INDEX = "INDEX",
		TAB_MONSTERS = "Monsters",
		TAB_PETS = "Pets",
		TAB_MUTATIONS = "Mutations",
		FILTER_ALL = "All",
		FILTER_EARTH = "Earth",
		FILTER_MARS = "Mars",
		FILTER_SUN = "Sun",
		FILTER_STEPHENSON = "Stephenson\n2-18",
		FILTER_SMALL_BH = "Small\nblack hole",
		FILTER_PULSAR = "Pulsar",
		FILTER_BIG_BH = "Big\nblack hole",
		FILTER_QUASAR = "Quasar",
		RARITY_COMMON = "Common",
	},
	ru = {
		TITLE_INDEX = "ИНДЕКС",
		TAB_MONSTERS = "Монстры",
		TAB_PETS = "Питомцы",
		TAB_MUTATIONS = "Мутации",
		FILTER_ALL = "Всё",
		FILTER_EARTH = "Земля",
		FILTER_MARS = "Марс",
		FILTER_SUN = "Солнце",
		FILTER_STEPHENSON = "Стивенсон\n2 18",
		FILTER_SMALL_BH = "Маленькая\nчерная дыра",
		FILTER_PULSAR = "Пульсар",
		FILTER_BIG_BH = "Большая\nчерная дыра",
		FILTER_QUASAR = "Квазар",
		RARITY_COMMON = "Обычный",
	},
	es = {
		TITLE_INDEX = "ÍNDICE",
		TAB_MONSTERS = "Monstruos",
		TAB_PETS = "Mascotas",
		TAB_MUTATIONS = "Mutaciones",
		FILTER_ALL = "Todo",
		FILTER_EARTH = "Tierra",
		FILTER_MARS = "Marte",
		FILTER_SUN = "Sol",
		FILTER_STEPHENSON = "Stephenson\n2-18",
		FILTER_SMALL_BH = "Agujero\npequeño",
		FILTER_PULSAR = "Púlsar",
		FILTER_BIG_BH = "Agujero\ngrande",
		FILTER_QUASAR = "Cuásar",
		RARITY_COMMON = "Común",
	},
	pt = {
		TITLE_INDEX = "ÍNDICE",
		TAB_MONSTERS = "Monstros",
		TAB_PETS = "Pets",
		TAB_MUTATIONS = "Mutações",
		FILTER_ALL = "Tudo",
		FILTER_EARTH = "Terra",
		FILTER_MARS = "Marte",
		FILTER_SUN = "Sol",
		FILTER_STEPHENSON = "Stephenson\n2-18",
		FILTER_SMALL_BH = "Buraco\npequeno",
		FILTER_PULSAR = "Pulsar",
		FILTER_BIG_BH = "Buraco\ngrande",
		FILTER_QUASAR = "Quasar",
		RARITY_COMMON = "Comum",
	},
	de = {
		TITLE_INDEX = "INDEX",
		TAB_MONSTERS = "Monster",
		TAB_PETS = "Haustiere",
		TAB_MUTATIONS = "Mutationen",
		FILTER_ALL = "Alle",
		FILTER_EARTH = "Erde",
		FILTER_MARS = "Mars",
		FILTER_SUN = "Sonne",
		FILTER_STEPHENSON = "Stephenson\n2-18",
		FILTER_SMALL_BH = "Kleines\nschw. Loch",
		FILTER_PULSAR = "Pulsar",
		FILTER_BIG_BH = "Großes\nschw. Loch",
		FILTER_QUASAR = "Quasar",
		RARITY_COMMON = "Gewöhnlich",
	},
	fr = {
		TITLE_INDEX = "INDEX",
		TAB_MONSTERS = "Monstres",
		TAB_PETS = "Familiers",
		TAB_MUTATIONS = "Mutations",
		FILTER_ALL = "Tout",
		FILTER_EARTH = "Terre",
		FILTER_MARS = "Mars",
		FILTER_SUN = "Soleil",
		FILTER_STEPHENSON = "Stephenson\n2-18",
		FILTER_SMALL_BH = "Petit trou\nnoir",
		FILTER_PULSAR = "Pulsar",
		FILTER_BIG_BH = "Grand trou\nnoir",
		FILTER_QUASAR = "Quasar",
		RARITY_COMMON = "Commun",
	},
	pl = {
		TITLE_INDEX = "INDEKS",
		TAB_MONSTERS = "Potwory",
		TAB_PETS = "Zwierzaki",
		TAB_MUTATIONS = "Mutacje",
		FILTER_ALL = "Wszystko",
		FILTER_EARTH = "Ziemia",
		FILTER_MARS = "Mars",
		FILTER_SUN = "Słońce",
		FILTER_STEPHENSON = "Stephenson\n2-18",
		FILTER_SMALL_BH = "Mała czarna\ndziura",
		FILTER_PULSAR = "Pulsar",
		FILTER_BIG_BH = "Wielka czarna\ndziura",
		FILTER_QUASAR = "Kwazar",
		RARITY_COMMON = "Zwykły",
	},
	id = {
		TITLE_INDEX = "INDEKS",
		TAB_MONSTERS = "Monster",
		TAB_PETS = "Hewan",
		TAB_MUTATIONS = "Mutasi",
		FILTER_ALL = "Semua",
		FILTER_EARTH = "Bumi",
		FILTER_MARS = "Mars",
		FILTER_SUN = "Matahari",
		FILTER_STEPHENSON = "Stephenson\n2-18",
		FILTER_SMALL_BH = "Lubang hitam\nkecil",
		FILTER_PULSAR = "Pulsar",
		FILTER_BIG_BH = "Lubang hitam\nbesar",
		FILTER_QUASAR = "Kuasar",
		RARITY_COMMON = "Biasa",
	},
	zh = {
		TITLE_INDEX = "图鉴",
		TAB_MONSTERS = "怪物",
		TAB_PETS = "宠物",
		TAB_MUTATIONS = "变异",
		FILTER_ALL = "全部",
		FILTER_EARTH = "地球",
		FILTER_MARS = "火星",
		FILTER_SUN = "太阳",
		FILTER_STEPHENSON = "史蒂文森\n2-18",
		FILTER_SMALL_BH = "微型\n黑洞",
		FILTER_PULSAR = "脉冲星",
		FILTER_BIG_BH = "超大\n黑洞",
		FILTER_QUASAR = "类星体",
		RARITY_COMMON = "普通",
	},
	ja = {
		TITLE_INDEX = "図鑑",
		TAB_MONSTERS = "モンスター",
		TAB_PETS = "ペット",
		TAB_MUTATIONS = "変異",
		FILTER_ALL = "すべて",
		FILTER_EARTH = "地球",
		FILTER_MARS = "火星",
		FILTER_SUN = "太陽",
		FILTER_STEPHENSON = "スティーブンソン\n2-18",
		FILTER_SMALL_BH = "小型\nブラックホール",
		FILTER_PULSAR = "パルサー",
		FILTER_BIG_BH = "大型\nブラックホール",
		FILTER_QUASAR = "クエーサー",
		RARITY_COMMON = "コモン",
	},
	ko = {
		TITLE_INDEX = "도감",
		TAB_MONSTERS = "몬스터",
		TAB_PETS = "펫",
		TAB_MUTATIONS = "돌연변이",
		FILTER_ALL = "전체",
		FILTER_EARTH = "지구",
		FILTER_MARS = "화성",
		FILTER_SUN = "태양",
		FILTER_STEPHENSON = "스티븐슨\n2-18",
		FILTER_SMALL_BH = "소형\n블랙홀",
		FILTER_PULSAR = "펄서",
		FILTER_BIG_BH = "초대형\n블랙홀",
		FILTER_QUASAR = "퀘이사",
		RARITY_COMMON = "일반",
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

local function applyLocalization()
	-- 1. Заголовок окна
	if headerTitle then
		headerTitle.Text = getText("TITLE_INDEX")
	end

	-- 2. Вкладки слева
	if sideTabs then
		local t1 = sideTabs:FindFirstChild("Tab_1") and sideTabs.Tab_1:FindFirstChild("TabTitle") :: TextLabel?
		if t1 then t1.Text = getText("TAB_MONSTERS") end

		local t2 = sideTabs:FindFirstChild("Tab_2") and sideTabs.Tab_2:FindFirstChild("TabTitle") :: TextLabel?
		if t2 then t2.Text = getText("TAB_PETS") end

		local t3 = sideTabs:FindFirstChild("Tab_3") and sideTabs.Tab_3:FindFirstChild("TabTitle") :: TextLabel?
		if t3 then t3.Text = getText("TAB_MUTATIONS") end
	end

	-- 3. Кнопки фильтров
	if filterBar then
		local function setBtnText(containerName: string, textKey: string)
			local cont = filterBar:FindFirstChild(containerName)
			local mb = cont and cont:FindFirstChild("MainButton")
			local bt = mb and mb:FindFirstChild("ButtonText") :: TextLabel?
			if bt then
				bt.Text = getText(textKey)
			end
		end

		setBtnText("AllButtonContainer", "FILTER_ALL")
		setBtnText("FilterButton_2", "FILTER_EARTH")
		setBtnText("FilterButton_3", "FILTER_MARS")
		setBtnText("FilterButton_4", "FILTER_SUN")
		setBtnText("FilterButton_5", "FILTER_STEPHENSON")
		setBtnText("FilterButton_6", "FILTER_SMALL_BH")
		setBtnText("FilterButton_7", "FILTER_PULSAR")
		setBtnText("FilterButton_8", "FILTER_BIG_BH")
		setBtnText("FilterButton_9", "FILTER_QUASAR")
	end

	-- 4. Редкость на всех карточках (все 3 страницы)
	local function updateCardRarities(scroll: ScrollingFrame?)
		if not scroll then return end
		local commonText = getText("RARITY_COMMON")
		for _, card in ipairs(scroll:GetChildren()) do
			if card:IsA("Frame") and card.Name:find("Card_") then
				local rl = card:FindFirstChild("RarityLabel") :: TextLabel?
				if rl then
					rl.Text = commonText
				end
			end
		end
	end

	updateCardRarities(cardsScroll1)
	updateCardRarities(cardsScroll2)
	updateCardRarities(cardsScroll3)
end

player:GetPropertyChangedSignal("LocaleId"):Connect(applyLocalization)
pcall(function()
	LocalizationService:GetPropertyChangedSignal("RobloxLocaleId"):Connect(applyLocalization)
end)

applyLocalization()

-- =========================================================================
-- 3. АДАПТИВНОЕ МАСШТАБИРОВАНИЕ ПОД ВСЕ УСТРОЙСТВА (MOBILE / TABLET / PC / CONSOLE)
-- =========================================================================

local DESIGN_WIDTH = 1154
local DESIGN_HEIGHT = 764
local MIN_SCALE = 0.38
local MAX_SCALE = 1.05
local currentBaseScale = 1.0

local isOpen = false

local function updateScale()
	local vp = screenGui.AbsoluteSize
	if vp.X <= 0 or vp.Y <= 0 then return end

	local insets, _ = GuiService:GetGuiInset()
	local availableX = math.max(vp.X - 24, 100)
	local availableY = math.max(vp.Y - insets.Y - 24, 100)

	local scaleX = availableX / DESIGN_WIDTH
	local scaleY = availableY / DESIGN_HEIGHT
	currentBaseScale = math.clamp(math.min(scaleX, scaleY), MIN_SCALE, MAX_SCALE)

	uiScale.Scale = currentBaseScale
end

screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)
updateScale()

-- =========================================================================
-- 3. ДИНАМИЧЕСКИЙ РАСЧЕТ И СИНХРОНИЗАЦИЯ ПОЛЗУНКА СКРОЛЛА
-- =========================================================================

local isDragging = false
local dragOffsetY = 0

local function updateThumb()
	if not isOpen or not activeScroll then return end
	local windowHeight = activeScroll.AbsoluteWindowSize.Y
	local canvasHeight = activeScroll.AbsoluteCanvasSize.Y
	local trackHeight = track.AbsoluteSize.Y

	if canvasHeight <= windowHeight or trackHeight <= 0 then
		thumb.Visible = false
		return
	end

	thumb.Visible = true

	local visibleRatio = math.clamp(windowHeight / canvasHeight, 0.08, 1.0)
	local thumbHeight = math.clamp(trackHeight * visibleRatio, 40, trackHeight)
	thumb.Size = UDim2.new(1, 0, 0, thumbHeight)

	local maxCanvasY = canvasHeight - windowHeight
	local maxThumbTravel = trackHeight - thumbHeight

	if maxCanvasY > 0 and maxThumbTravel > 0 then
		local scrollRatio = math.clamp(activeScroll.CanvasPosition.Y / maxCanvasY, 0, 1)
		thumb.Position = UDim2.new(0.5, 0, 0, scrollRatio * maxThumbTravel)
	else
		thumb.Position = UDim2.new(0.5, 0, 0, 0)
	end
end

local function bindScrollEvents(scroll: ScrollingFrame)
	scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		if not isDragging and scroll == activeScroll and isOpen then
			updateThumb()
		end
	end)
	scroll:GetPropertyChangedSignal("AbsoluteCanvasSize"):Connect(function()
		if scroll == activeScroll and isOpen then updateThumb() end
	end)
	scroll:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
		if scroll == activeScroll and isOpen then updateThumb() end
	end)
end

bindScrollEvents(cardsScroll1)
if cardsScroll2 then bindScrollEvents(cardsScroll2) end
if cardsScroll3 then bindScrollEvents(cardsScroll3) end

track:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	if isOpen then updateThumb() end
end)

-- =========================================================================
-- 4. ПЕРЕТАСКИВАНИЕ ПОЛЗУНКА МЫШЬЮ И ТАЧЕМ (DRAG & DROP)
-- =========================================================================

dragBtn.InputBegan:Connect(function(input)
	if not isOpen then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isDragging = true
		dragOffsetY = input.Position.Y - thumb.AbsolutePosition.Y

		if thumbStroke then
			TweenService:Create(thumbStroke, TweenInfo.new(0.1), {
				Transparency = 0.0,
				Thickness = 1.8
			}):Play()
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not isDragging or not activeScroll or not isOpen then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		local trackHeight = track.AbsoluteSize.Y
		local thumbHeight = thumb.AbsoluteSize.Y
		local maxThumbTravel = trackHeight - thumbHeight

		if maxThumbTravel <= 0 then return end

		local targetY = input.Position.Y - track.AbsolutePosition.Y - dragOffsetY
		local ratio = math.clamp(targetY / maxThumbTravel, 0, 1)

		thumb.Position = UDim2.new(0.5, 0, 0, ratio * maxThumbTravel)

		local maxCanvasY = activeScroll.AbsoluteCanvasSize.Y - activeScroll.AbsoluteWindowSize.Y
		if maxCanvasY > 0 then
			activeScroll.CanvasPosition = Vector2.new(0, ratio * maxCanvasY)
		end
	end
end)

local function endDrag()
	if isDragging then
		isDragging = false
		if thumbStroke then
			TweenService:Create(thumbStroke, TweenInfo.new(0.2), {
				Transparency = 0.4,
				Thickness = 1.0
			}):Play()
		end
	end
end

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		endDrag()
	end
end)

-- =========================================================================
-- 5. КЛИК ПО ДОРОЖКЕ ДЛЯ БЫСТРОГО ПЕРЕХОДА (JUMP SCROLL)
-- =========================================================================

trackBtn.InputBegan:Connect(function(input)
	if not isOpen then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local trackAbsY = track.AbsolutePosition.Y
		local clickY = input.Position.Y - trackAbsY
		local trackHeight = track.AbsoluteSize.Y
		local thumbHeight = thumb.AbsoluteSize.Y
		local maxThumbTravel = trackHeight - thumbHeight

		if maxThumbTravel > 0 and activeScroll then
			local targetY = clickY - (thumbHeight / 2)
			local ratio = math.clamp(targetY / maxThumbTravel, 0, 1)

			local maxCanvasY = activeScroll.AbsoluteCanvasSize.Y - activeScroll.AbsoluteWindowSize.Y
			if maxCanvasY > 0 then
				TweenService:Create(activeScroll, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					CanvasPosition = Vector2.new(0, ratio * maxCanvasY)
				}):Play()
			end
		end
	end
end)

-- =========================================================================
-- 6. ХОВЕР-ЭФФЕКТЫ ДЛЯ БЕГУНКА СКРОЛЛА
-- =========================================================================

dragBtn.MouseEnter:Connect(function()
	if not isDragging and thumbStroke and isOpen then
		TweenService:Create(thumbStroke, TweenInfo.new(0.15), {
			Transparency = 0.1,
			Thickness = 1.4
		}):Play()
	end
end)

dragBtn.MouseLeave:Connect(function()
	if not isDragging and thumbStroke and isOpen then
		TweenService:Create(thumbStroke, TweenInfo.new(0.15), {
			Transparency = 0.4,
			Thickness = 1.0
		}):Play()
	end
end)

-- =========================================================================
-- 7. ТАКТИЛЬНЫЙ ХОВЕР КАРТОЧЕК В СПИСКЕ (ДЛЯ ВСЕХ СТРАНИЦ)
-- =========================================================================

local function setupCardHovers(scroll: ScrollingFrame)
	for _, card in ipairs(scroll:GetChildren()) do
		if card:IsA("Frame") and card.Name:find("Card_") then
			local stroke = card:FindFirstChild("CardStroke") :: UIStroke?
			local baseSize = card.Size
			local hoverSize = UDim2.new(baseSize.X.Scale, baseSize.X.Offset + 3, baseSize.Y.Scale, baseSize.Y.Offset + 3)
			local originalStrokeThickness = stroke and stroke.Thickness or 3.0

			card.MouseEnter:Connect(function()
				if not isOpen then return end
				TweenService:Create(card, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = hoverSize
				}):Play()
				if stroke then
					TweenService:Create(stroke, TweenInfo.new(0.15), {
						Thickness = originalStrokeThickness + 0.4
					}):Play()
				end
			end)

			card.MouseLeave:Connect(function()
				if not isOpen then return end
				TweenService:Create(card, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Size = baseSize
				}):Play()
				if stroke then
					TweenService:Create(stroke, TweenInfo.new(0.15), {
						Thickness = originalStrokeThickness
					}):Play()
				end
			end)
		end
	end
end

setupCardHovers(cardsScroll1)
if cardsScroll2 then setupCardHovers(cardsScroll2) end
if cardsScroll3 then setupCardHovers(cardsScroll3) end

-- =========================================================================
-- 8. ТАКТИЛЬНОСТЬ КНОПОК ФИЛЬТРОВ (GEMINI.md Standards)
-- =========================================================================

if filterBar then
	for _, child in ipairs(filterBar:GetChildren()) do
		if child:IsA("Frame") and child:FindFirstChild("MainButton") then
			local mainBtn = child:FindFirstChild("MainButton") :: TextButton
			local basePos = mainBtn.Position
			local hoverPos = UDim2.new(basePos.X.Scale, basePos.X.Offset, basePos.Y.Scale, basePos.Y.Offset - 2)
			local pressPos = UDim2.new(basePos.X.Scale, basePos.X.Offset, basePos.Y.Scale, basePos.Y.Offset + 2)

			local isHovered = false
			local isPressed = false

			local function updateBtnPos()
				if not isOpen then return end
				local targetPos = basePos
				if isPressed then
					targetPos = pressPos
				elseif isHovered then
					targetPos = hoverPos
				end
				TweenService:Create(mainBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					Position = targetPos
				}):Play()
			end

			mainBtn.MouseEnter:Connect(function()
				isHovered = true
				updateBtnPos()
			end)

			mainBtn.MouseLeave:Connect(function()
				isHovered = false
				isPressed = false
				updateBtnPos()
			end)

			mainBtn.MouseButton1Down:Connect(function()
				isPressed = true
				updateBtnPos()
			end)

			mainBtn.MouseButton1Up:Connect(function()
				isPressed = false
				updateBtnPos()
			end)
		end
	end
end

-- =========================================================================
-- 9. ПЕРЕКЛЮЧЕНИЕ БОКОВЫХ ЗАКЛАДОК (SIDE TABS)
-- =========================================================================

local currentTabId = 1

local tabData = {
	[1] = {
		scroll = cardsScroll1,
		count = "80",
	},
	[2] = {
		scroll = cardsScroll2,
		count = "40",
	},
	[3] = {
		scroll = cardsScroll3,
		count = "20",
	},
}

local activeTabSize = UDim2.new(0, 134, 0, 32)
local inactiveTabSize = UDim2.new(0, 118, 0, 26)
local hoverInactiveTabSize = UDim2.new(0, 122, 0, 27)

local function setTabVisualState(tabFrame: Frame, isActive: boolean)
	local title = tabFrame:FindFirstChild("TabTitle") :: TextLabel?
	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	if isActive then
		TweenService:Create(tabFrame, tweenInfo, {
			Size = activeTabSize,
		}):Play()
		if title then
			TweenService:Create(title, tweenInfo, {
				TextColor3 = Color3.fromRGB(255, 255, 255),
			}):Play()
			title.TextSize = 16
		end
	else
		TweenService:Create(tabFrame, tweenInfo, {
			Size = inactiveTabSize,
		}):Play()
		if title then
			TweenService:Create(title, tweenInfo, {
				TextColor3 = Color3.fromRGB(180, 185, 210),
			}):Play()
			title.TextSize = 14
		end
	end
end

local function selectTab(tabId: number)
	if currentTabId == tabId or not sideTabs then return end

	local oldTab = sideTabs:FindFirstChild("Tab_" .. currentTabId) :: Frame?
	local newTab = sideTabs:FindFirstChild("Tab_" .. tabId) :: Frame?

	if oldTab then setTabVisualState(oldTab, false) end
	if newTab then setTabVisualState(newTab, true) end

	-- Скрываем старую страницу
	local oldInfo = tabData[currentTabId]
	if oldInfo and oldInfo.scroll then
		oldInfo.scroll.Visible = false
	end

	-- Показываем новую страницу
	currentTabId = tabId
	local newInfo = tabData[currentTabId]
	if newInfo and newInfo.scroll then
		activeScroll = newInfo.scroll
		activeScroll.Visible = true
		activeScroll.CanvasPosition = Vector2.new(0, 0)
		updateThumb()
	end

	-- Обновляем счетчик 1/80, 1/40, 1/20
	if cardCountTotal and newInfo then
		cardCountTotal.Text = newInfo.count
	end
end

for id = 1, 3 do
	local tabFrame = sideTabs:FindFirstChild("Tab_" .. id) :: Frame?
	if tabFrame then
		local hitbox = tabFrame:FindFirstChild("Hitbox") :: TextButton?
		if hitbox then
			hitbox.MouseButton1Click:Connect(function()
				if isOpen then selectTab(id) end
			end)

			hitbox.MouseEnter:Connect(function()
				if currentTabId ~= id and isOpen then
					TweenService:Create(tabFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = hoverInactiveTabSize,
					}):Play()
					local title = tabFrame:FindFirstChild("TabTitle") :: TextLabel?
					if title then
						TweenService:Create(title, TweenInfo.new(0.12), {
							TextColor3 = Color3.fromRGB(230, 235, 255),
						}):Play()
					end
				end
			end)

			hitbox.MouseLeave:Connect(function()
				if currentTabId ~= id and isOpen then
					TweenService:Create(tabFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Size = inactiveTabSize,
					}):Play()
					local title = tabFrame:FindFirstChild("TabTitle") :: TextLabel?
					if title then
						TweenService:Create(title, TweenInfo.new(0.12), {
							TextColor3 = Color3.fromRGB(180, 185, 210),
						}):Play()
					end
				end
			end)
		end
	end
end

-- =========================================================================
-- 10. АНИМАЦИИ ОТКРЫТИЯ И ЗАКРЫТИЯ МЕНЮ (КАК В SETTINGS: CANVASGROUP + DIMMER)
-- =========================================================================

local isBusy = false

local function openMenu()
	if isBusy or isOpen then return end
	isBusy = true
	isOpen = true

	updateScale()
	dimOverlay.Visible = true
	indexContainer.Visible = true

	if activeScroll then
		activeScroll.CanvasPosition = Vector2.new(0, 0)
	end

	indexContainer.Position = UDim2.new(0.5, 0, 0.5, 25)
	indexContainer.GroupTransparency = 1

	-- Плавное затемнение заднего плана на весь экран (включая топбар)
	TweenService:Create(dimOverlay, TweenInfo.new(0.20, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.55
	}):Play()

	-- Плавный вылет с отдачей (Back.Out) и проявлением прозрачности (в точности как в Settings)
	TweenService:Create(indexContainer, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0.5, 0),
		GroupTransparency = 0
	}):Play()

	task.defer(function()
		task.wait(0.05)
		updateThumb()
	end)

	task.delay(0.26, function()
		isBusy = false
	end)

	-- Поддержка геймпада (фокус на кнопке закрытия для консолей)
	if UserInputService.GamepadEnabled then
		GuiService.SelectedObject = closeHitbox
	end
end

local function closeMenu()
	if isBusy or not isOpen then return end
	isBusy = true
	isOpen = false

	-- Плавное растворение затемнения фона
	TweenService:Create(dimOverlay, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1
	}):Play()

	-- Мягкое опускание на 25px вниз с исчезновением (в точности как в Settings)
	local closeTween = TweenService:Create(indexContainer, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Position = UDim2.new(0.5, 0, 0.5, 25),
		GroupTransparency = 1
	})
	closeTween:Play()

	closeTween.Completed:Once(function()
		if not isOpen then
			indexContainer.Visible = false
			dimOverlay.Visible = false
		end
		isBusy = false
	end)
end

local function toggleMenu()
	if isBusy then return end
	if isOpen then
		closeMenu()
	else
		openMenu()
	end
end

-- Клик вне меню по затемненному фону (как в Settings) закрывает окно
local function isPointInsideIndex(x: number, y: number): boolean
	local mfPos = mainFrame.AbsolutePosition
	local mfSize = mainFrame.AbsoluteSize
	if x >= mfPos.X and x <= (mfPos.X + mfSize.X) and y >= mfPos.Y and y <= (mfPos.Y + mfSize.Y) then
		return true
	end

	if sideTabs and sideTabs.Visible then
		local stPos = sideTabs.AbsolutePosition
		local stSize = sideTabs.AbsoluteSize
		if x >= stPos.X and x <= (stPos.X + stSize.X) and y >= stPos.Y and y <= (stPos.Y + stSize.Y) then
			return true
		end
	end

	local headerLogo = mainFrame:FindFirstChild("HeaderLogo") :: GuiObject?
	if headerLogo and headerLogo.Visible then
		local hlPos = headerLogo.AbsolutePosition
		local hlSize = headerLogo.AbsoluteSize
		if x >= hlPos.X and x <= (hlPos.X + hlSize.X) and y >= hlPos.Y and y <= (hlPos.Y + hlSize.Y) then
			return true
		end
	end

	return false
end

local clickStartedOutside = false

dimOverlay.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		local x, y = input.Position.X, input.Position.Y
		if not isPointInsideIndex(x, y) then
			clickStartedOutside = true
		else
			clickStartedOutside = false
		end
	end
end)

dimOverlay.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if isDragging then
			clickStartedOutside = false
			return
		end
		if not isOpen then
			clickStartedOutside = false
			return
		end
		local x, y = input.Position.X, input.Position.Y
		if clickStartedOutside and not isPointInsideIndex(x, y) then
			closeMenu()
		end
		clickStartedOutside = false
	end
end)

-- Кнопка закрытия [X]
closeHitbox.MouseEnter:Connect(function()
	if not isOpen then return end
	TweenService:Create(closeBg, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = Color3.fromRGB(235, 240, 255)
	}):Play()
end)

closeHitbox.MouseLeave:Connect(function()
	if not isOpen then return end
	TweenService:Create(closeBg, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	}):Play()
end)

closeHitbox.MouseButton1Click:Connect(function()
	closeMenu()
end)

-- =========================================================================
-- 11. ИНТЕГРАЦИЯ С КНОПКОЙ INDEX НА HUD И КРОССПЛАТФОРМЕННЫЙ ВВОД
-- =========================================================================

-- 1. Сигнал от HUD через BindableEvent в ReplicatedStorage
local toggleEvent = ReplicatedStorage:WaitForChild("ToggleIndexMenu", 5) :: BindableEvent?
if toggleEvent then
	toggleEvent.Event:Connect(toggleMenu)
else
	-- Фолбэк на прямое подключение только если BindableEvent отсутствует
	task.spawn(function()
		local playerGui = player:WaitForChild("PlayerGui")
		local settingsGui = playerGui:WaitForChild("SettingsGui", 10)
		if settingsGui then
			local indexContainerHUD = settingsGui:WaitForChild("IndexHUDButtonContainer", 5)
			local indexBtn = indexContainerHUD and indexContainerHUD:WaitForChild("IndexHUDButton", 5)
			if indexBtn and indexBtn:IsA("GuiButton") then
				indexBtn.Activated:Connect(toggleMenu)
			end
		end
	end)
end

-- 3. Горячие клавиши (Keyboard: 'I' и 'Escape' / Gamepad: 'ButtonY' и 'ButtonB')
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end

	-- Клавиатура
	if input.KeyCode == Enum.KeyCode.I then
		toggleMenu()
	elseif input.KeyCode == Enum.KeyCode.Escape and isOpen then
		closeMenu()
	end

	-- Консоли (Xbox / PlayStation)
	if input.KeyCode == Enum.KeyCode.ButtonY then
		toggleMenu()
	elseif input.KeyCode == Enum.KeyCode.ButtonB and isOpen then
		closeMenu()
	end
end)

-- =========================================================================
-- 12. НАЧАЛЬНОЕ СОСТОЯНИЕ (СКРЫТО ПО УМОЛЧАНИЮ)
-- =========================================================================

indexContainer.Visible = false
indexContainer.GroupTransparency = 1
indexContainer.Position = UDim2.new(0.5, 0, 0.5, 25)
dimOverlay.Visible = false
dimOverlay.BackgroundTransparency = 1
