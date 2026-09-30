--!strict
-- build_shop_gui.lua: Скрипт сборки UI магазина ShopGui по строгому промпту
local StarterGui = game:GetService("StarterGui")

-- 1. Очистка старых версий
local existing = StarterGui:FindFirstChild("ShopGui")
if existing then existing:Destroy() end

local mainHud = StarterGui:FindFirstChild("MainHUD")
if mainHud then mainHud:Destroy() end

-- 2. Создание ScreenGui
local shopGui = Instance.new("ScreenGui")
shopGui.Name = "ShopGui"
shopGui.DisplayOrder = 10 -- Высокий DisplayOrder
shopGui.IgnoreGuiInset = true -- Игнорировать системные отступы
shopGui.ResetOnSpawn = false
shopGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
shopGui.Parent = StarterGui

-- ====================================================
-- А. КНОПКА ОТКРЫТИЯ МАГАЗИНА (Круглая, 74px, слева по центру)
-- ====================================================
local btnContainer = Instance.new("Frame")
btnContainer.Name = "ShopButtonContainer"
btnContainer.AnchorPoint = Vector2.new(0, 0.5)
btnContainer.Position = UDim2.new(0, 10, 0.5, 0) -- Смещение от края 10px
btnContainer.Size = UDim2.new(0, 74, 0, 74)
btnContainer.BackgroundTransparency = 1
btnContainer.ZIndex = 20
btnContainer.Parent = shopGui

local btnConstraint = Instance.new("UISizeConstraint")
btnConstraint.MinSize = Vector2.new(60, 60) -- Минимальный размер для читаемости на мобильных
btnConstraint.MaxSize = Vector2.new(88, 88)
btnConstraint.Parent = btnContainer

local shopOpenBtn = Instance.new("ImageButton")
shopOpenBtn.Name = "ShopOpenButton"
shopOpenBtn.AnchorPoint = Vector2.new(0.5, 0.5)
shopOpenBtn.Position = UDim2.new(0.5, 0, 0.5, 0)
shopOpenBtn.Size = UDim2.new(1, 0, 1, 0)
shopOpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35) -- Тёмный полупрозрачный
shopOpenBtn.BackgroundTransparency = 0.1
shopOpenBtn.AutoButtonColor = false
shopOpenBtn.ZIndex = 21
shopOpenBtn.Parent = btnContainer

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0) -- Полный круг
btnCorner.Parent = shopOpenBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Name = "ButtonStroke"
btnStroke.Thickness = 2
btnStroke.Color = Color3.fromRGB(255, 255, 255)
btnStroke.Transparency = 0.4 -- Белый с Transparency 0.4 по промпту
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnStroke.Parent = shopOpenBtn

local btnGradient = Instance.new("UIGradient")
btnGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.0, Color3.fromRGB(44, 46, 58)),
	ColorSequenceKeypoint.new(1.0, Color3.fromRGB(22, 22, 26))
})
btnGradient.Rotation = 90
btnGradient.Parent = shopOpenBtn

local btnScale = Instance.new("UIScale")
btnScale.Name = "ButtonScale"
btnScale.Scale = 1.0
btnScale.Parent = shopOpenBtn

-- Иконка магазина из Creator Store (минимализм)
local cartIcon = Instance.new("ImageLabel")
cartIcon.Name = "CartIcon"
cartIcon.AnchorPoint = Vector2.new(0.5, 0)
cartIcon.Position = UDim2.new(0.5, 0, 0, 10)
cartIcon.Size = UDim2.new(0, 32, 0, 32)
cartIcon.BackgroundTransparency = 1
cartIcon.Image = "rbxassetid://13429538917" -- Creator Store minimal white shop icon
cartIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
cartIcon.ScaleType = Enum.ScaleType.Fit
cartIcon.ZIndex = 22
cartIcon.Parent = shopOpenBtn

local cartRatio = Instance.new("UIAspectRatioConstraint")
cartRatio.AspectRatio = 1
cartRatio.Parent = cartIcon

