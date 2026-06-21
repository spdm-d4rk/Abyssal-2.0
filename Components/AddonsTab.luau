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
			Library:Notify("<b>[Addons]</b>\nAddon Error: Cannot read " .. tostring(FilePath):match("([^\\/]+)$"), 5)
			return
		end
		local Fn, Err = loadstring(Content)
		if not Fn then
			Library:Notify("<b>[Addons]</b>\nAddon Error: " .. tostring(Err):sub(1, 80), 5)
			return
		end
		local Ok2, Err2 = pcall(Fn)
		if not Ok2 then
			Library:Notify("<b>[Addons]</b>\nAddon Error: " .. tostring(Err2):sub(1, 80), 5)
		else
			Library:Notify("<b>[Addons]</b>\n" .. tostring(FilePath):match("([^\\/]+)$") .. " executed.", 5)
		end
	end

	-- Helper: fetch and execute a script from a raw URL
	local function RunURL(URL, Label)
		local HttpOk, Content = pcall(function() return game:HttpGet(URL) end)
		if not HttpOk or not Content then
			Library:Notify("<b>[Addons]</b>\nAddon Error: Failed to fetch URL.", 5)
			return
		end
		local Fn, Err = loadstring(Content)
		if not Fn then
			Library:Notify("<b>[Addons]</b>\nAddon Error: " .. tostring(Err):sub(1, 80), 5)
			return
		end
		local Ok2, Err2 = pcall(Fn)
		if not Ok2 then
			Library:Notify("<b>[Addons]</b>\nAddon Error: " .. tostring(Err2):sub(1, 80), 5)
		else
			Library:Notify("<b>[Addons]</b>\n" .. (Label or "Script") .. " executed.", 5)
		end
	end

	local AddonsTab = Window:AddTab("Addons", "package-plus")

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
						WorkspaceGroup:AddButton({
							Text = Name,
							DoubleClick = false,
							Func = function()
								RunFile(FP)
							end,
						})
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
	URLGroup:AddButton({
		Text = "Execute from URL",
		DoubleClick = false,
		Func = function()
			local URL = Options.AddonScriptURL.Value
			if not URL or URL == "" then
				Library:Notify("<b>[Addons]</b>\nEnter a script URL first.", 5)
				return
			end
			local Label = Options.AddonScriptName.Value
			RunURL(URL, Label ~= "" and Label or "Script")
		end,
	})
	URLGroup:AddButton({
		Text = "Save URL to Scripts Folder",
		DoubleClick = false,
		Func = function()
			local Name = Options.AddonScriptName.Value
			local URL  = Options.AddonScriptURL.Value
			if not Name or Name == "" then
				Library:Notify("<b>[Addons]</b>\nEnter a script name first.", 5)
				return
			end
			if not URL or URL == "" then
				Library:Notify("<b>[Addons]</b>\nEnter a script URL first.", 5)
				return
			end
			if not Env.writefile or not Env.makefolder then
				Library:Notify("<b>[Addons]</b>\nYour executor doesn't support file saving.", 5)
				return
			end
			local HttpOk, Content = pcall(function() return game:HttpGet(URL) end)
			if not HttpOk or not Content then
				Library:Notify("<b>[Addons]</b>\nAddon Error: Failed to fetch URL.", 5)
				return
			end
			pcall(Env.makefolder, "Abysall")
			pcall(Env.makefolder, "Abysall/Scripts")
			local FileName = Name:match("%.luau?$") and Name or (Name .. ".lua")
			local WriteOk = pcall(Env.writefile, "Abysall/Scripts/" .. FileName, Content)
			if WriteOk then
				Library:Notify("<b>[Addons]</b>\n" .. FileName .. " saved. Rejoin to see it.", 5)
			else
				Library:Notify("<b>[Addons]</b>\nAddon Error: Failed to write file.", 5)
			end
		end,
	})
end
