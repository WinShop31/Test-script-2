-- Скрипт для Roblox: Murder Mystery 2 - Автосбор пасхальных яиц с улучшенным GUI, WH и уведомлениями (by Fills)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Создание GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "MM2EggFarmGui"

-- Основной фрейм хаба
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIShadow = Instance.new("UIStroke")
UIShadow.Thickness = 2
UIShadow.Color = Color3.fromRGB(0, 0, 0)
UIShadow.Transparency = 0.5
UIShadow.Parent = MainFrame

-- Заголовок хаба
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 Egg Farm by Fills"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Кнопка переключения на вкладку Egg Farm
local EggFarmTabButton = Instance.new("TextButton")
EggFarmTabButton.Size = UDim2.new(0.5, 0, 0, 40)
EggFarmTabButton.Position = UDim2.new(0, 0, 0, 40)
EggFarmTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
EggFarmTabButton.Text = "Egg Farm"
EggFarmTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
EggFarmTabButton.TextSize = 16
EggFarmTabButton.Font = Enum.Font.Gotham
EggFarmTabButton.Parent = MainFrame

-- Кнопка переключения на вкладку Safety
local SafetyTabButton = Instance.new("TextButton")
SafetyTabButton.Size = UDim2.new(0.5, 0, 0, 40)
SafetyTabButton.Position = UDim2.new(0.5, 0, 0, 40)
SafetyTabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SafetyTabButton.Text = "Safety"
SafetyTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SafetyTabButton.TextSize = 16
SafetyTabButton.Font = Enum.Font.Gotham
SafetyTabButton.Parent = MainFrame

-- Вкладка Egg Farm
local EggFarmTab = Instance.new("Frame")
EggFarmTab.Size = UDim2.new(1, 0, 1, -80)
EggFarmTab.Position = UDim2.new(0, 0, 0, 80)
EggFarmTab.BackgroundTransparency = 1
EggFarmTab.Visible = true
EggFarmTab.Parent = MainFrame

-- Кнопка Auto Farm All Eggs
local AutoFarmAllButton = Instance.new("TextButton")
AutoFarmAllButton.Size = UDim2.new(0, 200, 0, 50)
AutoFarmAllButton.Position = UDim2.new(0.5, -100, 0, 30)
AutoFarmAllButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AutoFarmAllButton.Text = "Auto Farm All Eggs: OFF"
AutoFarmAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoFarmAllButton.TextSize = 16
AutoFarmAllButton.Font = Enum.Font.Gotham
AutoFarmAllButton.Parent = EggFarmTab

local AutoFarmAllButtonCorner = Instance.new("UICorner")
AutoFarmAllButtonCorner.CornerRadius = UDim.new(0, 8)
AutoFarmAllButtonCorner.Parent = AutoFarmAllButton

-- Кнопка Auto Grab Rare Egg
local AutoGrabRareButton = Instance.new("TextButton")
AutoGrabRareButton.Size = UDim2.new(0, 200, 0, 50)
AutoGrabRareButton.Position = UDim2.new(0.5, -100, 0, 90)
AutoGrabRareButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AutoGrabRareButton.Text = "Auto Grab Rare Egg: OFF"
AutoGrabRareButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoGrabRareButton.TextSize = 16
AutoFarmAllButton.Font = Enum.Font.Gotham
AutoGrabRareButton.Parent = EggFarmTab

local AutoGrabRareButtonCorner = Instance.new("UICorner")
AutoGrabRareButtonCorner.CornerRadius = UDim.new(0, 8)
AutoGrabRareButtonCorner.Parent = AutoGrabRareButton

-- Вкладка Safety
local SafetyTab = Instance.new("Frame")
SafetyTab.Size = UDim2.new(1, 0, 1, -80)
SafetyTab.Position = UDim2.new(0, 0, 0, 80)
SafetyTab.BackgroundTransparency = 1
SafetyTab.Visible = false
SafetyTab.Parent = MainFrame

-- Кнопка ESP
local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0, 200, 0, 50)
ESPButton.Position = UDim2.new(0.5, -100, 0, 30)
ESPButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
ESPButton.Text = "ESP: OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 16
ESPButton.Font = Enum.Font.Gotham
ESPButton.Parent = SafetyTab

local ESPButtonCorner = Instance.new("UICorner")
ESPButtonCorner.CornerRadius = UDim.new(0, 8)
ESPButtonCorner.Parent = ESPButton