-- Текст 'SHOP' мелким шрифтом снизу
local shopText = Instance.new("TextLabel")
shopText.Name = "ShopLabel"
shopText.AnchorPoint = Vector2.new(0.5, 1)
shopText.Position = UDim2.new(0.5, 0, 1, -8)
shopText.Size = UDim2.new(1, 0, 0, 14)
shopText.BackgroundTransparency = 1
shopText.Font = Enum.Font.FredokaOne
shopText.Text = "SHOP"
shopText.TextSize = 11
shopText.TextColor3 = Color3.fromRGB(255, 255, 255)
shopText.ZIndex = 22
shopText.Parent = shopOpenBtn

-- Красный бейдж-уведомление сверху-справа (круг с числом)
local badge = Instance.new("Frame")
badge.Name = "NotificationBadge"
badge.AnchorPoint = Vector2.new(1, 0)
badge.Position = UDim2.new(1, 2, 0, -2)
badge.Size = UDim2.new(0, 22, 0, 22)
badge.BackgroundColor3 = Color3.fromRGB(255, 45, 75)
badge.ZIndex = 25
badge.Parent = shopOpenBtn

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(1, 0)
badgeCorner.Parent = badge

local badgeStroke = Instance.new("UIStroke")
badgeStroke.Thickness = 1.5
badgeStroke.Color = Color3.fromRGB(255, 255, 255)
badgeStroke.Parent = badge

local badgeText = Instance.new("TextLabel")
badgeText.Name = "BadgeText"
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.BackgroundTransparency = 1
badgeText.Font = Enum.Font.FredokaOne
badgeText.Text = "3"
badgeText.TextSize = 11
badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
badgeText.ZIndex = 26
badgeText.Parent = badge

-- ====================================================
-- Б. ОКНО МАГАЗИНА (CanvasGroup / Frame по центру экрана)
-- ====================================================
local modalOverlay = Instance.new("Frame")
modalOverlay.Name = "ModalOverlay"
modalOverlay.Size = UDim2.new(1, 0, 1, 0)
modalOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
modalOverlay.BackgroundTransparency = 1 -- Начальное скрытое состояние
modalOverlay.Visible = false
modalOverlay.ZIndex = 50
modalOverlay.Parent = shopGui

local backdropBtn = Instance.new("TextButton")
backdropBtn.Name = "BackdropButton"
backdropBtn.Size = UDim2.new(1, 0, 1, 0)
backdropBtn.BackgroundTransparency = 1
backdropBtn.Text = ""
backdropBtn.ZIndex = 51
backdropBtn.Parent = modalOverlay

local shopWindow = Instance.new("CanvasGroup")
shopWindow.Name = "ShopWindow"
shopWindow.AnchorPoint = Vector2.new(0.5, 0.5)
shopWindow.Position = UDim2.new(0.5, 0, 0.5, 0)
shopWindow.Size = UDim2.new(0.68, 0, 0.74, 0)
shopWindow.BackgroundColor3 = Color3.fromRGB(22, 24, 34)
shopWindow.GroupTransparency = 1 -- Скрыто до анимации открытия
shopWindow.Visible = false
shopWindow.ZIndex = 60
shopWindow.Parent = modalOverlay

local winCorner = Instance.new("UICorner")
winCorner.CornerRadius = UDim.new(0, 18)
winCorner.Parent = shopWindow

local winStroke = Instance.new("UIStroke")
winStroke.Thickness = 2
winStroke.Color = Color3.fromRGB(255, 255, 255)
winStroke.Transparency = 0.5
winStroke.Parent = shopWindow

local winConstraint = Instance.new("UISizeConstraint")
winConstraint.MinSize = Vector2.new(500, 400)
winConstraint.MaxSize = Vector2.new(780, 560)
winConstraint.Parent = shopWindow

local winScale = Instance.new("UIScale")
winScale.Name = "WindowScale"
winScale.Scale = 1.0
winScale.Parent = shopWindow

-- Верхний матовый блик окна
local winSheen = Instance.new("Frame")
winSheen.Name = "TopSheen"
winSheen.Size = UDim2.new(1, 0, 0, 48)
winSheen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
winSheen.BackgroundTransparency = 0.92
winSheen.BorderSizePixel = 0
winSheen.ZIndex = 61
winSheen.Parent = shopWindow

-- Хедер окна
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 60)
header.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
header.ZIndex = 62
header.Parent = shopWindow

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 18)
headerCorner.Parent = header

