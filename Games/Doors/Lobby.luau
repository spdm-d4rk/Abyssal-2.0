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
    General   = Window:AddTab("General", "house"),
    Trolling  = Window:AddTab("Trolling", "zap"),
    Elevators = Window:AddTab("Elevators", "layers"),
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

-- ──────────────────────────────────────────────────────────────
-- GENERAL TAB
-- ──────────────────────────────────────────────────────────────

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
    "67", "54", "41", "CHEDDAR BALLS", "XQC", "PENGUINZ0", "KREEKCRAFT",
    "ISHOWSPEED", "DANTDM", "KUBZ SCOUTS", "FIND THE TROLLFACES",
    "THINKNOODLES", "W", "RAGDOLL UNIVERSE", "RAGDOLL MAYHEM", "BIJUU MIKE",
    "8BITRYAN", "SCREECHSUCKS", "LORE", "ABCDEFGHIJKLMNOPQRSTUVWXYZ",
    "FIND THE TROLLFACES", "3rd", "LAZYDEVS", "RAGDOLL COMBAT",
    "VOCAB HAVOC", "PATHSWAP", "JUMP OVER THE BRICK"
}
Globals.UnlockedBadges = {}

-- Self groupbox (left)
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

-- Automation groupbox (left)
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
    Globals.RedeemingCodes = false
end)

-- Server groupbox (right)
Groupboxes.General_Server = Tabs.General:AddRightGroupbox("Server")

Groupboxes.General_Server:AddButton({
    Text = "Rejoin Server",
    DoubleClick = true,
    Tooltip = "Rejoins your current server.",
    Func = function()
        local PlaceId = game.PlaceId
        local JobId   = game.JobId
        if #Services.Players:GetPlayers() <= 1 then
            LocalPlayer:Kick("Attempting to rejoin the current server...")
            task.wait()
            Services.TeleportService:Teleport(PlaceId, LocalPlayer)
        else
            Functions.Notify({Title = "Server", Body = "Attempting to rejoin the current server..."})
            Services.TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
        end
    end,
})

Groupboxes.General_Server:AddButton({
    Text = "Server Hop",
    DoubleClick = true,
    Tooltip = "Joins a different server.",
    Func = function()
        local PlaceId = game.PlaceId
        local JobId   = game.JobId
        local servers = {}
        local Ok, req = pcall(function()
            return game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
        end)
        if Ok and req then
            local Ok2, body = pcall(Services.HttpService.JSONDecode, Services.HttpService, req)
            if Ok2 and body and body.data then
                for _, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
        end
        if #servers > 0 then
            Services.TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], LocalPlayer)
        else
            Functions.Notify({Title = "Server Hop", Body = "Failed to find a server."})
        end
    end,
})

-- Quick Play groupbox (right)
Groupboxes.General_QuickPlay = Tabs.General:AddRightGroupbox("Quick Play")

