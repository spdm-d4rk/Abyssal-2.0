local LoadStart = tick()
Abysall.SavePath = "Doors/Lobby"

local Library = Abysall.Interface.Library
local SaveManager = Abysall.Interface.SaveManager
local ThemeManager = Abysall.Interface.ThemeManager

local Toggles = Library.Toggles
local Options = Library.Options

local function CloneReference(Object)
    if Abysall and Abysall.Environment.cloneref then
        return Abysall.Environment.cloneref(Object)
    else
        return Object
    end
end

local Services = setmetatable({}, {
    __index = function(self, Name)
        return CloneReference(game:GetService(Name))
    end
})

local Groupboxes = {}
local Globals = {}
local Connections = {}
local Functions = {}

local LocalPlayer = Services.Players.LocalPlayer
local RemotesFolder = Services.ReplicatedStorage:WaitForChild("RemotesFolder")

while not LocalPlayer.Character do
    task.wait()
end
task.wait(1)

local Window = Library:CreateWindow({
    Title = "Abysall Hub",
    Footer = "Abysall Hub - discord.gg/5jwbZcqjVF",
    NotifySide = "Right",
    ShowCustomCursor = false,
    AutoShow = true,
    Center = true,
        TabPadding = 3,
        MenuFadeTime = 0,
    CornerRadius = 2,
})

Abysall.Interface.ApplyInfoTab(Window)
local Tabs = {
    General = Window:AddTab("General", "house"),
    Addons  = Window:AddTab("Addons", "package"),
}

Functions.CheckCompatability = function(Array)
    local Valid = true
    for Index, Name in pairs(Array) do
        if not Abysall.Environment[Name] then
            Valid = false
        end
    end
    return Valid
end

local function GetHiddenContainer()
        if Functions.CheckCompatability({"gethui"}) then
                return Abysall.Environment.gethui()
        else
                return Services.CoreGui
        end
end

local NotificationLibrary = {
        LiveNotifications = 0,
    Notifications = 1
}

local Container = Instance.new("ScreenGui")
Container.Name = Abysall.ESPLibrary:GenerateRandomString()
Container.Parent = GetHiddenContainer()
Container.DisplayOrder = 32767
Container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not Library.Scheme then
    Library.Scheme = setmetatable({}, {
        __index = function(self, Name)
            return Library[Name]
        end
    })
end

