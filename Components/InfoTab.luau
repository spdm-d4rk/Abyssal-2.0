return function(Window)
    local LatestChangelog = {
        "04/5/2026",
        "[ DOORS ]",
		"<font color='rgb(0, 255, 0)'>+ Added Guess Library Code</font>",
		"<font color='rgb(0, 255, 0)'>+ Renamed 'Rooms Auto-Walk' to 'Auto Rooms'</font>",
        "<font color='rgb(0, 255, 0)'>+ Added Ignore A-60 (Auto Rooms)</font>",
		"<font color='rgb(0, 255, 0)'>+ Fixed Several Removal Toggles (Screech, A-90 etc)</font>",
		"<font color='rgb(0, 255, 0)'>+ Fixed Speed Bypass Removing Footstep Sounds</font>",
		"<font color='rgb(0, 255, 0)'>+ Other Small Changes</font>",
		"<font color='rgb(255, 0, 0)'>- Removed Keep On Teleport (too buggy)</font>",
    }

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

    local Library = Abysall.Interface.Library
    local SaveManager = Abysall.Interface.SaveManager
    local ThemeManager = Abysall.Interface.ThemeManager

    local Toggles = Library.Toggles
    local Options = Library.Options

    local LocalPlayer = Services.Players.LocalPlayer
    local InfoTab = Window:AddTab("Info", "user")

    local User = InfoTab:AddLeftGroupbox("User Info")

    local ImageSize = Enum.ThumbnailSize.Size420x420
    local ImageType = Enum.ThumbnailType.HeadShot

    local Content = Services.Players:GetUserThumbnailAsync(LocalPlayer.UserId, ImageType, ImageSize)

    User:AddImage("UserIcon", {
        Image = Content
    })

    User:AddLabel("ID: " .. Abysall.ClientID, true)
    User:AddLabel("Total Executions: " .. (Abysall.TotalExecutions and Abysall.TotalExecutions or "N/A"), true)

    local Changelog = InfoTab:AddRightGroupbox("Changelog")
    for Index, Change in pairs(LatestChangelog) do
        Changelog:AddLabel(Change, true)
    end

    local Name, Version = Abysall.Environment.identifyexecutor()
    local Executor = InfoTab:AddRightGroupbox("Executor Info")
    Executor:AddLabel("Name: " .. Name, true)
    Executor:AddLabel("Version: " .. (Version and Version or "N/A"), true)
    Executor:AddDivider()
    Executor:AddLabel("Test Result: ", true)

    for Index, Result in pairs(Abysall.Environment.Results) do
		-- fix for veloshitty 💔
		Result = Result:gsub("<", "(")
		Result = Result:gsub(">", ")")
		
        Executor:AddLabel(Result, true)
    end

    local Community = InfoTab:AddLeftGroupbox("Community")
    Community:AddButton("Copy Discord Invite", function()
	    toclipboard("https://discord.gg/5jwbZcqjVF")
	    Library:Notify("Discord invite copied.")
    end)
end
