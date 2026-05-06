--[[
    Windows Terminal Theme Builder
    Interactive theme builder for Windows Terminal
]]

local ThemeBuilder = {}
ThemeBuilder.__index = ThemeBuilder

-- ANSI Color names and defaults
local ANSI_COLORS = {
    "black",
    "red",
    "green",
    "yellow",
    "blue",
    "purple",
    "cyan",
    "white",
    "brightBlack",
    "brightRed",
    "brightGreen",
    "brightYellow",
    "brightBlue",
    "brightPurple",
    "brightCyan",
    "brightWhite"
}

local SPECIAL_COLORS = {
    "background",
    "foreground",
    "cursorColor",
    "selectionBackground"
}

-- Default color values
local DEFAULT_COLORS = {
    black = "#000000",
    red = "#FF0000",
    green = "#00FF00",
    yellow = "#FFFF00",
    blue = "#0000FF",
    purple = "#FF00FF",
    cyan = "#00FFFF",
    white = "#FFFFFF",
    brightBlack = "#555555",
    brightRed = "#FF5555",
    brightGreen = "#55FF55",
    brightYellow = "#FFFF55",
    brightBlue = "#5555FF",
    brightPurple = "#FF55FF",
    brightCyan = "#55FFFF",
    brightWhite = "#FFFFFF",
    background = "#000000",
    foreground = "#FFFFFF",
    cursorColor = "#FFFFFF",
    selectionBackground = "#FFFFFF"
}

--[[
    Create new theme builder instance
]]
function ThemeBuilder.new(themeName)
    local self = setmetatable({}, ThemeBuilder)
    self.name = themeName or "Custom Theme"
    self.colors = {}
    
    -- Initialize with defaults
    for color, value in pairs(DEFAULT_COLORS) do
        self.colors[color] = value
    end
    
    return self
end

--[[
    Validate hex color format
]]
function ThemeBuilder:validateHexColor(hex)
    if not hex or type(hex) ~= "string" then
        return false
    end
    
    hex = hex:gsub("^#", "")
    return hex:match("^[0-9A-Fa-f]{6}$") ~= nil
end

--[[
    Set a color value
]]
function ThemeBuilder:setColor(colorName, hexValue)
    if not self:validateHexColor(hexValue) then
        error("Invalid hex color: " .. tostring(hexValue))
    end
    
    -- Ensure # prefix
    if not hexValue:match("^#") then
        hexValue = "#" .. hexValue
    end
    
    self.colors[colorName] = hexValue
    return self
end

--[[
    Get a color value
]]
function ThemeBuilder:getColor(colorName)
    return self.colors[colorName] or DEFAULT_COLORS[colorName]
end

--[[
    Set background color
]]
function ThemeBuilder:setBackground(hexValue)
    return self:setColor("background", hexValue)
end

--[[
    Set foreground color
]]
function ThemeBuilder:setForeground(hexValue)
    return self:setColor("foreground", hexValue)
end

--[[
    Set cursor color
]]
function ThemeBuilder:setCursorColor(hexValue)
    return self:setColor("cursorColor", hexValue)
end

--[[
    Set selection background
]]
function ThemeBuilder:setSelectionBackground(hexValue)
    return self:setColor("selectionBackground", hexValue)
end

--[[
    Generate random theme
]]
function ThemeBuilder:generateRandom()
    local function randomHex()
        return string.format("#%06X", math.random(0, 16777215))
    end
    
    for _, color in ipairs(ANSI_COLORS) do
        self.colors[color] = randomHex()
    end
    
    return self
end

--[[
    Create monochromatic theme
]]
function ThemeBuilder:createMonochromatic(baseHex, darkness)
    darkness = darkness or 0.5
    
    if not self:validateHexColor(baseHex) then
        error("Invalid base hex color: " .. tostring(baseHex))
    end
    
    baseHex = baseHex:gsub("^#", "")
    
    local function lighten(hex, factor)
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        
        r = math.min(255, math.floor(r + (255 - r) * factor))
        g = math.min(255, math.floor(g + (255 - g) * factor))
        b = math.min(255, math.floor(b + (255 - b) * factor))
        
        return string.format("#%02X%02X%02X", r, g, b)
    end
    
    local function darken(hex, factor)
        local r = tonumber(hex:sub(1, 2), 16)
        local g = tonumber(hex:sub(3, 4), 16)
        local b = tonumber(hex:sub(5, 6), 16)
        
        r = math.floor(r * (1 - factor))
        g = math.floor(g * (1 - factor))
        b = math.floor(b * (1 - factor))
        
        return string.format("#%02X%02X%02X", r, g, b)
    end
    
    self.colors.background = darken(baseHex, darkness)
    self.colors.foreground = lighten(baseHex, 0.7)
    self.colors.cursorColor = lighten(baseHex, 0.8)
    
    return self