-- Срезаем нижние углы хедера
local headerCover = Instance.new("Frame")
headerCover.Size = UDim2.new(1, 0, 0, 15)
headerCover.Position = UDim2.new(0, 0, 1, -15)
headerCover.BackgroundColor3 = Color3.fromRGB(28, 30, 42)
headerCover.BorderSizePixel = 0
headerCover.ZIndex = 62
headerCover.Parent = header

local headerIcon = Instance.new("ImageLabel")
headerIcon.Position = UDim2.new(0, 18, 0.5, -14)
headerIcon.Size = UDim2.new(0, 28, 0, 28)
headerIcon.BackgroundTransparency = 1
headerIcon.Image = "rbxassetid://13429538917"
headerIcon.ImageColor3 = Color3.fromRGB(0, 230, 255)
headerIcon.ZIndex = 63
headerIcon.Parent = header

local headerTitle = Instance.new("TextLabel")
headerTitle.Name = "HeaderTitle"
headerTitle.Position = UDim2.new(0, 56, 0.5, -14)
headerTitle.Size = UDim2.new(0, 200, 0, 28)
headerTitle.BackgroundTransparency = 1
headerTitle.Font = Enum.Font.FredokaOne
headerTitle.Text = "МАГАЗИН"
headerTitle.TextSize = 22
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.ZIndex = 63
headerTitle.Parent = header

-- Плашка баланса игрока
local balancePill = Instance.new("Frame")
balancePill.Name = "BalancePill"
balancePill.AnchorPoint = Vector2.new(1, 0.5)
balancePill.Position = UDim2.new(1, -70, 0.5, 0)
balancePill.Size = UDim2.new(0, 140, 0, 32)
balancePill.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
balancePill.ZIndex = 63
balancePill.Parent = header

local balCorner = Instance.new("UICorner")
balCorner.CornerRadius = UDim.new(0, 16)
balCorner.Parent = balancePill

local balStroke = Instance.new("UIStroke")
balStroke.Thickness = 1.5
balStroke.Color = Color3.fromRGB(255, 215, 60)
balStroke.Parent = balancePill

local balText = Instance.new("TextLabel")
balText.Name = "BalanceLabel"
balText.Size = UDim2.new(1, 0, 1, 0)
balText.BackgroundTransparency = 1
balText.Font = Enum.Font.FredokaOne
balText.Text = "💰 100"
balText.TextSize = 14
balText.TextColor3 = Color3.fromRGB(255, 235, 120)
balText.ZIndex = 64
balText.Parent = balancePill

-- Кнопка закрытия (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -16, 0.5, 0)
closeBtn.Size = UDim2.new(0, 34, 0, 34)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 48, 64)
closeBtn.AutoButtonColor = false
closeBtn.Font = Enum.Font.FredokaOne
closeBtn.Text = "✕"
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.ZIndex = 65
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

local closeStroke = Instance.new("UIStroke")
closeStroke.Thickness = 1.5
closeStroke.Color = Color3.fromRGB(255, 90, 110)
closeStroke.Parent = closeBtn

-- Всплывающее уведомление (Toast Notification)
local toast = Instance.new("Frame")
toast.Name = "ToastNotification"
toast.AnchorPoint = Vector2.new(0.5, 0)
toast.Position = UDim2.new(0.5, 0, 0, 68)
toast.Size = UDim2.new(0, 340, 0, 32)
toast.BackgroundColor3 = Color3.fromRGB(28, 32, 45)
toast.BackgroundTransparency = 1
toast.Visible = false
toast.ZIndex = 75
toast.Parent = shopWindow

local toastCorner = Instance.new("UICorner")
toastCorner.CornerRadius = UDim.new(0, 10)
toastCorner.Parent = toast

local toastStroke = Instance.new("UIStroke")
toastStroke.Name = "ToastStroke"
toastStroke.Thickness = 1.5
toastStroke.Color = Color3.fromRGB(0, 240, 150)
toastStroke.Parent = toast

local toastText = Instance.new("TextLabel")
toastText.Name = "ToastLabel"
toastText.Size = UDim2.new(1, 0, 1, 0)
toastText.BackgroundTransparency = 1
toastText.Font = Enum.Font.FredokaOne
toastText.Text = "Покупка успешна!"
toastText.TextSize = 13
toastText.TextColor3 = Color3.fromRGB(255, 255, 255)
toastText.ZIndex = 76
toastText.Parent = toast

