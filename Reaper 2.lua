local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacks/Utilities/main/UI.lua"))();

local Window = Library:CreateWindow("Autofarm")

local folder = Window:AddFolder("Main")

local folder2 = Window:AddFolder("Settings")

local Players = {};
for i,v in pairs(game.Players:GetChildren()) do
    table.insert(Players,v.Name)
end;

for i, v in next, getconnections(game.Players.LocalPlayer.Idled) do
    v:Disable();
end;

local plr = game:GetService("Players").LocalPlayer
local tweenService = game:GetService("TweenService")
getgenv().speed = 300
function toTarget(target)
    local speed = getgenv().speed
    local info = TweenInfo.new((target.Position - plr.Character.HumanoidRootPart.Position).Magnitude / speed, Enum.EasingStyle.Linear)
    local _, err = pcall(function()
        tweenService:Create(plr.Character.HumanoidRootPart, info, {CFrame = target}):Play()
    end)
    if err then error("Couldn't create/start tween: ", err) end
end
function newIndexHook()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__newindex
    setreadonly(mt, false)
    mt.__newindex = newcclosure(function(self, i, v)
        if checkcaller() and self == plr.Character.HumanoidRootPart and i == 'CFrame' then
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
            return toTarget(v) 
        end
        return oldIndex(self, i, v)
    end)

    setreadonly(mt, true)
end
newIndexHook()

game:GetService("RunService").Stepped:Connect(function()
if getgenv().Autofarm or getgenv().SP then
    for i,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
                 v.CanCollide = false
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
            end;
        end;
    end;
end);

local Mob = {};
_G.DIS = 6
for i,v in pairs(game:GetService("Workspace").Living:GetChildren()) do
if not table.find(Mob,v.Name) and not v:FindFirstChild("ClientHandler") and not v:FindFirstChild("xSIXxAnimationSaves") and not string.match(v.Name,"Masta") and v.Name ~= "Noob" then --//I'm so sorry you had to witness this i apolgize whoever sees this...
        table.insert(Mob,v.name)
    end;
end;

local Quest = {};
for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
pcall(function()
if v:IsA("Model") and not v:FindFirstChild("xSIXxAnimationSaves") then
        table.insert(Quest,v.Dialogue["1"]["2"].Quest.Value)
        end;
    end);
end;

for i, v in next, getconnections(game.Players.LocalPlayer.Idled) do
    v:Disable();
end;

folder:AddToggle({text = "Autofarm", callback = function(value) 
    getgenv().Autofarm = value
    
    while getgenv().Autofarm and wait() do
    pcall(function()
        for i,v in pairs(game:GetService("Workspace").Living:GetChildren()) do
            if game.Players.LocalPlayer.Character and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") then
                if v.Name == _G.Mob and v.Humanoid.Health > 0 then
                    repeat wait() 
                        local args = {[1] = {["inputType"] = Enum.UserInputType.MouseButton1,["keyCode"] = Enum.KeyCode.Unknown}}
                        game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(args))
                        if not game:GetService("Workspace").Food:FindFirstChildWhichIsA("Part") or not game:GetService("Workspace").Food:FindFirstChildWhichIsA("MeshPart") and _G.AutoEat then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame - Vector3.new(0,_G.DIS,0)
                        elseif not _G.Eat then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame - Vector3.new(0,_G.DIS,0)
                        end
                        until v.Humanoid.Health <= 0 or not getgenv().Autofarm
                    end;
                end;
            end;
        end);
    end;
end});

folder:AddToggle({text = "Auto Quest", callback = function(value) 
 _G.AutoQuest = value

while _G.AutoQuest and wait() do
pcall(function()
for i,v in pairs(game:GetService("Workspace").NPCs:GetChildren()) do
    if game:GetService("Players").LocalPlayer.PlayerGui.HUD:FindFirstChild("QuestsFrame2") then
        if not game:GetService("Players").LocalPlayer.PlayerGui.HUD.QuestsFrame2:FindFirstChild(_G.Quest) then wait(2)
                        game:GetService("ReplicatedStorage").Remotes.TakeQuest:FireServer(_G.Quest)
                    end;
                end;
            end;
        end);
    end;
end});

folder:AddList({text = "Mob", values = Mob, callback = function(value)
    _G.Mob = value
end});