function NotificationLibrary:Notify(TitleText, Desc, Delay)
        task.spawn(function()
                local Notification = Instance.new("Frame")
                local Line = Instance.new("Frame")
                local Warning = Instance.new("ImageLabel")
                local UICorner = Instance.new("UICorner")
        local UICorner2 = Instance.new("UICorner")
                local Title = Instance.new("TextLabel")
                local Description = Instance.new("TextLabel")

                Notification.Name = "Notification"
                Notification.Parent = Container
                Notification.BackgroundColor3 = Library.Scheme.BackgroundColor
                Notification.BackgroundTransparency = 0.4
                Notification.BorderSizePixel = 0
                Notification.Position = UDim2.new(1, 5, 0, 60 + (60 * NotificationLibrary.LiveNotifications))
                Notification.Size = UDim2.new(0, 420, 0, 50)
        Notification:SetAttribute("ID", NotificationLibrary.Notifications)
        Notification:SetAttribute("CurrentPosition", Notification.Position)

                Line.Name = "Line"
                Line.Parent = Notification
                Line.BackgroundColor3 = Library.Scheme.AccentColor
                Line.BorderSizePixel = 0
                Line.Position = UDim2.new(0, 0, 1, -3)
                Line.Size = UDim2.new(0, 0, 0, 3)

                Warning.Name = "Warning"
                Warning.Parent = Notification
                Warning.BackgroundTransparency = 1
                Warning.Position = UDim2.new(0, 10, 0, 5)
                Warning.Size = UDim2.new(0, 40, 0, 40)
                Warning.Image = "rbxassetid://3944668821"
                Warning.ImageColor3 = Library.Scheme.AccentColor
                Warning.ScaleType = Enum.ScaleType.Fit

                UICorner.CornerRadius = UDim.new(0, 20)
                UICorner.Parent = Warning

        UICorner2.CornerRadius = UDim.new(0, 4)
        UICorner2.Parent = Notification

                Title.Name = "Title"
                Title.Parent = Notification
                Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Title.BackgroundTransparency = 1.000
                Title.Position = UDim2.new(0, 60, 0.155, 0)
                Title.Size = UDim2.new(0, 205, 0, 15)
                Title.Text = TitleText or "..."
                Title.TextColor3 = Library.Scheme.FontColor
                Title.TextSize = 10
                Title.TextStrokeTransparency = 0.75
                Title.TextXAlignment = Enum.TextXAlignment.Left

                Description.Name = "Description"
                Description.Parent = Notification
                Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Description.BackgroundTransparency = 1.000
                Description.Position = UDim2.new(0, 60, 0.483, 0)
                Description.Size = UDim2.new(0, 205, 0, 18)
                Description.Text = Desc or "..."
                Description.TextColor3 = Library.Scheme.FontColor
        Description.TextTransparency = 0.1
                Description.TextSize = 10
                Description.TextStrokeTransparency = 0.75
                Description.TextXAlignment = Enum.TextXAlignment.Left
                
                NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications + 1
        NotificationLibrary.Notifications = NotificationLibrary.Notifications + 1
                Services.TweenService:Create(Notification, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -370, 0, Notification.Position.Y.Offset)}):Play()

                task.wait(0.25)
                Services.TweenService:Create(Line, TweenInfo.new(Delay - 0.25, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 400, 0, 3)}):Play()
                task.wait(Delay - 0.25)

        Notification:SetAttribute("Destroying", true)
                Services.TweenService:Create(Notification, TweenInfo.new(0.75, Enum.EasingStyle.Exponential, Enum.EasingDirection.In), {Position = UDim2.new(1, 5, 0, Notification.Position.Y.Offset)}):Play()
                NotificationLibrary.LiveNotifications = NotificationLibrary.LiveNotifications - 1
        
        for Index, Object in pairs(Container:GetChildren()) do
            if Object.Name == "Notification" and Object:GetAttribute("ID") and Object:GetAttribute("ID") > Notification:GetAttribute("ID") and Object:GetAttribute("Destroying") ~= true and Object.Position.Y.Offset ~= 60 then
                Object:SetAttribute("CurrentPosition", UDim2.new(1, -450, 0, Object:GetAttribute("CurrentPosition").Y.Offset - 60))
                Services.TweenService:Create(Object, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut), {Position = UDim2.new(1, -370, 0, Object:GetAttribute("CurrentPosition").Y.Offset)}):Play()
            end
        end
        task.wait(0.75)
                Notification:Destroy()
        end)
end

Functions.Notify = function(Settings)
    local Container
    if Functions.CheckCompatability({"gethui"}) then
        Container = Abysall.Environment.gethui()
    else
        Container = Services.CoreGui
    end

    local Sound = Instance.new("Sound", Container)
    Sound.SoundId = "rbxassetid://8784885431"
    Sound.Volume = 3
    Sound.PlayOnRemove = true
    Sound:Destroy()

    NotificationLibrary:Notify(Settings.Title, Settings.Body, Settings.Time or 5)
end

Library.Notify = function(Data, Body, Time)
    Functions.Notify({Title = Body, Time = Time or 5})
end

Functions.CheckElevators = function()
    local TargetFound = false
        if not Toggles.AutoJoinElevator.Value then
                return
        end
        local TargetCharacter
        if typeof(Options.AutoJoinElevatorTarget.Value) == "Instance" then
                TargetCharacter = Options.AutoJoinElevatorTarget.Value.Character
        elseif typeof(Options.AutoJoinElevatorTarget.Value) == "string" then
                TargetCharacter = Services.Players:FindFirstChild(Options.AutoJoinElevatorTarget.Value).Character
        end

        for Index, Elevator in pairs(Services.Workspace.Lobby.LobbyElevators:GetChildren()) do
                if TargetCharacter and Elevator and TargetCharacter:GetAttribute("InGameElevator") and Elevator:GetAttribute("ID") and Elevator:GetAttribute("ID") == TargetCharacter:GetAttribute("InGameElevator") then
                        TargetFound = true
                        RemotesFolder.ElevatorJoin:FireServer(Elevator)
        end
    end
        if TargetFound == false then
                RemotesFolder.ElevatorExit:FireServer()
        end
