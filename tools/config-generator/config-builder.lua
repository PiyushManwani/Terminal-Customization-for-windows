--[[
    Windows Terminal Configuration Builder
    Build complete terminal configurations programmatically
]]

local ConfigBuilder = {}
ConfigBuilder.__index = ConfigBuilder

--[[
    Create new config builder
]]
function ConfigBuilder.new()
    local self = setmetatable({}, ConfigBuilder)
    self.profiles = {}
    self.schemes = {}
    self.keybindings = {}
    self.defaultProfile = nil
    self.schema = "https://aka.ms/terminal-profiles-schema"
    
    return self
end

--[[
    Add a profile
]]
function ConfigBuilder:addProfile(profile)
    if not profile.guid then
        error("Profile must have a guid")
    end
    
    table.insert(self.profiles, profile)
    return self
end

--[[
    Create PowerShell profile
]]
function ConfigBuilder:addPowerShellProfile(options)
    options = options or {}
    
    local profile = {
        commandline = "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
        guid = options.guid or "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
        name = options.name or "Windows PowerShell",
        tabTitle = options.tabTitle or "PowerShell",
        startingDirectory = options.startingDirectory or "%USERPROFILE%",
        colorScheme = options.colorScheme,
        font = options.font or {
            face = "JetBrainsMono Nerd Font Propo",
            size = 12
        },
        padding = options.padding or "14, 14, 14, 14",
        opacity = options.opacity or 85,
        useAcrylic = options.useAcrylic ~= false,
        cursorShape = options.cursorShape or "bar",
        hidden = false
    }
    
    return self:addProfile(profile)
end

--[[
    Create CMD profile
]]
function ConfigBuilder:addCMDProfile(options)
    options = options or {}
    
    local profile = {
        commandline = "%SystemRoot%\\System32\\cmd.exe",
        guid = options.guid or "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
        name = options.name or "Command Prompt",
        tabTitle = options.tabTitle or "CMD",
        startingDirectory = options.startingDirectory or "%USERPROFILE%",
        colorScheme = options.colorScheme,
        font = options.font or {
            face = "JetBrainsMono Nerd Font Propo",
            size = 12
        },
        padding = options.padding or "14, 14, 14, 14",
        opacity = options.opacity or 85,
        useAcrylic = options.useAcrylic ~= false,
        hidden = false
    }
    
    return self:addProfile(profile)
end

--[[
    Add color scheme
]]
function ConfigBuilder:addScheme(scheme)
    if not scheme.name then
        error("Scheme must have a name")
    end
    
    table.insert(self.schemes, scheme)
    return self
end

--[[
    Add keybinding
]]
function ConfigBuilder:addKeybinding(keybinding)
    if not keybinding.command or not keybinding.keys then
        error("Keybinding must have command and keys")
    end
    
    table.insert(self.keybindings, keybinding)
    return self
end

--[[
    Add default keybindings
]]
function ConfigBuilder:addDefaultKeybindings()
    self:addKeybinding({ command = "copy", keys = "ctrl+c" })
    self:addKeybinding({ command = "paste", keys = "ctrl+v" })
    self:addKeybinding({ command = "newTab", keys = "ctrl+shift+t" })
    self:addKeybinding({ command = "closeTab", keys = "ctrl+shift+w" })
    self:addKeybinding({ command = "splitPane", keys = "alt+shift+d" })
    self:addKeybinding({ command = "nextTab", keys = "ctrl+tab" })
    self:addKeybinding({ command = "previousTab", keys = "ctrl+shift+tab" })
    
    return self
end

--[[
    Convert to Lua table (for in-memory representation)
]]
function ConfigBuilder:toTable()
    return {
        ["$schema"] = self.schema,
        defaultProfile = self.defaultProfile,
        profiles = {
            defaults = {},
            list = self.profiles
        },
        schemes = self.schemes,
        keybindings = self.keybindings
    }
end

--[[
    Convert to JSON string
]]
function ConfigBuilder:toJSON()
    local function escapeString(str)
        str = tostring(str)
        str = str:gsub("\\", "\\\\")
        str = str:gsub('"', '\\"')
        str = str:gsub("\n", "\\n")
        str = str:gsub("\r", "\\r")
        str = str:gsub("\t", "\\t")
        return str
    end
    
    local function valueToJSON(value, indent)
        indent = indent or 0
        local indentStr = string.rep("  ", indent)
        local nextIndent = string.rep("  ", indent + 1)
        
        if type(value) == "string" then
            return '"' .. escapeString(value) .. '"'
        elseif type(value) == "number" then
            return tostring(value)
        elseif type(value) == "boolean" then
            return value and "true" or "false"
        elseif type(value) == "table" then
            -- Check if array or object
            local isArray = #value > 0
            
            if isArray then
                if #value == 0 then return "[]" end
                local items = {}
                for i, v in ipairs(value) do
                    table.insert(items, nextIndent .. valueToJSON(v, indent + 1))
                end
                return "[\n" .. table.concat(items, ",\n") .. "\n" .. indentStr .. "]"
            else
                if not next(value) then return "{}" end
                local items = {}
                for k, v in pairs(value) do
                    table.insert(items, nextIndent .. '"' .. escapeString(k) .. '": ' .. valueToJSON(v, indent + 1))
                end
                return "{\n" .. table.concat(items, ",\n") .. "\n" .. indentStr .. "}"
            end
        else
            return "null"
        end
    end
    
    return valueToJSON(self:toTable())
end

--[[
    Save to file
]]
function ConfigBuilder:save(filepath)
    local file = io.open(filepath, "w")
    if not file then
        error("Cannot open file: " .. filepath)
    end
    
    file:write(self:toJSON())
    file:close()
    
    return filepath
end

return ConfigBuilder
