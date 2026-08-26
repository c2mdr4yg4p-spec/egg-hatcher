-- Egg Hatcher UI
-- Enhanced version with game integration
-- Configure the RemoteEvent/RemoteFunction paths for your game

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- ====== CONFIGURATION ======
-- Modify these paths to match your game's remote event/function locations
local REMOTES_PATH = game.ReplicatedStorage:WaitForChild("Remotes") -- Adjust path as needed
local PLACE_EGG_REMOTE = REMOTES_PATH:WaitForChild("PlaceEgg") -- RemoteFunction or RemoteEvent
local HATCH_EGG_REMOTE = REMOTES_PATH:WaitForChild("HatchEgg") -- RemoteFunction or RemoteEvent

-- ====== EGG DATABASE ======
local eggs = {
    "Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg",
    "Bug Egg", "Jungle Egg", "Gem Egg", "Paradise Egg", "Dinosaur Egg",
    "Primal Egg", "Night Egg", "Bee Egg", "Anti Bee Egg", "Enchanted Egg",
    "Zen Egg", "Corrupted Zen Egg", "Sprout Egg", "Campfire Egg", "Oasis Egg",
    "Safari Egg", "Spooky Egg", "Winter Egg", "Christmas Egg", "Carnival Egg",
    "Bird Egg", "Gourmet Egg", "Springtide Egg", "Fall Egg", "New Year's Egg",
    "Common Summer Egg", "Rare Summer Egg",

    "Premium Anti Bee Egg", "Premium Bird Egg", "Premium Campfire Egg",
    "Premium Carnival Egg", "Premium Christmas Egg", "Premium Fall Egg",
    "Premium Hive Egg", "Premium New Year's Egg", "Premium Night Egg",
    "Premium Oasis Egg", "Premium Primal Egg", "Premium Safari Egg",
    "Premium Spooky Egg", "Premium Winter Egg",
    "Rainbow Premium Primal Egg", "Hive Egg", "Mythical Bee Egg",
    "Transcendent Bee Egg", "Lich Crystal Egg", "Exotic Bug Egg"
}

-- ====== STATE VARIABLES ======
local selectedEgg = eggs[1]
local eggCount = 1
local placeDelay = 1
local hatchDelay = 1
local positionMode = "Line Left"
local autoPlace = false
local autoHatch = false
local running = false
local lastError = nil

-- ====== GUI SETUP ======
local gui = Instance.new("ScreenGui")
gui.Name = "EggHatcher"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(360, 570)
main.Position = UDim2.new(0.5, -180, 0.5, -285)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "🥚 Egg Hatcher"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.Parent = main

-- Search box
local search = Instance.new("TextBox")
search.Size = UDim2.new(1, -30, 0, 35)
search.Position = UDim2.fromOffset(15, 55)
search.PlaceholderText = "Search egg..."
search.Text = ""
search.TextSize = 14
search.Font = Enum.Font.Gotham
search.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
search.TextColor3 = Color3.new(1, 1, 1)
search.Parent = main

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 7)
searchCorner.Parent = search

-- Dropdown
local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(1, -30, 0, 35)
dropdown.Position = UDim2.fromOffset(15, 100)
dropdown.Text = selectedEgg .. " ▼"
dropdown.TextSize = 14
dropdown.Font = Enum.Font.Gotham
dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Parent = main

local dropCorner = Instance.new("UICorner")
dropCorner.CornerRadius = UDim.new(0, 7)
dropCorner.Parent = dropdown

-- Egg list
local eggList = Instance.new("ScrollingFrame")
eggList.Size = UDim2.new(1, -30, 0, 150)
eggList.Position = UDim2.fromOffset(15, 140)
eggList.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
eggList.Visible = false
eggList.CanvasSize = UDim2.new()
eggList.ScrollBarThickness = 4
eggList.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 2)
layout.Parent = eggList

local function refreshEggs()
    for _, child in ipairs(eggList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local query = string.lower(search.Text)

    for _, egg in ipairs(eggs) do
        if query == "" or string.find(string.lower(egg), query, 1, true) then
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -5, 0, 28)
            button.Text = egg
            button.TextSize = 13
            button.Font = Enum.Font.Gotham
            button.TextColor3 = Color3.new(1, 1, 1)
            button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            button.Parent = eggList

            button.MouseButton1Click:Connect(function()
                selectedEgg = egg
                dropdown.Text = egg .. " ▼"
                eggList.Visible = false
            end)
        end
    end
    
    eggList.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
end

refreshEggs()

dropdown.MouseButton1Click:Connect(function()
    eggList.Visible = not eggList.Visible
end)

search:GetPropertyChangedSignal("Text"):Connect(refreshEggs)

-- ====== INPUT FIELDS ======
local function createInput(name, y, default)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, -20, 0, 30)
    label.Position = UDim2.fromOffset(15, y)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = main

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5, -20, 0, 30)
    input.Position = UDim2.new(0.5, 5, 0, y)
    input.Text = tostring(default)
    input.TextSize = 14
    input.Font = Enum.Font.Gotham
    input.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = input

    return input
end