end

Globals.RedeemingCodes = false
Globals.CodesList = {
    "67",
        "54",
        "41",
        "CHEDDAR BALLS",
        "XQC",
        "PENGUINZ0",
        "KREEKCRAFT",
        "ISHOWSPEED",
        "DANTDM",
        "KUBZ SCOUTS",
        "FIND THE TROLLFACES",
        "THINKNOODLES",
        "W",
        "RAGDOLL UNIVERSE",
        "RAGDOLL MAYHEM",
        "BIJUU MIKE",
        "8BITRYAN",
        "SCREECHSUCKS",
        "LORE",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
        "FIND THE TROLLFACES",
        "3rd",
        "LAZYDEVS",
        "RAGDOLL COMBAT",
        "VOCAB HAVOC",
        "PATHSWAP",
        "JUMP OVER THE BRICK"
}
Globals.UnlockedBadges = {}

Groupboxes.General_Self = Tabs.General:AddLeftGroupbox("Self")

Groupboxes.General_Self:AddToggle("AutoJoinElevator", {
    Text = "Auto Join Elevator",
    Default = false,
    Tooltip = "Automatically joins the selected player's elevator."
})

Groupboxes.General_Self:AddDropdown("AutoJoinElevatorTarget", {
    Text = "Target",
    SpecialType = "Player",
    ExcludeLocalPlayer = true,
    Searchable = true
})

Groupboxes.General_Automation = Tabs.General:AddLeftGroupbox("Automation")

Groupboxes.General_Automation:AddToggle("CycleAchievements", {
    Text = "Cycle Achievements",
    Default = false,
    Tooltip = "Rapidly equips a random badge."
})

Groupboxes.General_Automation:AddSlider("CycleAchievementsDelay", {
    Text = "Cycle Delay",
    Min = 0,
    Max = 1,
    Default = 0.1,
    Rounding = 2,
    Compact = true
})

Groupboxes.General_Automation:AddDivider()

Groupboxes.General_Automation:AddButton("Redeem All Codes", function()
    if Globals.RedeemingCodes then
        return
    end

    Functions.Notify({Title = "Redeeming " .. #Globals.CodesList .. " codes.", Body = "Please wait."})
    Globals.RedeemingCodes = true
    for Index, Code in pairs(Globals.CodesList) do
        RemotesFolder.ShopCode:FireServer(Code)
        task.wait(5.1)
    end
end)

for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
        if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
                table.insert(Globals.UnlockedBadges, Frame.Name)
        end
end

Connections.BadgeAddedConnection = LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List.ChildAdded:Connect(function(Frame)
        Services.RunService.Heartbeat:Wait()
        if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
                table.insert(Globals.UnlockedBadges, Frame.Name)
        end
end)

Globals.LastBadgeChange = tick()
Globals.LastElevatorCheck = tick()
Connections.MainConnection = Services.RunService.Heartbeat:Connect(function()
        if tick() - Globals.LastElevatorCheck > 0.25 then
        Functions.CheckElevators()
                Globals.LastElevatorCheck = tick()
        end

    if Toggles.CycleAchievements.Value and tick() - Globals.LastBadgeChange > Options.CycleAchievementsDelay.Value then
        local Badge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
        if Badge == PreviousBadge then
            while task.wait() do
                                local NewBadge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
                                if NewBadge ~= PreviousBadge then
                                        Badge = NewBadge
                                        break
                                end
                        end
                end
                for Index, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
                        if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
                                LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Frame.Name).Icons.Star.Visible = false
                        end
                end
                RemotesFolder:WaitForChild("FlexAchievement"):FireServer(Badge)
                PreviousBadge = Badge
                LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Badge).Icons.Star.Visible = true

        Globals.LastBadgeChange = tick()
        end
end)