end

--[[
    Convert to JSON for Windows Terminal
]]
function ThemeBuilder:toJSON()
    local colors = {}
    
    -- Add all colors
    for _, colorName in ipairs(ANSI_COLORS) do
        colors[colorName] = self.colors[colorName]
    end
    
    for _, colorName in ipairs(SPECIAL_COLORS) do
        colors[colorName] = self.colors[colorName]
    end
    
    local scheme = {
        name = self.name,
    }
    
    -- Merge colors into scheme
    for k, v in pairs(colors) do
        scheme[k] = v
    end
    
    -- Manual JSON generation (no external libraries)
    local function valueToJSON(value)
        if type(value) == "string" then
            return '"' .. value:gsub('"', '\\"') .. '"'
        elseif type(value) == "number" then
            return tostring(value)
        else
            return "null"
        end
    end
    
    local jsonLines = {"{"}
    local first = true
    
    for k, v in pairs(scheme) do
        if not first then
            table.insert(jsonLines, ",")
        end
        first = false
        table.insert(jsonLines, '    "' .. k .. '": ' .. valueToJSON(v))
    end
    
    table.insert(jsonLines, "\n}")
    
    return table.concat(jsonLines, "\n")
end

--[[
    Export to file
]]
function ThemeBuilder:exportToFile(filepath)
    local file = io.open(filepath, "w")
    if not file then
        error("Cannot open file: " .. filepath)
    end
    
    file:write(self:toJSON())
    file:close()
    
    return filepath
end

--[[
    Import from JSON
]]
function ThemeBuilder.fromJSON(jsonString)
    -- Simple JSON parser for color schemes
    local theme = ThemeBuilder.new("Imported Theme")
    
    -- Extract color values using patterns
    for color in pairs(DEFAULT_COLORS) do
        local pattern = '"' .. color .. '"%s*:%s*"([^"]+)"'
        local match = jsonString:match(pattern)
        if match then
            theme.colors[color] = match
        end
    end
    
    -- Extract name
    local nameMatch = jsonString:match('"name"%s*:%s*"([^"]+)"')
    if nameMatch then
        theme.name = nameMatch
    end
    
    return theme
end

--[[
    Get contrast ratio for accessibility
]]
function ThemeBuilder:getContrastRatio(color1, color2)
    local function getLuminance(hex)
        hex = hex:gsub("^#", "")
        local r = tonumber(hex:sub(1, 2), 16) / 255
        local g = tonumber(hex:sub(3, 4), 16) / 255
        local b = tonumber(hex:sub(5, 6), 16) / 255
        
        -- Apply gamma correction
        local function adjust(val)
            if val <= 0.03928 then
                return val / 12.92
            else
                return math.pow((val + 0.055) / 1.055, 2.4)
            end
        end
        
        r = adjust(r)
        g = adjust(g)
        b = adjust(b)
        
        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    end
    
    local lum1 = getLuminance(color1)
    local lum2 = getLuminance(color2)
    
    local lighter = math.max(lum1, lum2)
    local darker = math.min(lum1, lum2)
    
    return (lighter + 0.05) / (darker + 0.05)
end

--[[
    Check accessibility (WCAG AA standard)
]]
function ThemeBuilder:checkAccessibility()
    local ratio = self:getContrastRatio(self.colors.foreground, self.colors.background)
    
    if ratio >= 7 then
        return "AAA", ratio
    elseif ratio >= 4.5 then
        return "AA", ratio
    else
        return "FAIL", ratio
    end
end

--[[
    Get theme preview
]]
function ThemeBuilder:getPreview()
    local preview = {
        name = self.name,
        background = self.colors.background,
        foreground = self.colors.foreground,
        accent = self.colors.red,
        contrast = self:checkAccessibility(),
    }
    
    return preview
end

return ThemeBuilder