-- ====================================================
-- В. СПИСОК ТОВАРОВ (ScrollingFrame + Карточки товаров)
-- ====================================================
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "ItemsScroll"
scrollFrame.Position = UDim2.new(0, 18, 0, 72)
scrollFrame.Size = UDim2.new(1, -36, 1, -86)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ZIndex = 62
scrollFrame.Parent = shopWindow

local gridLayout = Instance.new("UIGridLayout")
gridLayout.CellPadding = UDim2.new(0, 14, 0, 14)
gridLayout.CellSize = UDim2.new(0.5, -7, 0, 155)
gridLayout.SortOrder = Enum.SortOrder.LayoutOrder
gridLayout.Parent = scrollFrame

-- Данные товаров (все иконки из подтвержденного Creator Store Monochrome White Pack)
local CATALOG = {
	{
		id = "LaserSword",
		name = "Космический Меч",
		price = 50,
		desc = "+35 урона • Оружие в инвентарь",
		icon = "rbxassetid://16181366859", -- Creator Store Sword
		accentColor = Color3.fromRGB(0, 220, 255),
		order = 1
	},
	{
		id = "SpeedBoost",
		name = "Зелье Скорости",
		price = 35,
		desc = "+10 к скорости бега",
		icon = "rbxassetid://12334656615", -- Creator Store Sprint
		accentColor = Color3.fromRGB(255, 195, 45),
		order = 2
	},
	{
		id = "EnergyShield",
		name = "Энергетический Щит",
		price = 40,
		desc = "Увеличение здоровья до 150 HP",
		icon = "rbxassetid://16181360172", -- Creator Store Shield
		accentColor = Color3.fromRGB(170, 85, 255),
		order = 3
	},
	{
		id = "Medkit",
		name = "Аптечка Здоровья",
		price = 25,
		desc = "Мгновенное полное лечение",
		icon = "rbxassetid://16181402439", -- Creator Store Potion
		accentColor = Color3.fromRGB(255, 65, 100),
		order = 4
	}
}