Groupboxes.General_QuickPlay = Tabs.General:AddRightGroupbox("Quick Play")

Groupboxes.General_QuickPlay:AddButton({
        Text = "The Hotel",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Hotel",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "The Mines",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Mines",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "The Backdoor",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Backdoor",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "The Rooms",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Rooms",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "The Outdoors",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Garden",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddDivider()

Groupboxes.General_QuickPlay:AddButton({
        Text = "Battle Mode",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Party",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "Retro Mode",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Retro",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "Rush Mode",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Fools26",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddDivider()

Groupboxes.General_QuickPlay:AddButton({
        Text = "Halloween",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "Halloween25",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "Hotel-",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "BeforePlus",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "Super Hard Mode",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {},
                Settings = {},
                Destination = "SuperHardMode",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddDivider()

Groupboxes.General_QuickPlay:AddButton({
        Text = "The Rooms [Free, No Progress]",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {
                                "AdminPanel"
                        },
                Settings = {},
                Destination = "Rooms",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Groupboxes.General_QuickPlay:AddButton({
        Text = "The Outdoors [Free, No Progress]",
        DoubleClick = false,
        Func = function()
                RemotesFolder.CreateElevator:FireServer({
                Mods = {
                                "AdminPanel"
                        },
                Settings = {},
                Destination = "Garden",
                FriendsOnly = false,
                MaxPlayers = "1"
        })
        end
})

Library:OnUnload(function()
    Connections.MainConnection:Disconnect()
        getgenv().Abysall = nil
end)

-- ──────────────────────────────────────────────────────────────
-- ADDONS TAB
-- ──────────────────────────────────────────────────────────────
local Addons_Groupboxes = {}

Addons_Groupboxes.Executor = Tabs.Addons:AddLeftGroupbox("Script Executor")

Addons_Groupboxes.Executor:AddLabel("Paste a raw script URL below.")
Addons_Groupboxes.Executor:AddInput("AddonScriptName", {
    Text = "Addon Name",
    Default = "",
    Placeholder = "My Addon",
    Numeric = false,
    Finished = false,
})
Addons_Groupboxes.Executor:AddInput("AddonScriptURL", {
    Text = "Script URL",
    Default = "",
    Placeholder = "https://raw.githubusercontent.com/...",
    Numeric = false,
    Finished = false,
})
Addons_Groupboxes.Executor:AddDivider()
Addons_Groupboxes.Executor:AddButton({
    Text = "Execute from URL",
    DoubleClick = false,
    Func = function()
        local URL = Options.AddonScriptURL.Value
        if URL == "" then
            Functions.Notify({ Title = "Addons", Body = "Enter a script URL first.", Time = 4 })
            return
        end
        local HttpOk, Result = pcall(function() return game:HttpGet(URL) end)
        if not HttpOk or not Result then
            Functions.Notify({ Title = "Addon Error", Body = "Failed to fetch URL.", Time = 5 })
            return
        end
        local Fn, CompileErr = loadstring(Result)
        if not Fn then
            Functions.Notify({ Title = "Addon Error", Body = tostring(CompileErr):sub(1, 80), Time = 8 })
            return
        end
        local RunOk, RunErr = pcall(Fn)
        if not RunOk then
            Functions.Notify({ Title = "Addon Error", Body = tostring(RunErr):sub(1, 80), Time = 8 })
        else
            Functions.Notify({ Title = "Addon Loaded", Body = "Script executed successfully.", Time = 3 })
        end
    end,
})
Addons_Groupboxes.Executor:AddButton({
    Text = "Save Addon",
    DoubleClick = false,
    Func = function()
        local Name = Options.AddonScriptName.Value
        local URL  = Options.AddonScriptURL.Value
        if Name == "" then
            Functions.Notify({ Title = "Addons", Body = "Enter a name for this addon.", Time = 4 })
            return
        end
        if URL == "" then
            Functions.Notify({ Title = "Addons", Body = "Enter a script URL to save.", Time = 4 })
            return
        end
        if not Functions.CheckCompatability({"writefile", "readfile"}) then
            Functions.Notify({ Title = "Addons", Body = "Your executor doesn't support file saving.", Time = 5 })
            return
        end
        local HttpService = game:GetService("HttpService")
        if not pcall(makefolder, "Abysall") then end
        local Existing = {}
        local ReadOk, FileData = pcall(readfile, "Abysall/Addons.json")
        if ReadOk and FileData and FileData ~= "" then
            local ParseOk, Parsed = pcall(function() return HttpService:JSONDecode(FileData) end)
            if ParseOk and type(Parsed) == "table" then Existing = Parsed end
        end
        for _, Entry in pairs(Existing) do
            if Entry.Name == Name then
                Entry.URL = URL
                local EncOk, Enc = pcall(function() return HttpService:JSONEncode(Existing) end)
                if EncOk then writefile("Abysall/Addons.json", Enc) end
                Functions.Notify({ Title = "Addon Updated", Body = "'" .. Name .. "' updated.", Time = 3 })
                return
            end
        end
        table.insert(Existing, { Name = Name, URL = URL })
        local EncOk, Enc = pcall(function() return HttpService:JSONEncode(Existing) end)
        if EncOk then
            writefile("Abysall/Addons.json", Enc)
            Functions.Notify({ Title = "Addon Saved", Body = "'" .. Name .. "' saved.", Time = 3 })
        end
    end,
})

Addons_Groupboxes.Saved = Tabs.Addons:AddRightGroupbox("Saved Addons")

local function RunAddonByURL(AddonName, URL)
    local HttpOk, Result = pcall(function() return game:HttpGet(URL) end)
    if not HttpOk or not Result then
        Functions.Notify({ Title = "Addon Error", Body = "Failed to fetch '" .. AddonName .. "'.", Time = 5 })
        return
    end
    local Fn, CompileErr = loadstring(Result)
    if not Fn then
        Functions.Notify({ Title = "Addon Error", Body = tostring(CompileErr):sub(1, 80), Time = 8 })
        return
    end
    local RunOk, RunErr = pcall(Fn)
    if not RunOk then
        Functions.Notify({ Title = "Addon Error", Body = tostring(RunErr):sub(1, 80), Time = 8 })
    else
        Functions.Notify({ Title = "Addon Loaded", Body = "'" .. AddonName .. "' executed.", Time = 3 })
    end
end

local function LoadSavedAddons()
    if not Functions.CheckCompatability({"readfile"}) then
        Addons_Groupboxes.Saved:AddLabel("File access not supported.")
        return
    end
    local HttpService = game:GetService("HttpService")
    local ReadOk, FileData = pcall(readfile, "Abysall/Addons.json")
    if not ReadOk or not FileData or FileData == "" then
        Addons_Groupboxes.Saved:AddLabel("No saved addons yet.")
        return
    end
    local ParseOk, SavedList = pcall(function() return HttpService:JSONDecode(FileData) end)
    if not ParseOk or type(SavedList) ~= "table" or #SavedList == 0 then
        Addons_Groupboxes.Saved:AddLabel("No saved addons yet.")
        return
    end
    for _, Addon in ipairs(SavedList) do
        local A = Addon
        Addons_Groupboxes.Saved:AddButton({
            Text = A.Name or "Unnamed",
            DoubleClick = false,
            Func = function()
                RunAddonByURL(A.Name or "Unnamed", A.URL or "")
            end,
        })
    end
    Addons_Groupboxes.Saved:AddDivider()
    Addons_Groupboxes.Saved:AddButton({
        Text = "Delete All Addons",
        DoubleClick = true,
        Func = function()
            if Functions.CheckCompatability({"writefile"}) then
                writefile("Abysall/Addons.json", "[]")
                Functions.Notify({ Title = "Addons", Body = "All saved addons deleted. Rejoin to refresh.", Time = 5 })
            end
        end,
    })
end

LoadSavedAddons()
-- ──────────────────────────────────────────────────────────────

Abysall.Interface.ApplySettingsTab(Window)
Functions.Notify({ Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds." , Body = "Press '" .. tostring(Options.MenuKeybind.Value) .. "' to toggle the UI."})
