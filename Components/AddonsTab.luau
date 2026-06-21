return function(Window)
	local Library    = Abysall.Interface.Library
	local Toggles    = Library.Toggles
	local Options    = Library.Options

	local Env = Abysall.Environment

	local function CloneReference(Object)
		if Env.cloneref then
			return Env.cloneref(Object)
		end
		return Object
	end

	local Services = setmetatable({}, {
		__index = function(self, Name)
			return CloneReference(game:GetService(Name))
		end
	})

	-- Auto-create Abysall/Scripts/ workspace folder
	if Env.makefolder then
		pcall(Env.makefolder, "Abysall")
		pcall(Env.makefolder, "Abysall/Scripts")
	end

	-- Helper: execute a .lua/.luau file from the Scripts folder
	local function RunFile(FilePath)
		local Ok, Content = pcall(Env.readfile, FilePath)
		if not Ok or not Content or Content == "" then
			Library:Notify("Addon Error: Cannot read " .. tostring(FilePath):match("([^\\/]+)$"))
			return
		end
		local Fn, Err = loadstring(Content)
		if not Fn then
			Library:Notify("Addon Error: " .. tostring(Err):sub(1, 80))
			return
		end
		local Ok2, Err2 = pcall(Fn)
		if not Ok2 then
			Library:Notify("Addon Error: " .. tostring(Err2):sub(1, 80))
		else
			Library:Notify(tostring(FilePath):match("([^\\/]+)$") .. " executed.")
		end
	end

	-- Helper: fetch and execute a script from a raw URL
	local function RunURL(URL, Label)
		local HttpOk, Content = pcall(function() return game:HttpGet(URL) end)
		if not HttpOk or not Content then
			Library:Notify("Addon Error: Failed to fetch URL.")
			return
		end
		local Fn, Err = loadstring(Content)
		if not Fn then
			Library:Notify("Addon Error: " .. tostring(Err):sub(1, 80))
			return
		end
		local Ok2, Err2 = pcall(Fn)
		if not Ok2 then
			Library:Notify("Addon Error: " .. tostring(Err2):sub(1, 80))
		else
			Library:Notify((Label or "Script") .. " executed.")
		end
	end

	local AddonsTab = Window:AddTab("Addons", "code")

	-- LEFT: Script Workspace — auto-lists .lua/.luau files in Abysall/Scripts/
	local WorkspaceGroup = AddonsTab:AddLeftGroupbox("Script Workspace")
	WorkspaceGroup:AddLabel("Folder: Abysall/Scripts/")
	WorkspaceGroup:AddLabel("Place .lua files there, then rejoin.")
	WorkspaceGroup:AddDivider()

	do
		local HasFiles = false
		if Env.listfiles and Env.readfile then
			local ListOk, Files = pcall(Env.listfiles, "Abysall/Scripts")
			if ListOk and Files then
				for _, FilePath in ipairs(Files) do
					local Name = tostring(FilePath):match("([^\\/]+)$") or FilePath
					if Name:match("%.luau?$") then
						HasFiles = true
						local FP = FilePath
						WorkspaceGroup:AddButton(Name, function()
							RunFile(FP)
						end)
					end
				end
			end
		end
		if not HasFiles then
			WorkspaceGroup:AddLabel("No scripts found yet.")
		end
	end

	-- RIGHT: Load from URL
	local URLGroup = AddonsTab:AddRightGroupbox("Load from URL")
	URLGroup:AddLabel("Paste a raw GitHub URL below.")
	URLGroup:AddInput("AddonScriptName", {
		Text = "Script Name",
		Default = "",
		Placeholder = "MyAddon",
		Numeric = false,
		Finished = false,
	})
	URLGroup:AddInput("AddonScriptURL", {
		Text = "Script URL",
		Default = "",
		Placeholder = "https://raw.githubusercontent.com/...",
		Numeric = false,
		Finished = false,
	})
	URLGroup:AddDivider()
	URLGroup:AddButton("Execute from URL", function()
		local URL = Options.AddonScriptURL.Value
		if not URL or URL == "" then
			Library:Notify("Enter a script URL first.")
			return
		end
		local Label = Options.AddonScriptName.Value
		RunURL(URL, Label ~= "" and Label or "Script")
	end)
	URLGroup:AddButton("Save URL to Scripts Folder", function()
		local Name = Options.AddonScriptName.Value
		local URL  = Options.AddonScriptURL.Value
		if not Name or Name == "" then
			Library:Notify("Enter a script name first.")
			return
		end
		if not URL or URL == "" then
			Library:Notify("Enter a script URL first.")
			return
		end
		if not Env.writefile or not Env.makefolder then
			Library:Notify("Your executor doesn't support file saving.")
			return
		end
		local HttpOk, Content = pcall(function() return game:HttpGet(URL) end)
		if not HttpOk or not Content then
			Library:Notify("Addon Error: Failed to fetch URL.")
			return
		end
		pcall(Env.makefolder, "Abysall")
		pcall(Env.makefolder, "Abysall/Scripts")
		local FileName = Name:match("%.luau?$") and Name or (Name .. ".lua")
		local WriteOk = pcall(Env.writefile, "Abysall/Scripts/" .. FileName, Content)
		if WriteOk then
			Library:Notify(FileName .. " saved. Rejoin to see it in workspace.")
		else
			Library:Notify("Addon Error: Failed to write file.")
		end
	end)
end