-- Генерация карточек товаров
for _, item in ipairs(CATALOG) do
	local card = Instance.new("Frame")
	card.Name = "Card_" .. item.id
	card.LayoutOrder = item.order
	card.BackgroundColor3 = Color3.fromRGB(28, 31, 44)
	card.ZIndex = 63
	card.Parent = scrollFrame

	local cardCorner = Instance.new("UICorner")
	cardCorner.CornerRadius = UDim.new(0, 14)
	cardCorner.Parent = card

	local cardStroke = Instance.new("UIStroke")
	cardStroke.Thickness = 1.5
	cardStroke.Color = Color3.fromRGB(60, 66, 92)
	cardStroke.Parent = card

	-- Иконка товара в круглом контейнере
	local iconHolder = Instance.new("Frame")
	iconHolder.Name = "IconHolder"
	iconHolder.Position = UDim2.new(0, 14, 0, 14)
	iconHolder.Size = UDim2.new(0, 52, 0, 52)
	iconHolder.BackgroundColor3 = Color3.fromRGB(20, 22, 32)
	iconHolder.ZIndex = 64
	iconHolder.Parent = card

	local ihCorner = Instance.new("UICorner")
	ihCorner.CornerRadius = UDim.new(1, 0)
	ihCorner.Parent = iconHolder

	local ihStroke = Instance.new("UIStroke")
	ihStroke.Thickness = 1.5
	ihStroke.Color = item.accentColor
	ihStroke.Parent = iconHolder

	local itemIcon = Instance.new("ImageLabel")
	itemIcon.Name = "Icon"
	itemIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	itemIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	itemIcon.Size = UDim2.new(0, 32, 0, 32)
	itemIcon.BackgroundTransparency = 1
	itemIcon.Image = item.icon
	itemIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	itemIcon.ScaleType = Enum.ScaleType.Fit
	itemIcon.ZIndex = 65
	itemIcon.Parent = iconHolder

	local iconRatio = Instance.new("UIAspectRatioConstraint")
	iconRatio.AspectRatio = 1
	iconRatio.Parent = itemIcon

	-- Название товара
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Name = "ItemName"
	nameLabel.Position = UDim2.new(0, 76, 0, 14)
	nameLabel.Size = UDim2.new(1, -84, 0, 20)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Font = Enum.Font.FredokaOne
	nameLabel.Text = item.name
	nameLabel.TextSize = 15
	nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.ZIndex = 64
	nameLabel.Parent = card

	-- Описание товара
	local descLabel = Instance.new("TextLabel")
	descLabel.Name = "ItemDesc"
	descLabel.Position = UDim2.new(0, 76, 0, 36)
	descLabel.Size = UDim2.new(1, -84, 0, 28)
	descLabel.BackgroundTransparency = 1
	descLabel.Font = Enum.Font.FredokaOne
	descLabel.Text = item.desc
	descLabel.TextSize = 11
	descLabel.TextColor3 = Color3.fromRGB(175, 185, 205)
	descLabel.TextXAlignment = Enum.TextXAlignment.Left
	descLabel.TextWrapped = true
	descLabel.ZIndex = 64
	descLabel.Parent = card

	-- Нижняя панель карточки: цена и кнопка
	local bottomRow = Instance.new("Frame")
	bottomRow.Name = "BottomRow"
	bottomRow.AnchorPoint = Vector2.new(0, 1)
	bottomRow.Position = UDim2.new(0, 14, 1, -12)
	bottomRow.Size = UDim2.new(1, -28, 0, 36)
	bottomRow.BackgroundTransparency = 1
	bottomRow.ZIndex = 64
	bottomRow.Parent = card

	-- Цена
	local priceLabel = Instance.new("TextLabel")
	priceLabel.Name = "PriceLabel"
	priceLabel.AnchorPoint = Vector2.new(0, 0.5)
	priceLabel.Position = UDim2.new(0, 0, 0.5, 0)
	priceLabel.Size = UDim2.new(0.5, 0, 1, 0)
	priceLabel.BackgroundTransparency = 1
	priceLabel.Font = Enum.Font.FredokaOne
	priceLabel.Text = "💰 " .. item.price
	priceLabel.TextSize = 16
	priceLabel.TextColor3 = Color3.fromRGB(255, 220, 80)
	priceLabel.TextXAlignment = Enum.TextXAlignment.Left
	priceLabel.ZIndex = 65
	priceLabel.Parent = bottomRow

	-- Кнопка "Купить"
	local buyBtn = Instance.new("TextButton")
	buyBtn.Name = "BuyButton"
	buyBtn.AnchorPoint = Vector2.new(1, 0.5)
	buyBtn.Position = UDim2.new(1, 0, 0.5, 0)
	buyBtn.Size = UDim2.new(0.48, 0, 1, 0)
	buyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 240)
	buyBtn.AutoButtonColor = false
	buyBtn.Font = Enum.Font.FredokaOne
	buyBtn.Text = "Купить"
	buyBtn.TextSize = 14
	buyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	buyBtn.ZIndex = 65
	buyBtn.Parent = bottomRow

	buyBtn:SetAttribute("ItemId", item.id)

	local btnCorner2 = Instance.new("UICorner")
	btnCorner2.CornerRadius = UDim.new(0, 9)
	btnCorner2.Parent = buyBtn

	local btnStroke2 = Instance.new("UIStroke")
	btnStroke2.Thickness = 1.2
	btnStroke2.Color = Color3.fromRGB(255, 255, 255)
	btnStroke2.Transparency = 0.4
	btnStroke2.Parent = buyBtn

	local btnGrad2 = Instance.new("UIGradient")
	btnGrad2.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.0, Color3.fromRGB(0, 210, 255)),
		ColorSequenceKeypoint.new(1.0, Color3.fromRGB(0, 135, 220))
	})
	btnGrad2.Rotation = 45
	btnGrad2.Parent = buyBtn
end

