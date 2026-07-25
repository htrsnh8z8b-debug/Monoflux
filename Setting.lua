-- Setting.lua
local Settings = {}

local function GetValue(Option)
    if Option.Type == 'Toggle' or Option.Type == 'KeyPicker' then
        return Option.Value
    elseif Option.Type == 'Slider' then
        return Option.Value
    elseif Option.Type == 'Dropdown' then
        if Option.Multi then
            local t = {}
            for k, v in pairs(Option.Value) do
                if v then table.insert(t, k) end
            end
            return t
        else
            return Option.Value
        end
    elseif Option.Type == 'ColorPicker' then
        return { Option.Value.R, Option.Value.G, Option.Value.B, Option.Transparency }
    elseif Option.Type == 'Input' then
        return Option.Value
    else
        return nil -- игнорируем всё остальное (Divider, Row, Button, DependencyBox)
    end
end

local function SetValue(Option, Value)
    if Option.Type == 'Toggle' then
        Option:SetValue(Value)
    elseif Option.Type == 'Slider' then
        Option:SetValue(Value)
    elseif Option.Type == 'Dropdown' then
        Option:SetValue(Value)
    elseif Option.Type == 'KeyPicker' then
        if type(Value) == 'table' then
            Option:SetValue(Value)
        else
            Option.Value = Value
            Option:Update()
        end
    elseif Option.Type == 'ColorPicker' then
        if type(Value) == 'table' and #Value >= 3 then
            Option:SetValueRGB(Color3.new(Value[1], Value[2], Value[3]), Value[4] or 0)
        end
    elseif Option.Type == 'Input' then
        Option:SetValue(Value)
    end
end

function Settings:Save()
    local Data = {}
    for Idx, Option in pairs(getgenv().Options or {}) do
        local val = GetValue(Option)
        if val ~= nil then
            Data[Idx] = val
        end
    end
    getgenv().SavedConfig = Data
    return Data
end

function Settings:Load(Data)
    if not Data then
        Data = getgenv().SavedConfig or {}
    end
    for Idx, Value in pairs(Data) do
        local Option = getgenv().Options[Idx]
        if Option then
            SetValue(Option, Value)
        end
    end
end

function Settings:SetLibrary(lib)
    self.Library = lib
end

function Settings:SetFolder(folder)
    self.Folder = folder
end

function Settings:SetIgnoreIndexes(list)
    self.IgnoreIndexes = list or {}
end

function Settings:BuildConfigSection(tab)
    local group = tab:AddLeftGroupbox('Config')
    group:AddButton('Save Config', function()
        self:Save()
        if self.Library then
            self.Library:Notify('Config saved!', 2)
        end
    end)
    group:AddButton('Load Config', function()
        self:Load()
        if self.Library then
            self.Library:Notify('Config loaded!', 2)
        end
    end)
    group:AddButton('Reset Config', function()
        getgenv().SavedConfig = nil
        if self.Library then
            self.Library:Notify('Config reset!', 2)
        end
    end)
end

function Settings:IgnoreThemeSettings()
    -- пустая заглушка
end

return Settings