local countInput = createInput("Number of Eggs", 305, 1)
local placeInput = createInput("Place Delay", 345, 1)
local hatchInput = createInput("Hatch Delay", 385, 1)

-- ====== POSITION MODE ======
local position = Instance.new("TextButton")
position.Size = UDim2.new(1, -30, 0, 30)
position.Position = UDim2.fromOffset(15, 425)
position.Text = "Position: Line Left"
position.TextSize = 14
position.Font = Enum.Font.Gotham
position.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
position.TextColor3 = Color3.new(1, 1, 1)
position.Parent = main

local pc = Instance.new("UICorner")
pc.CornerRadius = UDim.new(0, 7)
pc.Parent = position

position.MouseButton1Click:Connect(function()
    if positionMode == "Line Left" then
        positionMode = "Stacked"
    else
        positionMode = "Line Left"
    end
    position.Text = "Position: " .. positionMode
end)

-- ====== TOGGLE HELPER ======
local function createToggle(text, y, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -30, 0, 30)
    button.Position = UDim2.fromOffset(15, y)
    button.Text = "☐ " .. text
    button.TextSize = 14
    button.Font = Enum.Font.Gotham
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Parent = main

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 7)
    c.Parent = button

    local state = false

    button.MouseButton1Click:Connect(function()
        state = not state
        button.Text = (state and "☑ " or "☐ ") .. text
        callback(state)
    end)
    
    return button
end

createToggle("Auto Place Eggs", 465, function(value)
    autoPlace = value
end)

createToggle("Auto Hatch Eggs", 500, function(value)
    autoHatch = value
end)

-- ====== START/STOP BUTTON ======
local startButton = Instance.new("TextButton")
startButton.Size = UDim2.new(1, -30, 0, 40)
startButton.Position = UDim2.fromOffset(15, 535)
startButton.Text = "▶ START"
startButton.TextSize = 16
startButton.Font = Enum.Font.GothamBold
startButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.Parent = main

local startCorner = Instance.new("UICorner")
startCorner.CornerRadius = UDim.new(0, 7)
startCorner.Parent = startButton

startButton.MouseButton1Click:Connect(function()
    running = not running
    if running then
        startButton.Text = "⏹ STOP"
        startButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    else
        startButton.Text = "▶ START"
        startButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
    end
end)

-- ====== GAME INTEGRATION ======

-- Safe remote calling with error handling
local function safeRemoteCall(remote, methodName, ...)
    local success, result = pcall(function()
        if methodName == "InvokeServer" then
            return remote:InvokeServer(...)
        elseif methodName == "FireServer" then
            return remote:FireServer(...)
        end
    end)
    
    if not success then
        lastError = "Remote call failed: " .. tostring(result)
        warn("[EggHatcher] " .. lastError)
        return nil
    end
    
    return result
end

-- Place an egg in the game
local function placeEgg(eggName, index)
    if not PLACE_EGG_REMOTE then
        lastError = "PlaceEgg remote not found"
        warn("[EggHatcher] " .. lastError)
        return false
    end
    
    -- Try InvokeServer first (RemoteFunction), fall back to FireServer (RemoteEvent)
    local result = safeRemoteCall(PLACE_EGG_REMOTE, "InvokeServer", eggName, index, positionMode)
    if not result then
        safeRemoteCall(PLACE_EGG_REMOTE, "FireServer", eggName, index, positionMode)
    end
    
    print("[EggHatcher] Placed:", eggName, "| Index:", index, "| Position:", positionMode)
    return true
end

-- Hatch an egg in the game
local function hatchEgg(eggName)
    if not HATCH_EGG_REMOTE then
        lastError = "HatchEgg remote not found"
        warn("[EggHatcher] " .. lastError)
        return false
    end
    
    local result = safeRemoteCall(HATCH_EGG_REMOTE, "InvokeServer", eggName)
    if not result then
        safeRemoteCall(HATCH_EGG_REMOTE, "FireServer", eggName)
    end
    
    print("[EggHatcher] Hatched:", eggName)
    return true
end

-- ====== AUTOMATION LOOP ======
task.spawn(function()
    while task.wait(0.1) do
        if running then
            if autoPlace then
                local amount = math.clamp(tonumber(countInput.Text) or 1, 1, 13)
                
                for i = 1, amount do
                    if not running then break end
                    
                    placeEgg(selectedEgg, i)
                    task.wait(tonumber(placeInput.Text) or 1)
                end
            end
            
            if running and autoHatch then
                hatchEgg(selectedEgg)
                task.wait(tonumber(hatchInput.Text) or 1)
            end
        end
    end
end)

-- ====== KEYBOARD SHORTCUT ======
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Press P to toggle automation
    if input.KeyCode == Enum.KeyCode.P then
        running = not running
        if running then
            startButton.Text = "⏹ STOP"
            startButton.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
            print("[EggHatcher] Started automation (Press P to stop)")
        else
            startButton.Text = "▶ START"
            startButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)
            print("[EggHatcher] Stopped automation")
        end
    end
end)

print("Egg Hatcher loaded. Press P to toggle automation, or click START button.")
