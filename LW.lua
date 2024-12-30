local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local Window = Library:NewWindow("Lift Wall Sim")

local MainTab = Window:NewSection("Main")

-- Add Get Power TextBox
MainTab:CreateTextbox("Get Power", function(number)
    local args = {
        [1] = tonumber(number),
        [2] = 1,
        [3] = "Normal"
    }
    game:GetService("ReplicatedStorage").Events.Game.Punch:FireServer(unpack(args))
end)

-- Add Get Wins TextBox
MainTab:CreateTextbox("Get Wins", function(number)
    local args = {
        [1] = "Basic",
        [2] = -tonumber(number),
        [3] = {
            ["Autumn"] = {},
            ["Majestic Heaven"] = {},
            ["Forest"] = {},
            ["Dragon"] = {},
            ["Heavenly"] = {},
            ["Cactus"] = {},
            ["Basic"] = {},
            ["Earth"] = {},
            ["Farm"] = {},
            ["Frozen"] = {}
        }
    }
    game:GetService("ReplicatedStorage").Events.Pets.OpenEgg:FireServer(unpack(args))
    -- Hatch one Robux egg
    local robuxEggArgs = {
        [1] = "Majestic Heaven",
        [2] = 1,
        [3] = {
            ["Autumn"] = {},
            ["Majestic Heaven"] = {},
            ["Forest"] = {},
            ["Dragon"] = {},
            ["Heavenly"] = {},
            ["Cactus"] = {},
            ["Basic"] = {},
            ["Earth"] = {},
            ["Farm"] = {},
            ["Frozen"] = {}
        }
    }
    game:GetService("ReplicatedStorage").Events.Pets.OpenEgg:FireServer(unpack(robuxEggArgs))
end)

-- Add Hatch Robux Egg Toggle
local hatchRobuxEggLoop = false
MainTab:CreateToggle("Hatch Robux Egg", function(state)
    hatchRobuxEggLoop = state
    while hatchRobuxEggLoop do
        local args = {
            [1] = "Majestic Heaven",
            [2] = 1,
            [3] = {
                ["Autumn"] = {},
                ["Majestic Heaven"] = {},
                ["Forest"] = {},
                ["Dragon"] = {},
                ["Heavenly"] = {},
                ["Cactus"] = {},
                ["Basic"] = {},
                ["Earth"] = {},
                ["Farm"] = {},
                ["Frozen"] = {}
            }
        }
        game:GetService("ReplicatedStorage").Events.Pets.OpenEgg:FireServer(unpack(args))
        wait(0.1)  -- Adjust the wait time as needed
    end
end)

-- Add Auto Rebirth Toggle
local autoRebirthLoop = false
MainTab:CreateToggle("Auto Rebirth", function(state)
    autoRebirthLoop = state
    while autoRebirthLoop do
        game:GetService("ReplicatedStorage").Events.Player.Rebirth:FireServer()
        wait(0.1)  -- Adjust the wait time as needed
    end
end)

-- Add YT:Xploiter_RBLX Section
local YTSection = Window:NewSection("YT:Xploiter_RBLX")

-- Apply fonts and styles for better aesthetics
local function applyStyles()
    for _, v in pairs(game.CoreGui:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text == "Lift Wall Sim" then
            v.Font = Enum.Font.Bangers  -- Apply Bangers font to the title
            v.TextSize = 20  -- Make the title font size smaller
        elseif v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
            v.Font = Enum.Font.FredokaOne
        end
    end
end

applyStyles()