folder:AddList({text = "Quests", values = Quest, callback = function(value)
    _G.Quest = value
end});


folder:AddSlider({text = 'Distance', min = 0, max = 10, callback = function(value) 
    _G.DIS = value
end});

folder2:AddToggle({text = "Auto Eat", callback = function(value) 
    _G.Eat = value
    while _G.Eat and wait() do
    pcall(function()
        for i, v in pairs(game:GetService("Workspace").Food:GetDescendants()) do
                if v:FindFirstChild("ProximityPrompt") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame - Vector3.new(0,-5,0)
                    fireproximityprompt(v.ProximityPrompt)
                end;
            end;
        end);
    end;
end});

folder2:AddToggle({text = "Auto Equip", callback = function(value) 
    _G.Equip = value

    while _G.Equip and wait(.3) do
        if game:GetService("Players").LocalPlayer.Status.Weapon.Value == nil then
            local a={[1]={["inputType"]=Enum.UserInputType.Keyboard,["keyCode"]=Enum.KeyCode.E}}game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(a))
        end;
    end;
end});

folder2:AddToggle({text = "Auto Adjust Mob", callback = function(value) 
    getgenv().SP = value
    
    while getgenv().SP and wait() do    
    pcall(function()
    local wtf = game:GetService("Players").LocalPlayer.PlayerGui.HUD.QuestsFrame2["Acquired Taste"].Frame.Objective

    if string.match(wtf.Text,"Kill 1 Clawed") or string.match(wtf.Text,"Kill 2 Clawed") then
            _G.Mob = "Clawed Hollow"
        elseif string.match(wtf.Text,"Kill 1 Winged") or string.match(wtf.Text,"Kill 2 Winged") and string.match(wtf.Text,"Kill 0 Clawed") then
            _G.Mob = "Winged Hollow"
        elseif string.match(wtf.Text,"Kill 1 Savage") and string.match(wtf.Text,"Kill 0 Clawed") and string.match(wtf.Text,"Kill 0 Winged") then
                _G.Mob = "Savage Hollow"
            end; 
        end);
    end;
end});

folder2:AddToggle({text = "Insta TP", callback = function(value) 
    _G.InstaTP = value

    if _G.InstaTP then
        getgenv().speed = 9e9
        game.Players.LocalPlayer.Name = "123imnotmomo"
    else
        getgenv().speed = 300
    end;
end})

folder2:AddButton({text = "Discord", callback = function(value) 
    setclipboard("https://discord.gg/FZdxeYc8WC")
end})

local Window2 = Library:CreateWindow("Skills")

local folder3 = Window2:AddFolder("Auto Use")

folder3:AddToggle({text = "Skill 1", callback = function(value)
    _G.One = value

    while _G.One and wait() do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "One", false, game); wait(1)
        local a={[1]={["inputType"]=Enum.UserInputType.MouseButton1,["keyCode"]=Enum.KeyCode.Unknown}}game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(a))
    end;
end});

folder3:AddToggle({text = "Skill 2", callback = function(value)
    _G.Two = value

    while _G.Two and wait() do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Two", false, game); wait(1)
        local a={[1]={["inputType"]=Enum.UserInputType.MouseButton1,["keyCode"]=Enum.KeyCode.Unknown}}game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(a))
    end;
end});

folder3:AddToggle({text = "Skill 3", callback = function(value)
    _G.Three = value

    while _G.Three and wait() do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Three", false, game); wait(1)
        local a={[1]={["inputType"]=Enum.UserInputType.MouseButton1,["keyCode"]=Enum.KeyCode.Unknown}}game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(a))
    end;
end});

folder3:AddToggle({text = "Skill 4", callback = function(value)
    _G.Four = value

    while _G.Four and wait() do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Four", false, game); wait(1)
        local a={[1]={["inputType"]=Enum.UserInputType.MouseButton1,["keyCode"]=Enum.KeyCode.Unknown}}game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(a))
    end;
end});

folder3:AddToggle({text = "Skill 5", callback = function(value)
    _G.Five = value

    while _G.Five and wait() do
        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Five", false, game); wait(1)
        local a={[1]={["inputType"]=Enum.UserInputType.MouseButton1,["keyCode"]=Enum.KeyCode.Unknown}}game:GetService("ReplicatedStorage").Remotes.Input:FireServer(unpack(a))
    end;
end});




Library:Init()