-- Кнопка открытия/закрытия хаба
local ToggleButton = Instance.new("ImageButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 10, 0, 10)
ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
ToggleButton.Image = "rbxassetid://76737084372258"
ToggleButton.Parent = ScreenGui

local ToggleButtonCorner = Instance.new("UICorner")
ToggleButtonCorner.CornerRadius = UDim.new(0, 25)
ToggleButtonCorner.Parent = ToggleButton

-- GUI для уведомлений в стиле достижений Minecraft
local NotificationFrame = Instance.new("Frame")
NotificationFrame.Size = UDim2.new(0, 250, 0, 60)
NotificationFrame.Position = UDim2.new(1, -260, 0, 10)
NotificationFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
NotificationFrame.BorderSizePixel = 0
NotificationFrame.Visible = false
NotificationFrame.Parent = ScreenGui

local NotificationCorner = Instance.new("UICorner")
NotificationCorner.CornerRadius = UDim.new(0, 8)
NotificationCorner.Parent = NotificationFrame

local NotificationTitle = Instance.new("TextLabel")
NotificationTitle.Size = UDim2.new(1, 0, 0, 20)
NotificationTitle.Position = UDim2.new(0, 0, 0, 5)
NotificationTitle.BackgroundTransparency = 1
NotificationTitle.Text = "Rare Egg Spawned!"
NotificationTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
NotificationTitle.TextSize = 16
NotificationTitle.Font = Enum.Font.GothamBold
NotificationTitle.Parent = NotificationFrame

local NotificationText = Instance.new("TextLabel")
NotificationText.Size = UDim2.new(1, 0, 0, 30)
NotificationText.Position = UDim2.new(0, 0, 0, 25)
NotificationText.BackgroundTransparency = 1
NotificationText.Text = "A rare egg has spawned!"
NotificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
NotificationText.TextSize = 14
NotificationText.Font = Enum.Font.Gotham
NotificationText.Parent = NotificationFrame

-- Переменные для автосбора
local isAutoFarmingAll = false
local isAutoGrabbingRare = false
local isESPEnabled = false
local espConnections = {}
local eggHighlights = {}
local knownEggs = {} -- Для отслеживания уже найденных яиц

-- Переменные для перетаскивания кнопки
local isDragging = false
local dragStart = nil
local startPos = nil

-- Список редких яиц из Easter Event 2025
local rareEggNames = {
    "Diamond Egg", "Police Egg", "Construction Egg", "Office Egg", "Doctor Egg",
    "Military Egg", "Experiment Egg", "Speedy Egg", "Scientist Egg", "Robot Egg"
}

-- Функция для переключения вкладок
local function showTab(tab)
    EggFarmTab.Visible = (tab == EggFarmTab)
    SafetyTab.Visible = (tab == SafetyTab)
    EggFarmTabButton.BackgroundColor3 = (tab == EggFarmTab) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
    SafetyTabButton.BackgroundColor3 = (tab == SafetyTab) and Color3.fromRGB(70, 70, 70) or Color3.fromRGB(50, 50, 50)
end

-- Функция для проверки, находится ли игрок в лобби
local function isInLobby()
    local map = Workspace:FindFirstChild("Map")
    if map and map.Name == "Lobby" then
        return true
    end

    local status = ReplicatedStorage:FindFirstChild("GameStatus")
    if status and status.Value == "Waiting" then
        return true
    end

    for _, child in pairs(Workspace:GetChildren()) do
        if child.Name == "Lobby" then
            return true
        end
    end

    return false
end

-- Функция для отображения уведомления
local function showNotification(eggName)
    NotificationText.Text = eggName .. " has spawned!"
    NotificationFrame.Visible = true

    -- Анимация появления
    local tweenIn = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -260, 0, 10)})
    tweenIn:Play()
    tweenIn.Completed:Wait()

    -- Задержка перед исчезновением
    wait(3)

    -- Анимация исчезновения
    local tweenOut = TweenService:Create(NotificationFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 0, 10)})
    tweenOut:Play()
    tweenOut.Completed:Wait()
    NotificationFrame.Visible = false
end