-- ====================================================
-- Г. КЛИЕНТСКИЙ СКРИПТ (ShopClient LocalScript)
-- ====================================================
local clientScript = Instance.new("LocalScript")
clientScript.Name = "ShopClient"
clientScript.Source = [===[
--!strict
-- ShopClient: Клиентский контроллер анимаций кнопки, модального окна и покупок
-- ВНИМАНИЕ: Звуки полностью исключены согласно п.4 техзадания!
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local shopGui = script.Parent :: ScreenGui

local btnContainer = shopGui:WaitForChild("ShopButtonContainer") :: Frame
local shopOpenBtn = btnContainer:WaitForChild("ShopOpenButton") :: ImageButton
local btnScale = shopOpenBtn:WaitForChild("ButtonScale") :: UIScale
local btnStroke = shopOpenBtn:WaitForChild("ButtonStroke") :: UIStroke

local modalOverlay = shopGui:WaitForChild("ModalOverlay") :: Frame
local backdropBtn = modalOverlay:WaitForChild("BackdropButton") :: TextButton
local shopWindow = modalOverlay:WaitForChild("ShopWindow") :: CanvasGroup
local winScale = shopWindow:WaitForChild("WindowScale") :: UIScale
local header = shopWindow:WaitForChild("Header") :: Frame
local closeBtn = header:WaitForChild("CloseButton") :: TextButton
local balanceLabel = header:WaitForChild("BalancePill"):WaitForChild("BalanceLabel") :: TextLabel

local toast = shopWindow:WaitForChild("ToastNotification") :: Frame
local toastLabel = toast:WaitForChild("ToastLabel") :: TextLabel
local toastStroke = toast:WaitForChild("ToastStroke") :: UIStroke
local itemsScroll = shopWindow:WaitForChild("ItemsScroll") :: ScrollingFrame

local buyItemRemote = ReplicatedStorage:WaitForChild("BuyItem", 5) :: RemoteEvent?
local shopFeedbackRemote = ReplicatedStorage:WaitForChild("ShopFeedback", 5) :: RemoteEvent?

local isHovered = false
local isPressed = false
local isWindowOpen = false
local isPurchaseDebounce = false

-- 1. Синхронизация баланса из leaderstats
local function updateBalanceDisplay()
	local leaderstats = player:FindFirstChild("leaderstats")
	local money = leaderstats and leaderstats:FindFirstChild("Money") :: IntValue?
	if money then
		balanceLabel.Text = "💰 " .. tostring(money.Value)
	end
end

task.spawn(function()
	local leaderstats = player:WaitForChild("leaderstats", 10)
	if leaderstats then
		local money = leaderstats:WaitForChild("Money", 5) :: IntValue?
		if money then
			updateBalanceDisplay()
			money.Changed:Connect(updateBalanceDisplay)
		end
	end
end)

-- 2. Эффекты кнопки открытия магазина (п.3 техзадания)
-- Idle-анимация: кнопка слегка "дышит" (масштаб 1 -> 1.03 -> 1 по циклу)
task.spawn(function()
	while true do
		if not isHovered and not isPressed and not isWindowOpen then
			local breathUp = TweenService:Create(btnScale, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Scale = 1.03
			})
			breathUp:Play()
			breathUp.Completed:Wait()

			if not isHovered and not isPressed and not isWindowOpen then
				local breathDown = TweenService:Create(btnScale, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
					Scale = 1.0
				})
				breathDown:Play()
				breathDown.Completed:Wait()
			end
		else
			task.wait(0.2)
		end
	end
end)

-- Наведение (MouseEnter): плавное увеличение до 1.1x за 0.15 сек, обводка ярче
shopOpenBtn.MouseEnter:Connect(function()
	isHovered = true
	if not isPressed then
		TweenService:Create(btnScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = 1.1
		}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.0 -- Обводка становится ярче
		}):Play()
	end
end)

shopOpenBtn.MouseLeave:Connect(function()
	isHovered = false
	if not isPressed then
		TweenService:Create(btnScale, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Scale = 1.0
		}):Play()
		TweenService:Create(btnStroke, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 0.4
		}):Play()
	end
end)

-- Нажатие: уменьшение до 0.95x на 0.1 сек
shopOpenBtn.MouseButton1Down:Connect(function()
	isPressed = true
	TweenService:Create(btnScale, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Scale = 0.95
	}):Play()
end)

shopOpenBtn.MouseButton1Up:Connect(function()
	isPressed = false
	local targetScale = isHovered and 1.1 or 1.0
	TweenService:Create(btnScale, TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = targetScale
	}):Play()
end)

