--!strict
-- ShopServer: Серверный контроллер магазина, leaderstats и валидации покупок
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

-- 1. Каталог товаров на сервере (Server-Authoritative)
local ITEMS = {
	LaserSword = {
		name = "Космический Меч",
		price = 50,
		itemType = "tool",
		icon = "rbxassetid://16181366859",
		description = "+35 Урона в ближнем бою"
	},
	SpeedBoost = {
		name = "Зелье Скорости",
		price = 35,
		itemType = "speed",
		icon = "rbxassetid://12334656615",
		description = "+10 к скорости бега"
	},
	EnergyShield = {
		name = "Энергетический Щит",
		price = 40,
		itemType = "shield",
		icon = "rbxassetid://16181360172",
		description = "Увеличивает здоровье до 150 HP"
	},
	Medkit = {
		name = "Аптечка Здоровья",
		price = 25,
		itemType = "health",
		icon = "rbxassetid://16181402439",
		description = "Полное восстановление здоровья"
	}
}

-- 2. Создание RemoteEvents в ReplicatedStorage
local buyItemRemote = ReplicatedStorage:FindFirstChild("BuyItem") :: RemoteEvent?
if not buyItemRemote then
	buyItemRemote = Instance.new("RemoteEvent")
	buyItemRemote.Name = "BuyItem"
	buyItemRemote.Parent = ReplicatedStorage
end

local shopFeedbackRemote = ReplicatedStorage:FindFirstChild("ShopFeedback") :: RemoteEvent?
if not shopFeedbackRemote then
	shopFeedbackRemote = Instance.new("RemoteEvent")
	shopFeedbackRemote.Name = "ShopFeedback"
	shopFeedbackRemote.Parent = ReplicatedStorage
end

-- 3. Ссылка на шаблон LaserSword в ServerStorage
local swordTemplate = ServerStorage:FindFirstChild("LaserSwordTemplate") :: Tool?

-- 4. Инициализация игрока: leaderstats с валютой Money = 100
local function setupPlayer(player: Player)
	local leaderstats = player:FindFirstChild("leaderstats") :: Folder?
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local money = leaderstats:FindFirstChild("Money") :: IntValue?
	if not money then
		money = Instance.new("IntValue")
		money.Name = "Money"
		money.Value = 100 -- Начальный баланс по промпту
		money.Parent = leaderstats
	end
end

Players.PlayerAdded:Connect(setupPlayer)
for _, p in ipairs(Players:GetPlayers()) do
	setupPlayer(p)
end

-- 5. Серверная защита от спама кликов (Debounce per player)
local lastPurchaseTimes: {[Player]: number} = {}

-- 6. Обработка покупок от клиентов
buyItemRemote.OnServerEvent:Connect(function(player: Player, itemId: any)
	if typeof(itemId) ~= "string" then return end

	local now = os.clock()
	local lastTime = lastPurchaseTimes[player] or 0
	if now - lastTime < 0.25 then
		shopFeedbackRemote:FireClient(player, false, "Слишком частые запросы!", 0)
		return
	end
	lastPurchaseTimes[player] = now

	local item = ITEMS[itemId]
	if not item then
		shopFeedbackRemote:FireClient(player, false, "Товар не найден!", 0)
		return
	end

	local leaderstats = player:FindFirstChild("leaderstats")
	local money = leaderstats and leaderstats:FindFirstChild("Money") :: IntValue?
	if not money then
		shopFeedbackRemote:FireClient(player, false, "Ошибка счета игрока!", 0)
		return
	end

	-- Проверка баланса
	if money.Value < item.price then
		shopFeedbackRemote:FireClient(player, false, "Недостаточно монет! Требуется: " .. item.price, money.Value)
		return
	end

	local char = player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local backpack = player:FindFirstChildOfClass("Backpack")

	-- Проверка повторных покупок уникальных предметов
	if item.itemType == "tool" then
		local hasInBackpack = backpack and backpack:FindFirstChild(item.name)
		local hasInChar = char and char:FindFirstChild(item.name)
		if hasInBackpack or hasInChar then
			shopFeedbackRemote:FireClient(player, false, "Этот предмет уже у вас есть!", money.Value)
			return
		end
	end

	-- Списание средств
	money.Value -= item.price

	-- Выдача награды
	if item.itemType == "tool" then
		if backpack and swordTemplate then
			local newSword = swordTemplate:Clone()
			newSword.Name = item.name
			newSword.Parent = backpack
		end
	elseif item.itemType == "speed" then
		if humanoid then
			humanoid.WalkSpeed = 26
		end
	elseif item.itemType == "shield" then
		if humanoid then
			humanoid.MaxHealth = 150
			humanoid.Health = 150
		end
	elseif item.itemType == "health" then
		if humanoid then
			humanoid.Health = humanoid.MaxHealth
		end
	end

	print(string.format("[ShopServer] Игрок %s купил %s за %d монет. Остаток: %d", player.Name, item.name, item.price, money.Value))
	shopFeedbackRemote:FireClient(player, true, "Успешно куплено: " .. item.name .. "!", money.Value)
end)

print("[ShopServer] Серверный сервис магазина запущен с каталогом товаров и защитой leaderstats!")
