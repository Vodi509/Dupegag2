-- =====================================================
--  Visual Plot Duper для Grow a Garden 2
--  ВСЕ РЕАЛЬНЫЕ КУЛЬТУРЫ (27 шт)
-- =====================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- Кнопка
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DupePanel"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 280, 0, 60)
btn.Position = UDim2.new(0.5, -140, 0.5, -30)
btn.Text = "🌱 Дюп грядок (все фрукты)"
btn.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
btn.TextColor3 = Color3.new(1,1,1)
btn.Font = Enum.Font.Bold
btn.TextSize = 18
btn.Parent = screenGui

-- ===== ВСЕ РЕАЛЬНЫЕ КУЛЬТУРЫ ИЗ GROW A GARDEN 2 =====
local fruitEmojis = {
    -- Common
    ["carrot"] = "🥕",
    ["strawberry"] = "🍓",
    ["blueberry"] = "🫐",
    -- Uncommon
    ["tulip"] = "🌷",
    ["tomato"] = "🍅",
    ["apple"] = "🍎",
    -- Rare
    ["bamboo"] = "🎋",
    ["corn"] = "🌽",
    ["cactus"] = "🌵",
    ["pineapple"] = "🍍",
    ["baby cactus"] = "🌵",
    ["horned melon"] = "🍈",
    -- Epic
    ["mushroom"] = "🍄",
    ["green bean"] = "🫘",
    ["banana"] = "🍌",
    ["grape"] = "🍇",
    ["coconut"] = "🥥",
    ["mango"] = "🥭",
    ["glow mushroom"] = "🍄",
    -- Legendary
    ["dragon fruit"] = "🐉",
    ["acorn"] = "🌰",
    ["cherry"] = "🍒",
    ["sunflower"] = "🌻",
    ["poison ivy"] = "☘️",
    -- Mythic
    ["venus fly trap"] = "🪴",
    ["pomegranate"] = "🍎",
    ["poison apple"] = "☠️",
    ["ghost pepper"] = "👻",
    -- Super
    ["moon bloom"] = "🌙",
    ["dragon's breath"] = "🐲",
}

local function getFruitEmoji(name)
    local lower = name:lower()
    for key, emoji in pairs(fruitEmojis) do
        if lower:find(key) then
            return emoji
        end
    end
    return "🌿"
end

local function dupePlots()
    local plots = {}
    
    -- Ищем грядки с растениями
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj:FindFirstChild("Plant") or obj:FindFirstChildWhichIsA("BasePart")) then
            -- Проверяем владельца
            local owner = obj:GetAttribute("Owner") or obj:GetAttribute("Player")
            if not owner or owner == LocalPlayer.Name or owner == tostring(LocalPlayer.UserId) then
                -- Проверяем по всем ключам словаря
                for fruitName, _ in pairs(fruitEmojis) do
                    if obj.Name:lower():find(fruitName) or 
                       (obj:FindFirstChild("Plant") and obj.Plant.Name:lower():find(fruitName)) then
                        table.insert(plots, obj)
                        break
                    end
                end
            end
        end
    end

    if #plots == 0 then
        btn.Text = "❌ Нет своих грядок с культурами"
        task.wait(1.5)
        btn.Text = "🌱 Дюп грядок (все фрукты)"
        return
    end

    btn.Text = "🌀 Дюпаю " .. #plots .. " грядок..."

    for _, plot in ipairs(plots) do
        local clone = plot:Clone()
        clone.Parent = Workspace
        clone.Name = plot.Name .. "_duped"
        
        -- Сдвиг
        local primary = plot:GetPrimaryPartCFrame()
        if primary then
            clone:SetPrimaryPartCFrame(primary + Vector3.new(5, 0, 5))
        end
        
        -- Стикер
        local plant = clone:FindFirstChild("Plant") or clone
        local attachPart = plant:FindFirstChild("Handle") or plant:FindFirstChildWhichIsA("BasePart") or clone:FindFirstChildWhichIsA("BasePart")
        
        if attachPart then
            local sticker = Instance.new("BillboardGui")
            sticker.Name = "FruitSticker"
            sticker.Size = UDim2.new(0, 50, 0, 50)
            sticker.Adornee = attachPart
            sticker.AlwaysOnTop = true
            sticker.Parent = clone
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = getFruitEmoji(plot.Name)
            label.TextSize = 40
            label.TextScaled = true
            label.Font = Enum.Font.SourceSansBold
            label.TextColor3 = Color3.new(0, 1, 0)
            label.Parent = sticker
            
            sticker.Enabled = false
            task.wait(0.05)
            sticker.Enabled = true
        end
        
        task.wait(0.15)
    end

    btn.Text = "✅ " .. #plots .. " копий (исчезнут после релога)"
    task.wait(2.5)
    btn.Text = "🌱 Дюп грядок (все фрукты)"
end

btn.MouseButton1Click:Connect(dupePlots)

task.wait(2)
dupePlots()