Groupboxes.General_QuickPlay:AddButton({
    Text = "The Hotel",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Hotel", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "The Mines",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Mines", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "The Backdoor",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Backdoor", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "The Rooms",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Rooms", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "The Outdoors",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Garden", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddDivider()
Groupboxes.General_QuickPlay:AddButton({
    Text = "Battle Mode",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Party", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "Retro Mode",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Retro", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "Rush Mode",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Fools26", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddDivider()
Groupboxes.General_QuickPlay:AddButton({
    Text = "Halloween",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "Halloween25", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "Hotel-",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "BeforePlus", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "Super Hard Mode",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {}, Settings = {}, Destination = "SuperHardMode", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddDivider()
Groupboxes.General_QuickPlay:AddButton({
    Text = "The Rooms [Free, No Progress]",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {"AdminPanel"}, Settings = {}, Destination = "Rooms", FriendsOnly = false, MaxPlayers = "1" })
    end
})
Groupboxes.General_QuickPlay:AddButton({
    Text = "The Outdoors [Free, No Progress]",
    DoubleClick = false,
    Func = function()
        RemotesFolder.CreateElevator:FireServer({ Mods = {"AdminPanel"}, Settings = {}, Destination = "Garden", FriendsOnly = false, MaxPlayers = "1" })
    end
})

-- Badge cycling – collect already-unlocked badges
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

-- ──────────────────────────────────────────────────────────────
-- TROLLING TAB
-- ──────────────────────────────────────────────────────────────

-- Collect all unanchored parts in the lobby for flinging
Globals.UnanchoredParts = {}
for _, Part in pairs(Services.Workspace.Lobby:GetDescendants()) do
    if Part:IsA("BasePart") and not Part.Anchored then
        table.insert(Globals.UnanchoredParts, Part)
    end
end

Groupboxes.Trolling_Left = Tabs.Trolling:AddLeftGroupbox("Elevator Trolling")

Groupboxes.Trolling_Left:AddToggle("FlingElevatorDoors", {
    Text = "Fling Elevator Doors [FE]",
    Default = false,
    Tooltip = "Flings all unanchored lobby parts. Visible to other players.",
    Disabled = not Functions.CheckCompatability({"isnetworkowner"}),
    DisabledTooltip = "Your executor doesn't support this feature.",
})

Groupboxes.Trolling_Left:AddDivider()
Groupboxes.Trolling_Left:AddLabel("Requires network ownership of parts.")
Groupboxes.Trolling_Left:AddLabel("Works best as lobby host.")

Groupboxes.Trolling_Right = Tabs.Trolling:AddRightGroupbox("Info")
Groupboxes.Trolling_Right:AddLabel("Fling Elevator Doors uses a")
Groupboxes.Trolling_Right:AddLabel("BodyPosition to throw every")
Groupboxes.Trolling_Right:AddLabel("unanchored lobby part in a")
Groupboxes.Trolling_Right:AddLabel("random direction each frame.")

-- ──────────────────────────────────────────────────────────────
-- ELEVATORS TAB  —  Creation + Save Manager
-- ──────────────────────────────────────────────────────────────

local ModifierExclude = {
    "AdminPanel", "CustomSeed", "StreamerMode",
    "BeforePlus", "SuperHardMode", "RetroMode", "Template"
}

local NonMinesModifiers = {
    "Every Angle", "New Roommate", "Locked And Loaded",
    "Key Key Key Key", "Rush Around", "Watch Your Step",
    "Are Those Pancakes?!", "I Love Pancakes!!!"
}

local ModifierList    = {}
local ModifierFileNames = {}
local ModifierFrames  = {}

-- Read modifiers from the lobby CreateElevator UI
for _, Modifier in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers:GetChildren()) do
    if Modifier:IsA("TextButton") and not table.find(ModifierExclude, Modifier.Name) then
        table.insert(ModifierList, Modifier.Text)
        ModifierFileNames[Modifier.Text] = Modifier.Name
        table.insert(ModifierFrames, Modifier)
    end
end

local FloorFileNames = {
    ["The Hotel"]   = "Hotel",
    ["The Mines"]   = "Mines",
    ["The Backdoor"]= "Backdoor",
    ["The Outdoors"]= "Garden",
    ["The Rooms"]   = "Rooms",
    ["Battle Mode"] = "Party",
}

LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.ChildAdded:Connect(function(Child)
    if Child:IsA("TextButton") and not table.find(ModifierExclude, Child.Name) then
        table.insert(ModifierFrames, Child)
        if not table.find(ModifierList, Child.Text) then
            table.insert(ModifierList, Child.Text)
            ModifierFileNames[Child.Text] = Child.Name
        end
    end
end)
LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers.ChildRemoved:Connect(function(Child)
    for i, Modifier in pairs(ModifierFrames) do
        if Modifier == Child then
            table.remove(ModifierFrames, i)
            break
        end
    end
end)

-- Creation groupbox (left)
Groupboxes.Elevators_Creation = Tabs.Elevators:AddLeftGroupbox("Creation")

Groupboxes.Elevators_Creation:AddSlider("ElevatorMaxPlayers", {
    Text = "Max Players",
    Min = 1,
    Max = 50,
    Default = 1,
    Rounding = 0,
})

Groupboxes.Elevators_Creation:AddDropdown("ElevatorModifiers", {
    Text = "Modifiers",
    Values = ModifierList,
    Default = 0,
    AllowNull = true,
    Multi = true,
})

Groupboxes.Elevators_Creation:AddDropdown("ElevatorFloor", {
    Text = "Destination",
    Values = {
        "The Hotel", "The Mines", "The Backdoor", "The Rooms",
        "Retro Mode", "Battle Mode", "SUPER HARD MODE!!!",
        "Hotel-", "The Outdoors"
    },
    Default = 1,
})

Groupboxes.Elevators_Creation:AddToggle("ElevatorFriendsOnly", {
    Text = "Friends Only",
    Default = false,
})

Groupboxes.Elevators_Creation:AddDivider()

Groupboxes.Elevators_Creation:AddButton({
    Text = "Create Elevator",
    DoubleClick = false,
    Tooltip = "Creates an elevator with the selected options.",
    Func = function()
        local NewModifierList = {}
        local Floor = nil

        for _, Modifier in pairs(ModifierList) do
            if Options.ElevatorModifiers.Value[Modifier] then
                table.insert(NewModifierList, ModifierFileNames[Modifier])
            end
        end

        Floor = FloorFileNames[Options.ElevatorFloor.Value] or nil

        if Options.ElevatorFloor.Value == "SUPER HARD MODE!!!" then
            table.insert(NewModifierList, "SuperHardMode")
        end
        if Options.ElevatorFloor.Value == "Hotel-" then
            table.insert(NewModifierList, "BeforePlus")
        end
        if Options.ElevatorFloor.Value == "Retro Mode" then
            table.insert(NewModifierList, "RetroMode")
        end

        -- Validate: floor-only modifier combos
        if Floor == nil and #NewModifierList > 1 then
            Functions.Notify({Title = "Elevator Manager", Body = "The floor '" .. Options.ElevatorFloor.Value .. "' does not support modifiers."})
            return
        end

        -- Mines-only modifiers check
        if Floor == "Mines" then
            local HotelOnly = {}
            for _, Modifier in pairs(ModifierList) do
                if Options.ElevatorModifiers.Value[Modifier] and table.find(NonMinesModifiers, Modifier) then
                    table.insert(HotelOnly, Modifier)
                end
            end
            if #HotelOnly > 0 then
                Functions.Notify({Title = "Elevator Manager", Body = "The following modifiers cannot be used in 'The Mines':\n'" .. table.concat(HotelOnly, "', '") .. "'"})
                return
            end
        end

        if Floor == nil then
            Floor = "Hotel"
        end

        RemotesFolder.CreateElevator:FireServer({
            Mods       = NewModifierList,
            MaxPlayers = tostring(Options.ElevatorMaxPlayers.Value),
            Settings   = {},
            FriendsOnly= Toggles.ElevatorFriendsOnly.Value,
            Destination= Floor
        })
        Functions.Notify({Title = "Elevator Manager", Body = "Elevator created successfully!"})
    end,
})

Groupboxes.Elevators_Creation:AddButton({
    Text = "Import from Game UI",
    DoubleClick = true,
    Tooltip = "Imports current lobby UI settings into the manager.",
    Func = function()
        local SelectedModifiers = {}

        for _, Modifier in pairs(ModifierFrames) do
            if Modifier:FindFirstChild("UIStroke") and Modifier:FindFirstChild("UIStroke").Enabled then
                SelectedModifiers[Modifier.Text] = true
            end
        end

        local Floor = "The Hotel"
        local LobbyFrame = LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Floors
        if LobbyFrame.Mines.Visible    then Floor = "The Mines"    end
        if LobbyFrame.Backdoor.Visible then Floor = "The Backdoor" end
        if LobbyFrame.Party.Visible    then Floor = "Battle Mode"  end
        if LobbyFrame.Garden.Visible   then Floor = "The Outdoors" end
        if LobbyFrame.Hotel.Visible    then
            local SidePanel = LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator.SidePanel.Modifiers
            if SidePanel:FindFirstChild("SuperHardMode") and SidePanel.SuperHardMode.UIStroke.Enabled then
                Floor = "SUPER HARD MODE!!!"
            elseif SidePanel:FindFirstChild("BeforePlus") and SidePanel.BeforePlus.UIStroke.Enabled then
                Floor = "Hotel-"
            elseif SidePanel:FindFirstChild("RetroMode") and SidePanel.RetroMode.UIStroke.Enabled then
                Floor = "Retro Mode"
            end
        end

        Options.ElevatorFloor:SetValue(Floor)
        Options.ElevatorMaxPlayers:SetValue(
            tonumber(LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Settings.MaxPlayers.Toggle.Text)
        )
        Options.ElevatorModifiers:SetValue(SelectedModifiers)
        Toggles.ElevatorFriendsOnly:SetValue(
            LocalPlayer.PlayerGui.MainUI.LobbyFrame.CreateElevator.List.Settings.FriendsOnly:GetAttribute("Setting")
        )

        Functions.Notify({Title = "Elevator Manager", Body = "Imported elevator settings from the lobby UI."})
    end,
})

-- ── Elevator Manager class (save/load/delete to disk) ────────
local HttpService = Services.HttpService

local ElevatorManager = {}
ElevatorManager.Folder = "Abysall/Doors/Elevators"

function ElevatorManager:EnsureFolder()
    if Abysall.Environment.makefolder then
        pcall(Abysall.Environment.makefolder, "Abysall")
        pcall(Abysall.Environment.makefolder, "Abysall/Doors")
        pcall(Abysall.Environment.makefolder, self.Folder)
    end
end

function ElevatorManager:Save(Name, MaxPlayers, Modifiers, Destination, FriendsOnly)
    if Name:gsub(" ", "") == "" then
        return Functions.Notify({Title = "Elevator Manager", Body = "Invalid name: cannot be empty."})
    end
    self:EnsureFolder()
    local data = {MaxPlayers, Modifiers, Destination, FriendsOnly}
    if Abysall.Environment.writefile then
        pcall(Abysall.Environment.writefile, self.Folder .. "/" .. Name .. ".json", HttpService:JSONEncode(data))
        Functions.Notify({Title = "Elevator Manager", Body = 'Saved elevator "' .. Name .. '".'})
    else
        Functions.Notify({Title = "Elevator Manager", Body = "Your executor doesn't support file saving."})
    end
end

function ElevatorManager:Overwrite(Name, MaxPlayers, Modifiers, Destination, FriendsOnly)
    if Name:gsub(" ", "") == "" then
        return Functions.Notify({Title = "Elevator Manager", Body = "No elevator selected."})
    end
    self:EnsureFolder()
    local data = {MaxPlayers, Modifiers, Destination, FriendsOnly}
    if Abysall.Environment.writefile then
        pcall(Abysall.Environment.writefile, self.Folder .. "/" .. Name .. ".json", HttpService:JSONEncode(data))
        Functions.Notify({Title = "Elevator Manager", Body = 'Overwrote elevator "' .. Name .. '".'})
    else
        Functions.Notify({Title = "Elevator Manager", Body = "Your executor doesn't support file saving."})
    end
end

function ElevatorManager:Delete(Name)
    if not Name or Name:gsub(" ", "") == "" then
        return false, "no elevator selected"
    end
    local file = self.Folder .. "/" .. Name .. ".json"
    if Abysall.Environment.isfile and not Abysall.Environment.isfile(file) then
        return false, "file not found"
    end
    if Abysall.Environment.delfile then
        local Ok = pcall(Abysall.Environment.delfile, file)
        if not Ok then
            return false, "delete failed"
        end
        return true
    end
    return false, "executor doesn't support file deletion"
end

function ElevatorManager:List()
    self:EnsureFolder()
    local out = {}
    if Abysall.Environment.listfiles then
        local Ok, files = pcall(Abysall.Environment.listfiles, self.Folder)
        if Ok and files then
            for _, file in ipairs(files) do
                if file:sub(-5) == ".json" then
                    local pos = file:find(".json", 1, true)
                    local start = pos
                    local char = file:sub(pos, pos)
                    while char ~= "/" and char ~= "\\" and char ~= "" and pos > 1 do
                        pos = pos - 1
                        char = file:sub(pos, pos)
                    end
                    if char == "/" or char == "\\" then
                        table.insert(out, file:sub(pos + 1, start - 1))
                    end
                end
            end
        end
    end
    return out
end

function ElevatorManager:Load(Name)
    local path = self.Folder .. "/" .. Name .. ".json"
    if Abysall.Environment.readfile then
        local Ok, data = pcall(Abysall.Environment.readfile, path)
        if not Ok or not data then return nil end
        local Ok2, decoded = pcall(HttpService.JSONDecode, HttpService, data)
        if not Ok2 then return nil end
        return decoded
    end
    return nil
end

function ElevatorManager:Apply(Name)
    local data = self:Load(Name)
    if not data then
        Functions.Notify({Title = "Elevator Manager", Body = 'Failed to load "' .. Name .. '".'})
        return
    end

    Options.ElevatorMaxPlayers:SetValue(data[1])
    Options.ElevatorFloor:SetValue(data[3])

    local SelectedModifiers = {}
    if type(data[2]) == "table" then
        for _, Modifier in pairs(data[2]) do
            SelectedModifiers[Modifier] = true
        end
    end
    Options.ElevatorModifiers:SetValue(SelectedModifiers)
    Toggles.ElevatorFriendsOnly:SetValue(data[4] == true)

    Functions.Notify({Title = "Elevator Manager", Body = 'Loaded elevator "' .. Name .. '".'})
end

ElevatorManager:EnsureFolder()

-- Manager groupbox (right)
Groupboxes.Elevators_Manager = Tabs.Elevators:AddRightGroupbox("Manager")

Groupboxes.Elevators_Manager:AddInput("ElevatorSaveName", {
    Text = "Save Name",
    Default = "",
    Placeholder = "my elevator",
    Numeric = false,
    Finished = false,
})

Groupboxes.Elevators_Manager:AddButton({
    Text = "Save Elevator",
    DoubleClick = false,
    Tooltip = "Saves the current Creation settings to disk.",
    Func = function()
        local Name = Options.ElevatorSaveName.Value
        if not Name or Name:gsub(" ", "") == "" then
            Functions.Notify({Title = "Elevator Manager", Body = "Enter a save name first."})
            return
        end
        local SelectedModifiers = {}
        for _, Modifier in pairs(ModifierList) do
            if Options.ElevatorModifiers.Value[Modifier] then
                table.insert(SelectedModifiers, Modifier)
            end
        end
        ElevatorManager:Save(Name, Options.ElevatorMaxPlayers.Value, SelectedModifiers, Options.ElevatorFloor.Value, Toggles.ElevatorFriendsOnly.Value)
        Options.ElevatorList:SetValues(ElevatorManager:List())
        Options.ElevatorList:SetValue(nil)
    end,
})

Groupboxes.Elevators_Manager:AddDivider()

Groupboxes.Elevators_Manager:AddDropdown("ElevatorList", {
    Text = "Saved Elevators",
    Values = ElevatorManager:List(),
    AllowNull = true,
    Default = 0,
})

Groupboxes.Elevators_Manager:AddButton({
    Text = "Load Elevator",
    DoubleClick = false,
    Tooltip = "Loads the selected save into the Creation settings.",
    Func = function()
        local Name = Options.ElevatorList.Value
        if not Name then
            Functions.Notify({Title = "Elevator Manager", Body = "No elevator selected."})
            return
        end
        ElevatorManager:Apply(Name)
    end,
})

Groupboxes.Elevators_Manager:AddButton({
    Text = "Overwrite Elevator",
    DoubleClick = true,
    Tooltip = "Overwrites the selected save with current Creation settings.",
    Func = function()
        local Name = Options.ElevatorList.Value
        if not Name then
            Functions.Notify({Title = "Elevator Manager", Body = "No elevator selected."})
            return
        end
        local SelectedModifiers = {}
        for _, Modifier in pairs(ModifierList) do
            if Options.ElevatorModifiers.Value[Modifier] then
                table.insert(SelectedModifiers, Modifier)
            end
        end
        ElevatorManager:Overwrite(Name, Options.ElevatorMaxPlayers.Value, SelectedModifiers, Options.ElevatorFloor.Value, Toggles.ElevatorFriendsOnly.Value)
    end,
})

Groupboxes.Elevators_Manager:AddButton({
    Text = "Delete Elevator",
    DoubleClick = true,
    Tooltip = "Permanently deletes the selected save file.",
    Func = function()
        local Name = Options.ElevatorList.Value
        local Ok, Err = ElevatorManager:Delete(Name)
        if not Ok then
            Functions.Notify({Title = "Elevator Manager", Body = "Failed to delete: " .. (Err or "unknown error")})
            return
        end
        Functions.Notify({Title = "Elevator Manager", Body = 'Deleted elevator "' .. Name .. '".'})
        Options.ElevatorList:SetValues(ElevatorManager:List())
        Options.ElevatorList:SetValue(nil)
    end,
})

Groupboxes.Elevators_Manager:AddButton({
    Text = "Refresh List",
    DoubleClick = false,
    Tooltip = "Reloads the list of saved elevators from disk.",
    Func = function()
        Options.ElevatorList:SetValues(ElevatorManager:List())
        Options.ElevatorList:SetValue(nil)
        Functions.Notify({Title = "Elevator Manager", Body = "Refreshed saved elevators list."})
    end,
})

-- ──────────────────────────────────────────────────────────────
-- MAIN HEARTBEAT LOOP
-- ──────────────────────────────────────────────────────────────

Globals.LastBadgeChange   = tick()
Globals.LastElevatorCheck = tick()
Globals.PreviousBadge     = ""

Connections.FlingConnection = Services.RunService.Heartbeat:Connect(function()
    if not Toggles.FlingElevatorDoors.Value then
        -- clean up any lingering BodyPositions
        for _, Part in pairs(Globals.UnanchoredParts) do
            if Part and Part.Parent and Part:FindFirstChild("AbysallFlingBP") then
                Part:FindFirstChild("AbysallFlingBP"):Destroy()
            end
        end
        return
    end
    if not Functions.CheckCompatability({"isnetworkowner"}) then return end
    for _, Part in pairs(Globals.UnanchoredParts) do
        if Part and Part.Parent then
            if Abysall.Environment.isnetworkowner(Part) then
                local BP = Part:FindFirstChild("AbysallFlingBP")
                if not BP then
                    BP = Instance.new("BodyPosition")
                    BP.Name = "AbysallFlingBP"
                    BP.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    BP.Parent = Part
                end
                BP.Position = Vector3.new(math.random(-150, 150), math.random(-150, 150), math.random(-150, 150))
            else
                local BP = Part:FindFirstChild("AbysallFlingBP")
                if BP then BP:Destroy() end
            end
        end
    end
end)

Connections.MainConnection = Services.RunService.Heartbeat:Connect(function()
    -- Elevator Sniper / Auto Join
    if tick() - Globals.LastElevatorCheck > 0.25 then
        Functions.CheckElevators()
        Globals.LastElevatorCheck = tick()
    end

    -- Cycle Achievements
    if Toggles.CycleAchievements.Value and tick() - Globals.LastBadgeChange > Options.CycleAchievementsDelay.Value then
        if #Globals.UnlockedBadges == 0 then return end
        local Badge = Globals.UnlockedBadges[math.random(1, #Globals.UnlockedBadges)]
        if Badge == Globals.PreviousBadge then
            for _, Candidate in pairs(Globals.UnlockedBadges) do
                if Candidate ~= Globals.PreviousBadge then
                    Badge = Candidate
                    break
                end
            end
        end
        for _, Frame in pairs(LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:GetChildren()) do
            if Frame:IsA("ImageButton") and Frame.ImageTransparency == 0 then
                LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Frame.Name).Icons.Star.Visible = false
            end
        end
        RemotesFolder:WaitForChild("FlexAchievement"):FireServer(Badge)
        Globals.PreviousBadge = Badge
        LocalPlayer.PlayerGui.MainUI.LobbyFrame.Achievements.List:FindFirstChild(Badge).Icons.Star.Visible = true
        Globals.LastBadgeChange = tick()
    end
end)

-- ──────────────────────────────────────────────────────────────
-- UNLOAD & FINISH
-- ──────────────────────────────────────────────────────────────

Library:OnUnload(function()
    Connections.MainConnection:Disconnect()
    Connections.FlingConnection:Disconnect()
    Connections.BadgeAddedConnection:Disconnect()

    -- Remove any leftover fling constraints
    for _, Part in pairs(Globals.UnanchoredParts) do
        if Part and Part.Parent and Part:FindFirstChild("AbysallFlingBP") then
            Part:FindFirstChild("AbysallFlingBP"):Destroy()
        end
    end

    getgenv().Abysall = nil
end)

Abysall.Interface.ApplyAddonsTab(Window)
Abysall.Interface.ApplySettingsTab(Window)
Functions.Notify({ Title = "Successfully loaded in " .. math.floor((tick() - LoadStart) * 1000) / 1000 .. " seconds." , Body = "Press '" .. tostring(Options.MenuKeybind.Value) .. "' to toggle the UI."})
