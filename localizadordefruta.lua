local player = game.Players.LocalPlayer

-- Aguarda personagem
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- Atualiza o hrp ao respawnar
player.CharacterAdded:Connect(function(char)
    character = char
    hrp = char:WaitForChild("HumanoidRootPart")
end)

-- Cria label na tela
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FruitNotifier"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 300, 0, 40)
label.Position = UDim2.new(0.5, -150, 0, 20)
label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
label.BackgroundTransparency = 0.4
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 16
label.Font = Enum.Font.GothamBold
label.Text = ""
label.Visible = false
label.Parent = screenGui

local corner = Instance.new("UICorner", label)
corner.CornerRadius = UDim.new(0, 8)

-- Mostra texto por X segundos (0 = permanente)
local function showText(text, time)
    label.Text = text
    label.Visible = true
    if time and time > 0 then
        task.wait(time)
        label.Visible = false
    end
end

-- Rastreia uma fruta enquanto ela existir
local function trackFruit(fruit)
    local handle = fruit:FindFirstChild("Handle")
    if not handle then return end

    showText("🍎 " .. fruit.Name .. " spawnada!", 2)

    while fruit and fruit.Parent do
        if hrp then
            local dist = math.floor((hrp.Position - handle.Position).Magnitude)
            label.Text = "🍎 " .. fruit.Name .. " — " .. dist .. "m"
            label.Visible = true
        end
        task.wait(0.2)
    end

    showText("❌ " .. fruit.Name .. " coletada/despawnada.", 3)
end

-- Verifica se o objeto é uma fruta pelo nome
local function isFruit(name)
    -- Ajuste os nomes conforme aparecem no seu jogo
    return name:find("Fruit") or name:find("fruit")
end

-- Frutas já existentes no workspace
for _, obj in ipairs(workspace:GetChildren()) do
    if isFruit(obj.Name) then
        task.spawn(trackFruit, obj)
    end
end

-- Escuta novas frutas
workspace.ChildAdded:Connect(function(child)
    if isFruit(child.Name) then
        task.spawn(trackFruit, child)
    end
end)
