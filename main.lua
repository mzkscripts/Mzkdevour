-- Full working script - mzk hub (mzk devour)
task.wait(1)

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- Remove old UI
local old = game.CoreGui:FindFirstChild("mzkfpsDevourUI")
if old then
    old:Destroy()
end

--  FPS BOOST (Mantido Original)
Lighting.GlobalShadows = false
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end

for _, v in ipairs(workspace:GetDescendants()) do
    if v:IsA("ParticleEmitter") then
        v.Enabled = false
    end
end

--  CHARACTER CLEAN (Agora limpa VOCÊ e os outros jogadores localmente)
local function cleanCharacter(char)
    -- Removida a linha que ignorava o LocalPlayer para que você também fique sem o agasalho
    local function removeStuff(obj)
        -- Remove acessórios, camisas, estampas e roupas 3D
        if obj:IsA("Accessory") or obj:IsA("ShirtGraphic") or obj:IsA("Shirt") or obj:IsA("Clothing") or obj:IsA("Pants") then
            obj:Destroy()
        end
    end

    for _, a in ipairs(char:GetChildren()) do
        removeStuff(a)
    end

    char.ChildAdded:Connect(function(c)
        task.wait(0.1)
        removeStuff(c)
    end)
end

-- Limpa quem já está no mapa
for _, h in ipairs(workspace:GetDescendants()) do
    if h:IsA("Humanoid") then
        cleanCharacter(h.Parent)
    end
end

-- Limpa quem entrar ou der spawn (incluindo você)
workspace.DescendantAdded:Connect(function(d)
    if d:IsA("Humanoid") then
        task.wait(0.1)
        cleanCharacter(d.Parent)
    end
end)

-- = GUI (Visual Novo: Vermelho Escuro + Borda Animada)
local gui = Instance.new("ScreenGui")
gui.Name = "mzkfpsDevourUI"
gui.Parent = game.CoreGui
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Parent = gui
main.Size = UDim2.new(0, 230, 0, 125)
main.Position = UDim2.new(0.5, -115, 0.5, -62)
main.BackgroundColor3 = Color3.fromRGB(45, 0, 0)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 22)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.15

local strokeGradient = Instance.new("UIGradient", stroke)
strokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100)),
})

task.spawn(function()
    while true do
        local tween = TweenService:Create(strokeGradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)})
        strokeGradient.Offset = Vector2.new(-1, 0)
        tween:Play()
        tween.Completed:Wait()
        task.wait(2)
    end
end)

local title = Instance.new("TextLabel")
title.Parent = main
title.Size = UDim2.new(1, -16, 0, 24)
title.Position = UDim2.new(0, 8, 0, 6)
title.BackgroundTransparency = 1
title.Text = "mzk devourer"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.new(1, 1, 1)
title.TextXAlignment = Enum.TextXAlignment.Center

local tiktok = Instance.new("TextLabel")
tiktok.Parent = main
tiktok.Size = UDim2.new(1, -16, 0, 14)
tiktok.Position = UDim2.new(0, 8, 0, 30)
tiktok.BackgroundTransparency = 1
tiktok.Text = "TikTok: mzkcommunity"
tiktok.Font = Enum.Font.Gotham
tiktok.TextSize = 12
tiktok.TextColor3 = Color3.fromRGB(255, 200, 200)
tiktok.TextXAlignment = Enum.TextXAlignment.Center

local button = Instance.new("TextButton")
button.Parent = main
button.Size = UDim2.new(1, -40, 0, 44)
button.Position = UDim2.new(0, 20, 0, 54)
button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "Devour"
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.TextColor3 = Color3.fromRGB(150, 0, 0)
button.BorderSizePixel = 0
button.AutoButtonColor = true

local btnCorner = Instance.new("UICorner", button)
btnCorner.CornerRadius = UDim.new(0, 16)

local discord = Instance.new("TextLabel")
discord.Parent = main
discord.Size = UDim2.new(1, 0, 0, 20)
discord.Position = UDim2.new(0, 0, 1, -22)
discord.BackgroundTransparency = 1
discord.Text = "https://discord.gg/W98hjTa6w"
discord.Font = Enum.Font.Gotham
discord.TextSize = 14
discord.TextColor3 = Color3.fromRGB(255, 200, 200)
discord.TextXAlignment = Enum.TextXAlignment.Center

--  BUTTON LOGIC (Mantido Original)
local originalText = "Devour"
button.MouseButton1Click:Connect(function()
    button.Text = "WORKING"
    button.AutoButtonColor = false

    local char = LocalPlayer.Character
    if not char then
        button.Text = "ERROR"
        task.wait(1)
        button.Text = originalText
        button.AutoButtonColor = true
        return
    end

    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local tool = Backpack:FindFirstChild("Quantum Cloner")

    if not humanoid or not tool then
        button.Text = "ERROR"
        task.wait(1)
        button.Text = originalText
        button.AutoButtonColor = true
        return
    end

    humanoid:EquipTool(tool)
    task.wait(0.1)

    for _, t in ipairs(Backpack:GetChildren()) do
        if t:IsA("Tool") then
            t.Parent = char
        end
    end

    task.wait(0.1)
    tool:Activate()

    task.delay(0.6, function()
        button.Text = originalText
        button.AutoButtonColor = true
    end)
end)