-- Функция для поиска ближайшего яйца
local function findNearestEgg(isRareOnly)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end

    local humanoidRootPart = character.HumanoidRootPart
    local closestEgg = nil
    local closestDistance = math.huge

    for _, obj in pairs(Workspace:GetChildren()) do -- Проверяем только прямых потомков Workspace для оптимизации
        if obj:IsA("BasePart") and (obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("TouchInterest")) then
            local isEgg = obj.Name:lower():find("egg") or obj.Name:lower():find("peppermint")
            local isRareEgg = false
            for _, rareName in pairs(rareEggNames) do
                if obj.Name == rareName then
                    isRareEgg = true
                    break
                end
            end

            if isEgg or isRareEgg then
                if isRareOnly and not isRareEgg then
                    continue
                end
                local distance = (obj.Position - humanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestEgg = obj
                end
            end
        end
    end

    return closestEgg
end

-- Функция для автосбора всех яиц
local function autoFarmAllEggs()
    while isAutoFarmingAll do
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            wait(1)
            continue
        end

        if isInLobby() then
            wait(1)
            continue
        end

        local humanoidRootPart = character.HumanoidRootPart
        local nearestEgg = findNearestEgg(false)

        if nearestEgg then
            humanoidRootPart.CFrame = CFrame.new(nearestEgg.Position + Vector3.new(0, 3, 0))
            wait(0.2)

            if nearestEgg:FindFirstChildOfClass("ProximityPrompt") then
                fireproximityprompt(nearestEgg:FindFirstChildOfClass("ProximityPrompt"))
            elseif nearestEgg:FindFirstChild("TouchInterest") then
                humanoidRootPart.CFrame = CFrame.new(nearestEgg.Position)
            end

            nearestEgg:Destroy()
            wait(0.3)
        else
            wait(0.5)
        end
    end
end

-- Функция для автосбора редких яиц с телепортацией
local function autoGrabRareEgg()
    while isAutoGrabbingRare do
        local character = LocalPlayer.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            wait(1)
            continue
        end

        if isInLobby() then
            wait(1)
            continue
        end

        local humanoidRootPart = character.HumanoidRootPart
        local nearestRareEgg = findNearestEgg(true)

        if nearestRareEgg then
            humanoidRootPart.CFrame = CFrame.new(nearestRareEgg.Position + Vector3.new(0, 3, 0))
            wait(0.5)
            if nearestRareEgg:FindFirstChildOfClass("ProximityPrompt") then
                fireproximityprompt(nearestRareEgg:FindFirstChildOfClass("ProximityPrompt"))
            elseif nearestRareEgg:FindFirstChild("TouchInterest") then
                humanoidRootPart.CFrame = CFrame.new(nearestRareEgg.Position)
            end
            nearestRareEgg:Destroy()
            wait(0.5)
        else
            wait(1)
        end
    end
end

-- Функция для обновления WH (ESP) яиц
local function updateEggESP()
    for _, highlight in pairs(eggHighlights) do
        highlight:Destroy()
    end
    eggHighlights = {}

    for _, obj in pairs(Workspace:GetChildren()) do
        if obj:IsA("BasePart") and (obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChild("TouchInterest")) then
            local isRareEgg = false
            for _, rareName in pairs(rareEggNames) do
                if obj.Name == rareName then
                    isRareEgg = true
                    break
                end
            end

            if isRareEgg then
                local highlight = Instance.new("Highlight")
                highlight.Name = "EggHighlight"
                highlight.Adornee = obj
                highlight.FillTransparency = 0.3 -- Уменьшенная прозрачность для лучшей видимости
                highlight.OutlineTransparency = 0
                highlight.FillColor = Color3.fromRGB(255, 165, 0)
                highlight.Parent = obj
                table.insert(eggHighlights, highlight)
            end
        end
    end
end

-- Функция для отслеживания спавна редких яиц и показа уведомлений
local function monitorRareEggs()
    Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("BasePart") and (descendant:FindFirstChildOfClass("ProximityPrompt") or descendant:FindFirstChild("TouchInterest")) then
            for _, rareName in pairs(rareEggNames) do
                if descendant.Name == rareName and not knownEggs[descendant] then
                    knownEggs[descendant] = true
                    spawn(function()
                        showNotification(rareName)
                    end)
                    break
                end
            end
        end
    end)

    Workspace.DescendantRemoving:Connect(function(descendant)
        if knownEggs[descendant] then
            knownEggs[descendant] = nil
        end
    end)
end