-- 3. Анимация открытия и закрытия окна магазина (п.1, 10, 11 техзадания)
local function openShop()
	if isWindowOpen then return end
	isWindowOpen = true
	updateBalanceDisplay()

	-- Открытие: масштаб от 0.8 до 1.0, прозрачность от 0.5 до 0
	winScale.Scale = 0.8
	shopWindow.GroupTransparency = 0.5
	shopWindow.Visible = true

	modalOverlay.BackgroundTransparency = 1.0
	modalOverlay.Visible = true

	TweenService:Create(modalOverlay, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.45
	}):Play()

	TweenService:Create(winScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Scale = 1.0
	}):Play()

	TweenService:Create(shopWindow, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		GroupTransparency = 0.0
	}):Play()
end

local function closeShop()
	if not isWindowOpen then return end
	isWindowOpen = false

	-- Закрытие: масштаб к 0.8, прозрачность к 1.0
	local tweenScale = TweenService:Create(winScale, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Scale = 0.8
	})
	local tweenTrans = TweenService:Create(shopWindow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		GroupTransparency = 1.0
	})
	local tweenOverlay = TweenService:Create(modalOverlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		BackgroundTransparency = 1.0
	})

	tweenScale:Play()
	tweenTrans:Play()
	tweenOverlay:Play()

	tweenTrans.Completed:Connect(function()
		if not isWindowOpen then
			shopWindow.Visible = false
			modalOverlay.Visible = false
		end
	end)
end

shopOpenBtn.MouseButton1Click:Connect(openShop)
closeBtn.MouseButton1Click:Connect(closeShop)
backdropBtn.MouseButton1Click:Connect(closeShop)

-- 4. Всплывающее уведомление о результате покупки
local function showToast(message: string, isSuccess: boolean)
	toastLabel.Text = message
	toastStroke.Color = isSuccess and Color3.fromRGB(0, 240, 150) or Color3.fromRGB(255, 80, 80)
	toast.BackgroundTransparency = 1.0
	toast.Visible = true

	TweenService:Create(toast, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0.1
	}):Play()

	task.delay(2.2, function()
		if toast.Visible then
			local fade = TweenService:Create(toast, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				BackgroundTransparency = 1.0
			})
			fade:Play()
			fade.Completed:Connect(function()
				if toast.BackgroundTransparency >= 0.95 then
					toast.Visible = false
				end
			end)
		end
	end)
end

if shopFeedbackRemote then
	shopFeedbackRemote.OnClientEvent:Connect(function(success: boolean, msg: string, newBalance: number)
		isPurchaseDebounce = false
		showToast(msg, success)
		updateBalanceDisplay()
	end)
end

-- 5. Подключение кнопок покупки товаров
for _, card in ipairs(itemsScroll:GetChildren()) do
	if card:IsA("Frame") and card.Name:find("Card_") then
		local bottomRow = card:FindFirstChild("BottomRow")
		local buyBtn = bottomRow and bottomRow:FindFirstChild("BuyButton") :: TextButton?
		if buyBtn then
			local itemId = buyBtn:GetAttribute("ItemId") :: string?

			-- Hover & Press эффекты для кнопки покупки
			buyBtn.MouseEnter:Connect(function()
				TweenService:Create(buyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(0, 215, 255)
				}):Play()
			end)

			buyBtn.MouseLeave:Connect(function()
				TweenService:Create(buyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundColor3 = Color3.fromRGB(0, 180, 240)
				}):Play()
			end)

			buyBtn.MouseButton1Click:Connect(function()
				if isPurchaseDebounce then return end
				if not itemId or not buyItemRemote then return end

				isPurchaseDebounce = true

				-- Микро-нажатие кнопки
				local origText = buyBtn.Text
				buyBtn.Text = "..."
				task.delay(0.25, function()
					buyBtn.Text = origText
				end)

				buyItemRemote:FireServer(itemId)

				-- Сброс дебаунса по таймауту на случай сетевых лагов
				task.delay(1.5, function()
					isPurchaseDebounce = false
				end)
			end)
		end
	end
end

print("[ShopClient] Клиент магазина инициализирован (беззвучный режим активен).")
]===]
clientScript.Parent = shopGui

print("ShopGui successfully generated in StarterGui!")