-- Функция для включения/выключения ESP
local function toggleESP()
    if isESPEnabled then
        for _, connection in pairs(espConnections) do
            connection:Disconnect()
        end
        espConnections = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
        for _, highlight in pairs(eggHighlights) do
            highlight:Destroy()
        end
        eggHighlights = {}
        isESPEnabled = false
        ESPButton.Text = "ESP: OFF"
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    else
        isESPEnabled = true
        ESPButton.Text = "ESP: ON"
        ESPButton.BackgroundColor3 = Color3.fromRGB(0, 255, 120)

        local function updateESP()
            for _, player in pairs(Players:GetPlayers()) do
                if player == LocalPlayer or not player.Character then continue end

                local character = player.Character
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                if not humanoidRootPart then continue end

                local highlight = character:FindFirstChild("ESPHighlight") or Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.Adornee = character
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = character

                if character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                elseif character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
                    highlight.FillColor = Color3.fromRGB(0, 0, 255)
                else
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                end
            end

            updateEggESP()
        end

        updateESP()

        -- Обновление ESP раз в 0.5 секунды для оптимизации
        table.insert(espConnections, RunService.Heartbeat:Connect(function()
            if tick() % 0.5 < 0.1 then
                updateESP()
            end
        end))

        table.insert(espConnections, Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(function()
                wait(0.1)
                updateESP()
            end)
        end))
    end
end

-- Анимация открытия/закрытия хаба
local function toggleMenu()
    if MainFrame.Visible then
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.5, -150), Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Wait()
        MainFrame.Visible = false
    else
        MainFrame.Visible = true
        local tween = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -150, 0.5, -150), Size = UDim2.new(0, 300, 0, 300)})
        tween:Play()
    end
end

-- Обработка перетаскивания кнопки
UserInputService.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not isDragging then
        local position = input.Position
        local buttonPos = ToggleButton.AbsolutePosition
        local buttonSize = ToggleButton.AbsoluteSize
        if position.X >= buttonPos.X and position.X <= buttonPos.X + buttonSize.X and position.Y >= buttonPos.Y and position.Y <= buttonPos.Y + buttonSize.Y then
            isDragging = true
            dragStart = Vector2.new(position.X, position.Y)
            startPos = ToggleButton.Position
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local position = input.Position
        local delta = Vector2.new(position.X, position.Y) - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

        local screenSize = ScreenGui.AbsoluteSize
        local buttonSize = ToggleButton.AbsoluteSize
        local minX = 0
        local minY = 0
        local maxX = screenSize.X - buttonSize.X
        local maxY = screenSize.Y - buttonSize.Y

        newPos = UDim2.new(
            0, math.clamp(newPos.X.Offset, minX, maxX),
            0, math.clamp(newPos.Y.Offset, minY, maxY)
        )

        ToggleButton.Position = newPos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- Обработчики кнопок
EggFarmTabButton.MouseButton1Click:Connect(function()
    showTab(EggFarmTab)
end)

SafetyTabButton.MouseButton1Click:Connect(function()
    showTab(SafetyTab)
end)

AutoFarmAllButton.MouseButton1Click:Connect(function()
    isAutoFarmingAll = not isAutoFarmingAll
    AutoFarmAllButton.Text = "Auto Farm All Eggs: " .. (isAutoFarmingAll and "ON" or "OFF")
    AutoFarmAllButton.BackgroundColor3 = isAutoFarmingAll and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(0, 120, 255)
    if isAutoFarmingAll then
        isAutoGrabbingRare = false
        AutoGrabRareButton.Text = "Auto Grab Rare Egg: OFF"
        AutoGrabRareButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        spawn(autoFarmAllEggs)
    end
end)

AutoGrabRareButton.MouseButton1Click:Connect(function()
    isAutoGrabbingRare = not isAutoGrabbingRare
    AutoGrabRareButton.Text = "Auto Grab Rare Egg: " .. (isAutoGrabbingRare and "ON" or "OFF")
    AutoGrabRareButton.BackgroundColor3 = isAutoGrabbingRare and Color3.fromRGB(0, 255, 120) or Color3.fromRGB(0, 120, 255)
    if isAutoGrabbingRare then
        isAutoFarmingAll = false
        AutoFarmAllButton.Text = "Auto Farm All Eggs: OFF"
        AutoFarmAllButton.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        spawn(autoGrabRareEgg)
    end
end)

ESPButton.MouseButton1Click:Connect(toggleESP)

ToggleButton.MouseButton1Click:Connect(toggleMenu)

-- Обработка смерти игрока
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if isAutoFarmingAll and not isInLobby() then
        spawn(autoFarmAllEggs)
    end
end)

-- Запуск мониторинга редких яиц
monitorRareEggs()

-- Уведомление о запуске скрипта
print("MM2 Easter Egg Farm Script with GUI by Fills is running!")
