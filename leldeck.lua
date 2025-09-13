--[[
    OLoader
    -> bytecode
]]

if getgenv().Library then
    getgenv().Library:Unload()
end

-- Variables
local InputService, HttpService, GuiService, RunService, Stats, CoreGui, TweenService, SoundService, Workspace, Players, Lighting =
    game:GetService('UserInputService'),
    game:GetService('HttpService'),
    game:GetService('GuiService'),
    game:GetService('RunService'),
    game:GetService('Stats'),
    game:GetService('CoreGui'),
    game:GetService('TweenService'),
    game:GetService('SoundService'),
    game:GetService('Workspace'),
    game:GetService('Players'),
    game:GetService('Lighting')
local Camera, LocalPlayer, gui_offset =
    Workspace.CurrentCamera, Players.LocalPlayer, GuiService:GetGuiInset().Y
local Mouse = LocalPlayer:GetMouse()
local vec2, vec3, dim2, dim, rect, dim_offset =
    Vector2.new, Vector3.new, UDim2.new, UDim.new, Rect.new, UDim2.fromOffset
local color, rgb, hex, hsv, rgbseq, rgbkey, numseq, numkey =
    Color3.new,
    Color3.fromRGB,
    Color3.fromHex,
    Color3.fromHSV,
    ColorSequence.new,
    ColorSequenceKeypoint.new,
    NumberSequence.new,
    NumberSequenceKeypoint.new
local angle, empty_cfr, cfr = CFrame.Angles, CFrame.new(), CFrame.new
--

-- Library init
getgenv().Library = {
    Directory = 'OLoader',
    Folders = {
        '/fonts',
        '/configs',
    },
    Flags = {},
    ConfigFlags = {},
    Connections = {},
    Notifications = { Notifs = {} },
    OpenElement = {}, -- type: table or userdata
    AvailablePanels = {},

    EasingStyle = Enum.EasingStyle.Quint,
    TweeningSpeed = 0.3,
    DraggingSpeed = 0.05,
    Tweening = false,
}

local themes = {
    preset = {
        holders = rgb(24, 25, 34),
        background = rgb(21, 22, 29),
        accent = rgb(92, 138, 255),
        sub_text = rgb(83, 91, 121),
        text_color = rgb(255, 255, 255),
        scroll_bars = rgb(56, 65, 79),
        font = 'Inter',
    },
    utility = {},
    gradients = {
        elements = {},
    },
}

for theme, color in themes.preset do
    if theme == 'font' then
        continue
    end

    themes.utility[theme] = {
        BackgroundColor3 = {},
        TextColor3 = {},
        ImageColor3 = {},
        ScrollBarImageColor3 = {},
        Color = {},
    }
end

local Keys = {
    [Enum.KeyCode.LeftShift] = 'LS',
    [Enum.KeyCode.RightShift] = 'RS',
    [Enum.KeyCode.LeftControl] = 'LC',
    [Enum.KeyCode.RightControl] = 'RC',
    [Enum.KeyCode.Insert] = 'INS',
    [Enum.KeyCode.Backspace] = 'BS',
    [Enum.KeyCode.Return] = 'Ent',
    [Enum.KeyCode.LeftAlt] = 'LA',
    [Enum.KeyCode.RightAlt] = 'RA',
    [Enum.KeyCode.CapsLock] = 'CAPS',
    [Enum.KeyCode.One] = '1',
    [Enum.KeyCode.Two] = '2',
    [Enum.KeyCode.Three] = '3',
    [Enum.KeyCode.Four] = '4',
    [Enum.KeyCode.Five] = '5',
    [Enum.KeyCode.Six] = '6',
    [Enum.KeyCode.Seven] = '7',
    [Enum.KeyCode.Eight] = '8',
    [Enum.KeyCode.Nine] = '9',
    [Enum.KeyCode.Zero] = '0',
    [Enum.KeyCode.KeypadOne] = 'Num1',
    [Enum.KeyCode.KeypadTwo] = 'Num2',
    [Enum.KeyCode.KeypadThree] = 'Num3',
    [Enum.KeyCode.KeypadFour] = 'Num4',
    [Enum.KeyCode.KeypadFive] = 'Num5',
    [Enum.KeyCode.KeypadSix] = 'Num6',
    [Enum.KeyCode.KeypadSeven] = 'Num7',
    [Enum.KeyCode.KeypadEight] = 'Num8',
    [Enum.KeyCode.KeypadNine] = 'Num9',
    [Enum.KeyCode.KeypadZero] = 'Num0',
    [Enum.KeyCode.Minus] = '-',
    [Enum.KeyCode.Equals] = '=',
    [Enum.KeyCode.Tilde] = '~',
    [Enum.KeyCode.LeftBracket] = '[',
    [Enum.KeyCode.RightBracket] = ']',
    [Enum.KeyCode.RightParenthesis] = ')',
    [Enum.KeyCode.LeftParenthesis] = '(',
    [Enum.KeyCode.Semicolon] = ',',
    [Enum.KeyCode.Quote] = "'",
    [Enum.KeyCode.BackSlash] = '\\',
    [Enum.KeyCode.Comma] = ',',
    [Enum.KeyCode.Period] = '.',
    [Enum.KeyCode.Slash] = '/',
    [Enum.KeyCode.Asterisk] = '*',
    [Enum.KeyCode.Plus] = '+',
    [Enum.KeyCode.Period] = '.',
    [Enum.KeyCode.Backquote] = '`',
    [Enum.UserInputType.MouseButton1] = 'MB1',
    [Enum.UserInputType.MouseButton2] = 'MB2',
    [Enum.UserInputType.MouseButton3] = 'MB3',
    [Enum.KeyCode.Escape] = 'ESC',
    [Enum.KeyCode.Space] = 'SPC',
}

Library.__index = Library

for _, path in Library.Folders do
    makefolder(Library.Directory .. path)
end

local Flags = Library.Flags
local ConfigFlags = Library.ConfigFlags
local Notifications = Library.Notifications

local Fonts = {}
Fonts['Inter'] = Font.new(
    'rbxassetid://12187365364',
    Enum.FontWeight.SemiBold,
    Enum.FontStyle.Normal
)
--

-- Library functions
-- Misc functions
function Library:GetTransparency(obj)
    if obj:IsA('Frame') then
        return { 'BackgroundTransparency' }
    elseif obj:IsA('TextLabel') or obj:IsA('TextButton') then
        return { 'TextTransparency', 'BackgroundTransparency' }
    elseif obj:IsA('ImageLabel') or obj:IsA('ImageButton') then
        return { 'BackgroundTransparency', 'ImageTransparency' }
    elseif obj:IsA('ScrollingFrame') then
        return { 'BackgroundTransparency', 'ScrollBarImageTransparency' }
    elseif obj:IsA('TextBox') then
        return { 'TextTransparency', 'BackgroundTransparency' }
    elseif obj:IsA('UIStroke') then
        return { 'Transparency' }
    end

    return nil
end

function Library:Tween(Object, Properties, Info)
    local tween = TweenService:Create(
        Object,
        Info
            or TweenInfo.new(
                Library.TweeningSpeed,
                Library.EasingStyle,
                Enum.EasingDirection.InOut,
                0,
                false,
                0
            ),
        Properties
    )
    tween:Play()

    return tween
end

function Library:Fade(obj, prop, vis, speed)
    if not (obj and prop) then
        return
    end

    local OldTransparency = obj[prop]
    obj[prop] = vis and 1 or OldTransparency

    local Tween = Library:Tween(
        obj,
        { [prop] = vis and OldTransparency or 1 },
        TweenInfo.new(
            speed or Library.TweeningSpeed,
            Library.EasingStyle,
            Enum.EasingDirection.InOut,
            0,
            false,
            0
        )
    )

    Library:Connection(Tween.Completed, function()
        if not vis then
            obj[prop] = OldTransparency
        end
    end)

    return Tween
end

function Library:Resizify(Parent)
    local Resizing = Library:Create('TextButton', {
        Position = dim2(1, -10, 1, -10),
        BorderColor3 = rgb(0, 0, 0),
        Size = dim2(0, 10, 0, 10),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
        Parent = Parent,
        BackgroundTransparency = 1,
        Text = '',
    })

    local IsResizing = false
    local Size
    local InputLost
    local ParentSize = Parent.Size

    Resizing.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsResizing = true
            InputLost = input.Position
            Size = Parent.Size
        end
    end)

    Resizing.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            IsResizing = false
        end
    end)

    Library:Connection(InputService.InputChanged, function(input, game_event)
        if
            IsResizing
            and input.UserInputType == Enum.UserInputType.MouseMovement
        then
            Library:Tween(
                Parent,
                {
                    Size = dim2(
                        Size.X.Scale,
                        math.clamp(
                            Size.X.Offset + (input.Position.X - InputLost.X),
                            ParentSize.X.Offset,
                            Camera.ViewportSize.X
                        ),
                        Size.Y.Scale,
                        math.clamp(
                            Size.Y.Offset + (input.Position.Y - InputLost.Y),
                            ParentSize.Y.Offset,
                            Camera.ViewportSize.Y
                        )
                    ),
                },
                TweenInfo.new(
                    Library.DraggingSpeed,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.InOut,
                    0,
                    false,
                    0
                )
            )
        end
    end)
end

function Library:Hovering(Object)
    if type(Object) == 'table' then
        local Pass = false

        for _, obj in Object do
            if Library:Hovering(obj) then
                Pass = true
                return Pass
            end
        end
    else
        local y_cond = Object.AbsolutePosition.Y <= Mouse.Y
            and Mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
        local x_cond = Object.AbsolutePosition.X <= Mouse.X
            and Mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X

        return (y_cond and x_cond)
    end
end

function Library:ConvertHex(color)
    local r = math.floor(color.R * 255)
    local g = math.floor(color.G * 255)
    local b = math.floor(color.B * 255)
    return string.format('#%02X%02X%02X', r, g, b)
end

function Library:ConvertFromHex(color)
    color = color:gsub('#', '')
    local r = tonumber(color:sub(1, 2), 16) / 255
    local g = tonumber(color:sub(3, 4), 16) / 255
    local b = tonumber(color:sub(5, 6), 16) / 255
    return Color3.new(r, g, b)
end

function Library:Draggify(Parent)
    local Dragging = false
    local IntialSize = Parent.Position
    local InitialPosition

    Parent.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            InitialPosition = Input.Position
            InitialSize = Parent.Position
        end
    end)

    Parent.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end)

    Library:Connection(InputService.InputChanged, function(Input, game_event)
        if
            Dragging
            and Input.UserInputType == Enum.UserInputType.MouseMovement
        then
            local Horizontal = Camera.ViewportSize.X
            local Vertical = Camera.ViewportSize.Y

            local NewPosition = dim2(
                0,
                math.clamp(
                    InitialSize.X.Offset
                        + (Input.Position.X - InitialPosition.X),
                    0,
                    Horizontal - Parent.Size.X.Offset
                ),
                0,
                math.clamp(
                    InitialSize.Y.Offset
                        + (Input.Position.Y - InitialPosition.Y),
                    0,
                    Vertical - Parent.Size.Y.Offset
                )
            )

            Library:Tween(
                Parent,
                {
                    Position = NewPosition,
                },
                TweenInfo.new(
                    Library.DraggingSpeed,
                    Enum.EasingStyle.Linear,
                    Enum.EasingDirection.InOut,
                    0,
                    false,
                    0
                )
            )
        end
    end)
end

function Library:Convert(str)
    local Values = {}

    for Value in string.gmatch(str, '[^,]+') do
        table.insert(Values, tonumber(Value))
    end

    if #Values == 3 then
        return unpack(Values)
    else
        return
    end
end

local ConfigHolder -- List for configs
function Library:UpdateConfigList()
    if not ConfigHolder then
        return
    end

    local List = {}

    for _, file in listfiles(Library.Directory .. '/configs') do
        local Name = file:gsub(Library.Directory .. '/configs\\', '')
            :gsub('.cfg', '')
            :gsub(Library.Directory .. '\\configs\\', '')
        List[#List + 1] = Name
    end

    ConfigHolder.RefreshOptions(List)
end

function Library:Keypicker(properties)
    local Cfg = {
        Name = properties.Name or 'Color',
        Flag = properties.Flag or properties.Name or 'Colorpicker',
        Callback = properties.Callback or function() end,

        Color = properties.Color or color(1, 1, 1), -- Default to white color if not provided
        Alpha = properties.Alpha or properties.Transparency or 0,

        Mode = properties.Mode or 'Keypicker', -- Animation

        -- Other
        Open = false,
        Items = { Dropdown = nil },
        Tweening = false,
    }

    local DraggingSat = false
    local DraggingHue = false
    local DraggingAlpha = false

    local h, s, v = Cfg.Color:ToHSV()
    local a = Cfg.Alpha

    Flags[Cfg.Flag] = { Color = Cfg.Color, Transparency = Cfg.Alpha }

    local Items = Cfg.Items
    do
        -- Component
        Items.Element = Library:Create('TextButton', {
            Parent = self.Items.Elements,
            Name = '\0',
            BackgroundTransparency = 1,
            Size = dim2(1, 0, 0, 18),
            BorderColor3 = rgb(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = themes.preset.text_color,
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Name,
            Parent = Items.Element,
            Name = '\0',
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 16,
        })
        Library:Themify(Items.Title, 'text_color', 'BackgroundColor3')

        Items.ColorpickerObject = Library:Create('TextButton', {
            AnchorPoint = vec2(1, 0),
            Parent = Items.Element,
            Position = dim2(1, 0, 0, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 18, 0, 18),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 0, 0),
        })

        Library:Create('UICorner', {
            Parent = Items.ColorpickerObject,
            CornerRadius = dim(0, 3),
        })
        --

        -- Colorpicker
        Items.Colorpicker = Library:Create('Frame', {
            Parent = Library.Other,
            Name = '\0',
            Position = dim2(0.5, 0, 0.5, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 294, 0, 235),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(21, 22, 29),
        })

        Library:Create('UICorner', {
            Parent = Items.Colorpicker,
            CornerRadius = dim(0, 3),
        })

        Items.Outline = Library:Create('Frame', {
            Parent = Items.Colorpicker,
            Name = '\0',
            Position = dim2(0, 7, 0, 27),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -14, 1, -85),
            BorderSizePixel = 0,
            BackgroundColor3 = hex('#181922'),
        })

        Library:Create('UICorner', {
            Parent = Items.Outline,
            CornerRadius = dim(0, 5),
        })

        Items.SatValHolder = Library:Create('Frame', {
            Parent = Items.Outline,
            Name = '\0',
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(112, 255, 69),
        })

        Items.Val = Library:Create('TextButton', {
            Active = false,
            BorderColor3 = rgb(0, 0, 0),
            Text = '',
            AutoButtonColor = false,
            Name = '\0',
            Parent = Items.SatValHolder,
            Size = dim2(1, 0, 1, 0),
            Selectable = false,
            BorderSizePixel = 0,
        })

        Library:Create('UIGradient', {
            Parent = Items.Val,
            Transparency = numseq({ numkey(0, 0), numkey(1, 1) }),
        })

        Library:Create('UICorner', {
            Parent = Items.Val,
            CornerRadius = dim(0, 5),
        })

        Library:Create('UICorner', {
            Parent = Items.SatValHolder,
            CornerRadius = dim(0, 4),
        })

        Items.Sat = Library:Create('TextButton', {
            Active = false,
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.SatValHolder,
            Name = '\0',
            Size = dim2(1, 0, 1, 0),
            Selectable = false,
            ZIndex = 2,
            BorderSizePixel = 0,
        })
        Library:Themify(Items.Sat, 'text_color', 'BackgroundColor3')

        Library:Create('UIGradient', {
            Rotation = 270,
            Transparency = numseq({ numkey(0, 0), numkey(1, 1) }),
            Parent = Items.Sat,
            Color = rgbseq({ rgbkey(0, rgb(0, 0, 0)), rgbkey(1, rgb(0, 0, 0)) }),
        })

        Library:Create('UICorner', {
            Parent = Items.Sat,
            CornerRadius = dim(0, 4),
        })

        Items.SatValDraggerHolder = Library:Create('Frame', {
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.Outline,
            Name = '\0',
            BackgroundTransparency = 1,
            Position = dim2(0, 4, 0, 4),
            Size = dim2(1, -8, 1, -8),
            ZIndex = 3,
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.text_color,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(
            Items.SatValDraggerHolder,
            'text_color',
            'BackgroundColor3'
        )

        Items.SatValDragger = Library:Create('Frame', {
            AnchorPoint = vec2(0.5, 0.5),
            Parent = Items.SatValDraggerHolder,
            Name = '\0',
            Position = dim2(0.5, 0, 0.5, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 6, 0, 6),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.text_color,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.SatValDragger, 'text_color', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.SatValDragger,
            CornerRadius = dim(1, 0),
        })

        Library:Create('UIStroke', {
            Parent = Items.SatValDragger,
        })

        Items.HueOutline = Library:Create('Frame', {
            AnchorPoint = vec2(0, 1),
            Parent = Items.Colorpicker,
            Name = '\0',
            Position = dim2(0, 7, 1, -36),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -14, 0, 16),
            BorderSizePixel = 0,
            BackgroundColor3 = hex('#181922'),
        })

        Library:Create('UICorner', {
            Parent = Items.HueOutline,
            CornerRadius = dim(0, 5),
        })

        Items.Hue = Library:Create('Frame', {
            Parent = Items.HueOutline,
            Name = '\0',
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
        })
        Library:Themify(Items.Hue, 'text_color', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.Hue,
            CornerRadius = dim(0, 5),
        })

        Library:Create('UIGradient', {
            Color = rgbseq({
                rgbkey(0, rgb(255, 0, 0)),
                rgbkey(0.17, rgb(255, 255, 0)),
                rgbkey(0.33, rgb(0, 255, 0)),
                rgbkey(0.5, rgb(0, 255, 255)),
                rgbkey(0.67, rgb(0, 0, 255)),
                rgbkey(0.83, rgb(255, 0, 255)),
                rgbkey(1, rgb(255, 0, 0)),
            }),
            Parent = Items.Hue,
        })

        Items.HueDraggerHolder = Library:Create('Frame', {
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.Hue,
            Name = '\0',
            BackgroundTransparency = 1,
            Position = dim2(0, 5, 0, 0),
            Size = dim2(1, -8, 1, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
        })
        Library:Themify(
            Items.HueDraggerHolder,
            'text_color',
            'BackgroundColor3'
        )

        Items.HueDragger = Library:Create('Frame', {
            AnchorPoint = vec2(0.5, 0.5),
            Parent = Items.HueDraggerHolder,
            Name = '\0',
            Position = dim2(0.5, 0, 0.5, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 6, 0, 12),
            BorderSizePixel = 0,
        })
        Library:Themify(Items.HueDragger, 'text_color', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.HueDragger,
            CornerRadius = dim(1, 0),
        })

        Library:Create('UIStroke', {
            Parent = Items.HueDragger,
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.Medium,
                Enum.FontStyle.Normal
            ),
            TextColor3 = themes.preset.text_color,
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Name,
            Parent = Items.Colorpicker,
            Name = '\0',
            Position = dim2(0, 7, 0, 5),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 16,
        })
        Library:Themify(Items.Title, 'text_color', 'BackgroundColor3')

        Library:Create('UIListLayout', {
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Items.Title,
        })

        Items.Exit = Library:Create('ImageButton', {
            ImageColor3 = themes.preset.accent,
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.Colorpicker,
            Name = '\0',
            AnchorPoint = vec2(1, 0),
            Image = 'rbxassetid://125918672020988',
            BackgroundTransparency = 1,
            Position = dim2(1, -7, 0, 5),
            Size = dim2(0, 18, 0, 18),
            BorderSizePixel = 0,
        })
        Library:Themify(Items.Exit, 'accent', 'ImageColor3')

        Items.TextBoxOutline = Library:Create('Frame', {
            AnchorPoint = vec2(0, 1),
            Parent = Items.Colorpicker,
            Name = '\0',
            Position = dim2(0, 7, 1, -7),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -14, 0, 22),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.outline,
            BackgroundColor3 = rgb(24, 24, 24),
        })

        Library:Create('UICorner', {
            Parent = Items.TextBoxOutline,
            CornerRadius = dim(0, 5),
        })

        Items.Textbox = Library:Create('Frame', {
            Parent = Items.TextBoxOutline,
            Name = '\0',
            Position = dim2(0, 1, 0, 1),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -2, 1, -2),
            BorderSizePixel = 0,
            BackgroundColor3 = hex('#181922'),
        })

        Library:Create('UICorner', {
            Parent = Items.Textbox,
            CornerRadius = dim(0, 5),
        })

        Items.Textbox = Library:Create('TextBox', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.Regular,
                Enum.FontStyle.Normal
            ),
            Active = false,
            Selectable = false,
            TextSize = 16,
            Size = dim2(1, 0, 1, 0),
            RichText = true,
            TextColor3 = rgb(185, 192, 206),
            BorderColor3 = rgb(0, 0, 0),
            Text = '',
            Parent = Items.Textbox,
            Name = '\0',
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            CursorPosition = -1,
        })

        Library:Create('UIPadding', {
            Parent = Items.Textbox,
            PaddingRight = dim(0, 6),
            PaddingLeft = dim(0, 6),
        })
        --
    end

    function Cfg.SetVisible(bool)
        if Cfg.Tweening == true then
            return
        end

        Items.Colorpicker.Position = dim2(
            0,
            Items.ColorpickerObject.AbsolutePosition.X,
            0,
            Items.ColorpickerObject.AbsolutePosition.Y + 79
        )
        Items.Colorpicker.Parent = bool and Library.Items or Library.Other

        Cfg.Tween(bool)
        Cfg.Set(hsv(h, s, v), a)
    end

    function Cfg.Tween(bool)
        if Cfg.Tweening == true then
            return
        end

        Cfg.Tweening = true

        if bool then
            Items.Colorpicker.Visible = true
            Items.Colorpicker.Parent = Library.Items
        end

        local Children = Items.Colorpicker:GetDescendants()
        table.insert(Children, Items.Colorpicker)

        local Tween
        for _, obj in Children do
            local Index = Library:GetTransparency(obj)

            if not Index then
                continue
            end

            if type(Index) == 'table' then
                for _, prop in Index do
                    Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                end
            else
                Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
            end
        end

        Library:Connection(Tween.Completed, function()
            Cfg.Tweening = false
            Items.Colorpicker.Visible = bool
        end)
    end

    function Cfg.UpdateColor()
        local Mouse = InputService:GetMouseLocation()
        local offset = vec2(Mouse.X, Mouse.Y - gui_offset)

        if DraggingSat then
            s = math.clamp(
                (offset - Items.SatValHolder.AbsolutePosition).X
                    / Items.SatValHolder.AbsoluteSize.X,
                0,
                1
            )
            v = 1
                - math.clamp(
                    (offset - Items.SatValHolder.AbsolutePosition).Y
                        / Items.SatValHolder.AbsoluteSize.Y,
                    0,
                    1
                )
        elseif DraggingHue then
            h = math.clamp(
                (offset - Items.Hue.AbsolutePosition).X
                    / Items.Hue.AbsoluteSize.X,
                0,
                1
            )
        end

        Cfg.Set()
    end

    function Cfg.Set(color)
        if type(color) == 'boolean' then
            return
        end

        if color then
            h, s, v = color:ToHSV()
        end

        Items.SatValHolder.BackgroundColor3 = hsv(h, 1, 1)

        Library:Tween(
            Items.SatValDragger,
            {
                Position = dim2(s, 0, 1 - v, 0),
            },
            TweenInfo.new(
                Library.DraggingSpeed,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                0,
                false,
                0
            )
        )

        Library:Tween(
            Items.HueDragger,
            {
                Position = dim2(h, 0, 0.5, 0),
            },
            TweenInfo.new(
                Library.DraggingSpeed,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.InOut,
                0,
                false,
                0
            )
        )

        Items.ColorpickerObject.BackgroundColor3 = hsv(h, s, v)

        local Color = Items.ColorpickerObject.BackgroundColor3 -- Overwriting to format<<

        if not Cfg.Focused then
            Items.Textbox.Text = string.format(
                '%s, %s, %s',
                math.floor(Color.R * 255),
                math.floor(Color.G * 255),
                math.floor(Color.B * 255)
            )
        end

        local Color = hsv(h, s, v)

        Flags[Cfg.Flag] = {
            Color = Color,
            Transparency = a,
        }

        Cfg.Callback(Color, a)
    end

    Items.ColorpickerObject.MouseButton1Click:Connect(function()
        Cfg.Open = not Cfg.Open
        Cfg.SetVisible(Cfg.Open)
    end)

    Items.Exit.MouseButton1Click:Connect(function()
        Cfg.Open = false
        Cfg.SetVisible(false)
    end)

    InputService.InputChanged:Connect(function(input)
        if
            (DraggingSat or DraggingHue)
            and input.UserInputType == Enum.UserInputType.MouseMovement
        then
            Cfg.UpdateColor()
        end
    end)

    Library:Connection(InputService.InputBegan, function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            and not Library:Hovering({
                Items.ColorpickerObject,
                Items.Colorpicker,
            })
            and Items.Colorpicker.Visible
        then
            Cfg.SetVisible(false)
        end
    end)

    Library:Connection(InputService.InputEnded, function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            DraggingSat = false
            DraggingHue = false
        end
    end)

    Items.HueOutline.InputBegan:Connect(function(input)
        if
            not (
                input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch
            )
        then
            return
        end

        DraggingHue = true
    end)

    Items.Sat.InputBegan:Connect(function(input)
        if
            input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        then
            DraggingSat = true
        end
    end)

    Items.Textbox.FocusLost:Connect(function()
        local r, g, b = Library:Convert(Items.Textbox.Text)

        if r and g and b then
            Cfg.Set(rgb(r, g, b))
        end
    end)

    Cfg.Set(Cfg.Color, Cfg.Alpha)
    Cfg.SetVisible(false)
    ConfigFlags[Cfg.Flag] = Cfg.Set

    return setmetatable(Cfg, Library)
end

function Library:Round(num, float)
    local Multiplier = 1 / (float or 1)
    return math.floor(num * Multiplier + 0.5) / Multiplier
end

function Library:Themify(instance, theme, property)
    table.insert(themes.utility[theme][property], instance)
end

function Library:SaveGradient(instance, theme)
    table.insert(themes.gradients[theme], instance)
end

function Library:RefreshTheme(theme, color)
    for property, instances in themes.utility[theme] do
        for _, object in instances do
            if object[property] == themes.preset[theme] then
                object[property] = color
            end
        end
    end

    themes.preset[theme] = color
end

function Library:Connection(signal, callback)
    local connection = signal:Connect(callback)

    table.insert(Library.Connections, connection)

    return connection
end

function Library:CloseElement()
    local IsMulti = typeof(Library.OpenElement)

    if not Library.OpenElement then
        return
    end

    for i = 1, #Library.OpenElement do
        local Data = Library.OpenElement[i]

        if Data.Ignore then
            continue
        end

        Data.SetVisible(false)
        Data.Open = false
    end

    Library.OpenElement = {}
end

function Library:Create(instance, options)
    local ins = Instance.new(instance)

    for prop, value in options do
        ins[prop] = value
    end

    if ins.ClassName == 'TextButton' then
        ins['AutoButtonColor'] = false
        ins['Text'] = ''
        Library:Themify(ins, 'text_color', 'TextColor3')
    end

    return ins
end

function Library:Unload()
    repeat
        task.wait()
    until #Library.Notifications.Notifs == 0

    if not Library then
        return
    end

    for _, connection in Library.Connections do
        if not connection then
            continue
        end

        connection:Disconnect()
        connection = nil
    end

    if Library.Items then
        Library.Items:Destroy()
    end

    if Library.Other then
        Library.Other:Destroy()
    end

    if Library.Elements then
        Library.Elements:Destroy()
    end

    if Library.Blur then
        Library.Blur:Destroy()
    end

    if Esp then
        Esp.Unload()
    end

    getgenv().Library = nil
end
--

-- Library element functions
Library.Items = Library:Create('ScreenGui', {
    Parent = CoreGui,
    Name = '\0',
    Enabled = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    DisplayOrder = 100,
})

Library.Other = Library:Create('ScreenGui', {
    Parent = gethui(),
    Name = '\0',
    Enabled = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
})

Library.Elements = Library:Create('ScreenGui', {
    Parent = gethui(),
    Name = '\0',
    Enabled = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    DisplayOrder = 100,
})

Library.Blur = Library:Create('BlurEffect', {
    Parent = Lighting,
    Enabled = true,
    Size = 100,
})

function Library:Window(properties)
    local Cfg = {
        Name = properties.Name or 'OLoader',
        Suffix = properties.Suffix or '[v1.0.1]',
        Logo = properties.Logo or 'rbxassetid://138819606033799',
        Size = properties.Size or dim2(0, 771, 0, 523),

        Items = {},
        Tweening = false,
        -- Tick = tick();
        -- Fps = 0;
    }

    local Items = Cfg.Items
    do
        Items.Outline = Library:Create('Frame', {
            AnchorPoint = vec2(0.5, 0.5),
            Parent = Library.Items,
            Name = '\0',
            Position = dim2(0.5, 0, 0.5, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = Cfg.Size,
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.background,
        })
        Library:Themify(Items.Outline, 'background', 'BackgroundColor3')
        Items.Outline.Position = dim_offset(
            Items.Outline.AbsolutePosition.X,
            Items.Outline.AbsolutePosition.Y
        )
        Items.Outline.AnchorPoint = vec2(0, 0)
        Library:Draggify(Items.Outline)
        Library:Resizify(Items.Outline)

        Library:Create('UICorner', {
            Parent = Items.Outline,
            CornerRadius = dim(0, 11),
        })

        Items.TopBar = Library:Create('Frame', {
            Name = '\0',
            Parent = Items.Outline,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 50),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
        })
        Library:Themify(Items.TopBar, 'holders', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.TopBar,
            CornerRadius = dim(0, 11),
        })

        Items.Fill = Library:Create('Frame', {
            AnchorPoint = vec2(0, 1),
            Parent = Items.TopBar,
            Name = '\0',
            Position = dim2(0, 0, 1, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 11),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
        })
        Library:Themify(Items.Fill, 'holders', 'BackgroundColor3')

        Items.Cross = Library:Create('ImageButton', {
            ImageColor3 = themes.preset.accent,
            Active = false,
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.TopBar,
            Name = '\0',
            Size = dim2(0, 18, 0, 18),
            AnchorPoint = vec2(1, 0),
            Image = 'rbxassetid://79487166337822',
            BackgroundTransparency = 1,
            Position = dim2(1, -16, 0, 16),
            Selectable = false,
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Cross, 'accent', 'ImageColor3')

        Items.Logo = Library:Create('ImageLabel', {
            ImageColor3 = themes.preset.accent,
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.TopBar,
            AnchorPoint = vec2(0, 0.5),
            Image = Cfg.Logo,
            BackgroundTransparency = 11,
            Position = dim2(0, 14, 0.5, 0),
            Size = dim2(0, 22, 0, 20),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Logo, 'accent', 'ImageColor3')

        Items.Title = Library:Create('TextLabel', {
            FontFace = Fonts[themes.preset.font],
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Name,
            Parent = Items.TopBar,
            Name = '\0',
            AnchorPoint = vec2(0, 0.5),
            Position = dim2(0, 43, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 19,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.Subtext = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = themes.preset.sub_text,
            TextColor3 = rgb(83, 91, 121),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Suffix,
            Parent = Items.Title,
            Name = '\0',
            AnchorPoint = vec2(0, 0.5),
            Position = dim2(1, 4, 0.5, 3),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 14,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Subtext, 'sub_text', 'TextColor3')

        Items.SideBar = Library:Create('Frame', {
            Parent = Items.Outline,
            Name = '\0',
            Position = dim2(0, 0, 0, 50),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 201, 1, -50),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.background,
            BackgroundColor3 = rgb(21, 22, 29),
        })
        Library:Themify(Items.SideBar, 'background', 'BackgroundColor3')

        Items.Line = Library:Create('Frame', {
            AnchorPoint = vec2(1, 0),
            Parent = Items.SideBar,
            Name = '\0',
            Position = dim2(1, 0, 0, 25),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 1, 1, -50),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
            BackgroundColor3 = rgb(24, 25, 34),
        })
        Library:Themify(Items.Line, 'holders', 'BackgroundColor3')

        Items.TabButtonHolder = Library:Create('Frame', {
            Parent = Items.SideBar,
            Name = '\0',
            BackgroundTransparency = 1,
            Position = dim2(0, 10, 0, 10),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, -20, 1, -20),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Library:Create('UIListLayout', {
            Parent = Items.TabButtonHolder,
            Padding = dim(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
        })

        Items.ScriptPages = Library:Create('Frame', {
            Visible = true,
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.Outline,
            BackgroundTransparency = 1,
            Position = dim2(0, 222, 0, 61),
            Name = '\0',
            Size = dim2(1, -253, 1, -82),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })
    end

    function Cfg.ChangeMenuTitle(string, subtext)
        Items.Title.Text = string
        Items.SubText.Text = subtext
    end

    function Cfg.SetVisible(bool)
        if Library.Tweening then
            return
        end

        Library:Tween(
            Library.Blur,
            { Size = bool and (Flags['BlurSize'] or 15) or 0 }
        )

        Cfg.Tween(bool)
    end

    function Cfg.Tween(bool)
        if not (Library and Library.Items) then
            return
        end

        if Library.Tweening then
            return
        end

        Library.Tweening = true

        if bool and Library.Items then
            Library.Items.Enabled = true
        end

        local Children = Library.Items:GetDescendants()
        table.insert(Children, Items.Holder)

        local Tween
        for _, obj in Children do
            local Index = Library:GetTransparency(obj)

            if not Index then
                continue
            end

            if type(Index) == 'table' then
                for _, prop in Index do
                    Tween = Library:Fade(obj, prop, bool)
                end
            else
                Tween = Library:Fade(obj, Index, bool)
            end
        end

        Library:Connection(Tween.Completed, function()
            Library.Tweening = false
            Library.Items.Enabled = bool
        end)

        Library:Tween(Library.Blur, { Size = bool and 100 or 0 })
    end

    Items.Cross.MouseButton1Click:Connect(function()
        Cfg.Tween(false)
        task.wait(Library.TweeningSpeed)
        Library:Unload()
    end)

    return setmetatable(Cfg, Library)
end

function Library:Tab(properties)
    local Cfg = {
        Name = properties.name or properties.Name or 'Games',
        Type = properties.Type or 'Scripts',
        Icon = properties.Icon or 'rbxassetid://95870104551845',

        Items = {},
        Tweening = false,
        ScriptOpen,
        Scripts = {},
    }

    Cfg.Items.ScriptPages = self.Items.ScriptPages
    Cfg.Items.Window = self.Items.Outline

    local Items = Cfg.Items
    do
        -- Tab Buttons
        Items.Outline = Library:Create('TextButton', {
            Parent = self.Items.TabButtonHolder,
            BackgroundTransparency = 1,
            Name = '\0',
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 0, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
            BackgroundColor3 = rgb(24, 25, 34),
        })
        Library:Themify(Items.Outline, 'holders', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.Outline,
        })

        Items.Icon = Library:Create('ImageLabel', {
            ImageColor3 = themes.preset.accent,
            ImageColor3 = rgb(92, 138, 255),
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.Outline,
            Name = '\0',
            AnchorPoint = vec2(0, 0.5),
            Image = Cfg.Icon,
            BackgroundTransparency = 11,
            Position = dim2(0, 14, 0.5, 0),
            Size = dim2(0, 24, 0, 24),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Icon, 'accent', 'ImageColor3')

        Items.Gradient = Library:Create('UIGradient', {
            Color = rgbseq({
                rgbkey(0, rgb(255, 255, 255)),
                rgbkey(1, rgb(255, 255, 255)),
            }),
            Parent = Items.Icon,
            Transparency = numseq({ numkey(0, 0.67), numkey(1, 0.67) }),
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(138, 138, 142),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Name,
            Parent = Items.Outline,
            Name = '\0',
            AnchorPoint = vec2(0, 0.5),
            Position = dim2(0, 46, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 14,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        --

        -- Page Directory
        if Cfg.Type == 'Script' then
            Items.Page = Library:Create('Frame', {
                Parent = Library.Other,
                BackgroundTransparency = 1,
                Name = '\0',
                BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255),
            })

            Items.ScrollingPage = Library:Create('ScrollingFrame', {
                ScrollBarImageColor3 = rgb(56, 65, 79),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 2,
                Parent = Items.Page,
                Selectable = false,
                Size = dim2(1, -223, 1, -100),
                Name = '\0',
                Position = dim2(0, 212, 0, 100),
                BorderColor3 = rgb(0, 0, 0),
                BackgroundColor3 = themes.preset.background,
                BackgroundColor3 = rgb(21, 22, 29),
                BorderSizePixel = 0,
                CanvasSize = dim2(0, 0, 0, 0),
            })
            Library:Themify(
                Items.ScrollingPage,
                'background',
                'BackgroundColor3'
            )
            Library:Themify(
                Items.ScrollingPage,
                'scroll_bars',
                'ScrollBarImageColor3'
            )

            Library:Create('UIGridLayout', {
                Parent = Items.ScrollingPage,
                SortOrder = Enum.SortOrder.LayoutOrder,
                CellSize = dim2(0, 119, 0, 119),
            })

            Items.Searchbar = Library:Create('Frame', {
                AnchorPoint = vec2(0, 1),
                Parent = Items.Page,
                Name = '\0',
                Position = dim2(0, 212, 0, 90),
                BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -223, 0, 30),
                BorderSizePixel = 0,
                BackgroundColor3 = themes.preset.holders,
                BackgroundColor3 = rgb(24, 25, 34),
            })
            Library:Themify(Items.Searchbar, 'holders', 'BackgroundColor3')

            Library:Create('UICorner', {
                Parent = Items.Searchbar,
            })

            Items.Textbox = Library:Create('TextBox', {
                FontFace = Font.new(
                    'rbxassetid://12187365364',
                    Enum.FontWeight.SemiBold,
                    Enum.FontStyle.Normal
                ),
                TextColor3 = rgb(138, 138, 142),
                BorderColor3 = rgb(0, 0, 0),
                PlaceholderText = 'Search here...',
                Parent = Items.Searchbar,
                Name = '\0',
                Text = '',
                AnchorPoint = vec2(0, 0.5),
                Position = dim2(0, 9, 0.5, 0),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left,
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.XY,
                TextSize = 14,
                BackgroundColor3 = rgb(255, 255, 255),
            })

            Items.Textbox:GetPropertyChangedSignal('Text'):Connect(function()
                for _, Script in Cfg.Scripts do
                    local Visible = string.find(
                        string.lower(Script[1]),
                        string.lower(Items.Textbox.Text)
                    )
                    Script[2].Visible = Visible
                end
            end)

            Items.Search = Library:Create('ImageButton', {
                ImageColor3 = themes.preset.accent,
                ImageColor3 = rgb(92, 138, 255),
                Active = false,
                BorderColor3 = rgb(0, 0, 0),
                Parent = Items.Searchbar,
                Name = '\0',
                Size = dim2(0, 18, 0, 18),
                AnchorPoint = vec2(1, 0.5),
                Image = 'rbxassetid://82010266442270',
                BackgroundTransparency = 1,
                Position = dim2(1, -8, 0.5, 0),
                Selectable = false,
                BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255),
            })
            Library:Themify(Items.Search, 'accent', 'ImageColor3')

            Library:Create('UIGradient', {
                Color = rgbseq({
                    rgbkey(0, rgb(97, 97, 97)),
                    rgbkey(1, rgb(97, 97, 97)),
                }),
                Parent = Items.Search,
            })

            Items.Fading = Library:Create('Frame', {
                AnchorPoint = vec2(0, 1),
                Parent = Items.Page,
                Name = '\0',
                Position = dim2(0, 212, 1, 0),
                BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, -223, 0, 20),
                BorderSizePixel = 0,
                BackgroundColor3 = themes.preset.background,
                BackgroundColor3 = rgb(21, 22, 29),
            })
            Library:Themify(Items.Fading, 'background', 'BackgroundColor3')

            Library:Create('UIGradient', {
                Rotation = 90,
                Transparency = numseq({ numkey(0, 1), numkey(1, 0) }),
                Parent = Items.Fading,
            })
        else
            Items.Page = Library:Create('Frame', {
                Parent = Library.Other,
                BackgroundTransparency = 1,
                Name = '\0',
                BorderColor3 = rgb(0, 0, 0),
                Size = dim2(1, 0, 1, 0),
                BorderSizePixel = 0,
                BackgroundColor3 = rgb(255, 255, 255),
            })

            Items.Elements = Library:Create('Frame', {
                BorderColor3 = rgb(0, 0, 0),
                Parent = Items.Page,
                Name = '\0',
                BackgroundTransparency = 1,
                Position = dim2(0, 217, 0, 70),
                Size = dim2(1, -233, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = rgb(255, 255, 255),
            })

            Library:Create('UIListLayout', {
                Parent = Items.Elements,
                Padding = dim(0, 10),
                SortOrder = Enum.SortOrder.LayoutOrder,
            })

            Library:Create('UIPadding', {
                PaddingBottom = dim(0, 16),
                Parent = Items.Elements,
            })
        end
        --
    end

    function Cfg.OpenTab()
        local Tab = self.TabInfo

        if Tab == Cfg then
            return
        end

        if Tab then
            if Tab.ScriptOpen then
                Tab.ScriptOpen.Tween(false)
            end

            if Tab.KeyMenu and Tab.KeyMenu.Open then
                Tab.KeyMenu.Tween(false)
            end

            Library:Tween(Tab.Items.Outline, { BackgroundTransparency = 1 })

            task.spawn(function()
                for i = 0, 67 do
                    task.wait(Library.TweeningSpeed / 100)
                    local t = i / 100
                    Tab.Items.Gradient.Transparency = numseq({
                        numkey(0, t * 0.67),
                        numkey(1, t * 0.67),
                    })
                end
            end)

            Library:Tween(Tab.Items.Title, { TextColor3 = rgb(138, 138, 142) })
            Tab.Tween(false)
        end

        Cfg.Tween(true)

        Library:Tween(Items.Outline, { BackgroundTransparency = 0 })

        task.spawn(function()
            for i = 67, 0, -1 do
                task.wait(Library.TweeningSpeed / 100)
                local t = i / 100
                Items.Gradient.Transparency = numseq({
                    numkey(0, t * 0.67),
                    numkey(1, t * 0.67),
                })
            end
        end)

        Library:Tween(Items.Title, { TextColor3 = themes.preset.text_color })

        self.TabInfo = Cfg
    end

    function Cfg.Tween(bool)
        if Cfg.Tweening == true then
            return
        end

        Cfg.Tweening = true

        if bool then
            Items.Page.Visible = true
            Items.Page.Parent = self.Items.Outline
        end

        local Children = Items.Page:GetDescendants()
        table.insert(Children, Items.Page)

        local Tween
        for _, obj in Children do
            local Index = Library:GetTransparency(obj)

            if not Index then
                continue
            end

            if type(Index) == 'table' then
                for _, prop in Index do
                    Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                end
            else
                Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
            end
        end

        Library:Connection(Tween.Completed, function()
            Cfg.Tweening = false
            Items.Page.Visible = bool
            Items.Page.Parent = bool and self.Items.Outline or Library.Other
        end)
    end

    Items.Outline.MouseButton1Down:Connect(function()
        if Cfg.Tweening or self.TabInfo.Tweening then
            return
        end

        Cfg.OpenTab()
    end)

    if not self.TabInfo then
        Cfg.OpenTab()
    end

    return setmetatable(Cfg, Library)
end

function Library:Script(properties)
    local Cfg = {
        Name = properties.Name or 'Script Hub',
        Icon = properties.Icon or 'rbxassetid://112739674559818',
        PageName = properties.PageName or properties.Name or 'Script Hub',
        Suffix = properties.Suffix or '',

        ButtonName = properties.ButtonName or 'LOAD',
        Callback = properties.Callback or function() end,
        Key = properties.Key or false,

        GetKeyCallback = properties.GetKeyCallback or function() end,
        -- Other
        Items = {},
    }

    Cfg.Items.Window = self.Items.Window

    local Items = Cfg.Items
    do
        -- Icon
        Items.IconButton = Library:Create('TextButton', {
            Parent = self.Items.ScrollingPage,
            Size = dim2(0, 100, 0, 100),
            Name = '\0',
            Active = false,
            BorderColor3 = rgb(0, 0, 0),
            Selectable = false,
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
            BackgroundColor3 = rgb(24, 25, 34),
        })
        Library:Themify(Items.Button, 'holders', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.IconButton,
        })

        Items.Logo = Library:Create('ImageLabel', {
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.IconButton,
            Name = '\0',
            Image = Cfg.Icon,
            BackgroundTransparency = 1,
            Position = dim2(0, 2, 0, 2),
            Size = dim2(1, -4, 1, -4),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.Overlay = Library:Create('Frame', {
            Name = '\0',
            Parent = Items.Logo,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0),
        })

        Library:Create('UICorner', {
            Parent = Items.Overlay,
        })

        Library:Create('UIGradient', {
            Rotation = 90,
            Transparency = numseq({ numkey(0, 1), numkey(1, 0) }),
            Parent = Items.Overlay,
            Color = rgbseq({
                rgbkey(0, rgb(255, 255, 255)),
                rgbkey(1, rgb(48, 48, 48)),
            }),
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Name,
            Parent = Items.Overlay,
            Name = '\0',
            AnchorPoint = vec2(0.5, 1),
            Position = dim2(0.5, 0, 1, -10),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 14,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Library:Create('UICorner', {
            Parent = Items.Logo,
        })

        self.Scripts[#self.Scripts + 1] = { Cfg.Name, Items.IconButton }
        --

        -- Page
        Items.ScriptPage = Library:Create('Frame', {
            Parent = self.Items.ScriptPages,
            Visible = false,
            BackgroundTransparency = 1,
            Name = '\0',
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.InfoPage = Library:Create('ScrollingFrame', {
            Parent = Items.ScriptPage,
            Name = '\0',
            BackgroundTransparency = 1,
            Position = dim2(0, 0, 0, 50),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 1, -40),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
            ScrollBarImageColor3 = rgb(56, 65, 79),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 2,
            Selectable = true,
            CanvasSize = dim2(0, 0, 0, 0),
        })

        Library:Create('UIListLayout', {
            Parent = Items.InfoPage,
            Padding = dim(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        Items.TopBarHolder = Library:Create('Frame', {
            Parent = Items.ScriptPage,
            BackgroundTransparency = 1,
            Name = '\0',
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.BackArrow = Library:Create('ImageButton', {
            ImageColor3 = themes.preset.accent,
            ImageColor3 = rgb(92, 138, 255),
            ScaleType = Enum.ScaleType.Fit,
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.TopBarHolder,
            Image = 'rbxassetid://136196188904016',
            BackgroundTransparency = 11,
            Name = '\0',
            Size = dim2(0, 18, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.BackArrow, 'accent', 'ImageColor3')

        Items.LineHolder = Library:Create('Frame', {
            Parent = Items.TopBarHolder,
            BackgroundTransparency = 1,
            Name = '\0',
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 12, 1, 0),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.Line = Library:Create('Frame', {
            Parent = Items.LineHolder,
            Name = '\0',
            Position = dim2(0, 7, 0, 8),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 1, 1, -16),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
            BackgroundColor3 = rgb(24, 25, 34),
        })
        Library:Themify(Items.Line, 'holders', 'BackgroundColor3')

        Library:Create('UIListLayout', {
            Parent = Items.TopBarHolder,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        Items.Button = Library:Create('TextButton', {
            LayoutOrder = 9999,
            Name = '\0',
            Parent = Items.TopBarHolder,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 160, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.accent,
            BackgroundColor3 = rgb(92, 138, 255),
        })
        Library:Themify(Items.Button, 'accent', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.Button,
            CornerRadius = dim(0, 4),
        })

        Items.Text = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.Bold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = themes.preset.background,
            TextColor3 = rgb(21, 22, 29),
            BorderColor3 = rgb(0, 0, 0),
            Text = 'LOAD',
            Parent = Items.Button,
            Name = '\0',
            AnchorPoint = vec2(0.5, 0.5),
            Position = dim2(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 15,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Text, 'background', 'TextColor3')

        Items.TextHolder = Library:Create('Frame', {
            Parent = Items.TopBarHolder,
            Name = '\0',
            BackgroundTransparency = 1,
            Size = dim2(0, 12, 1, 0),
            BorderColor3 = rgb(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Library:Create('UIPadding', {
            PaddingRight = dim(0, 18),
            Parent = Items.TextHolder,
        })

        Items.ScriptName = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Name,
            Parent = Items.TextHolder,
            Name = '\0',
            AnchorPoint = vec2(0, 0.5),
            Position = dim2(0, 9, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 19,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.ScriptSubText = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = themes.preset.sub_text,
            TextColor3 = rgb(83, 91, 121),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Suffix,
            Parent = Items.ScriptName,
            Name = '\0',
            AnchorPoint = vec2(0, 0.5),
            Position = dim2(1, 4, 0.5, 3),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 14,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.ScriptSubText, 'sub_text', 'TextColor3')

        Library:Create('UIFlexItem', {
            Parent = Items.TextHolder,
            FlexMode = Enum.UIFlexMode.Fill,
        })

        --
    end

    function Cfg.Tween(bool)
        if Cfg.Tweening == true then
            return
        end

        Cfg.Tweening = true

        if bool then
            Items.ScriptPage.Visible = true
        end

        local Children = Items.ScriptPage:GetDescendants()
        table.insert(Children, Items.ScriptPage)

        local Tween
        for _, obj in Children do
            local Index = Library:GetTransparency(obj)

            if not Index then
                continue
            end

            if type(Index) == 'table' then
                for _, prop in Index do
                    Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                end
            else
                Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
            end
        end

        Library:Connection(Tween.Completed, function()
            Cfg.Tweening = false
            Items.ScriptPage.Visible = bool
        end)
    end

    Items.IconButton.MouseButton1Click:Connect(function()
        self.ScriptOpen = Cfg
        self.Tween(false)
        Cfg.Tween(true)
    end)

    Items.BackArrow.MouseButton1Click:Connect(function()
        self.ScriptOpen = nil
        self.Tween(true)
        Cfg.Tween(false)

        if self.KeyMenu then
            self.KeyMenu.Tween(false)
        end
    end)

    if Cfg.Key then
        self.KeyMenu = setmetatable(Cfg, Library):KeyTab({})

        Items.Button.MouseButton1Click:Connect(function()
            self.KeyMenu.Tween(true)
        end)
    else
        Items.Button.MouseButton1Click:Connect(function()
            self.ScriptOpen = nil
            self.Tween(true)
            Cfg.Tween(false)
        end)
    end

    return setmetatable(Cfg, Library)
end

function Library:KeyTab(properties) -- Ignore this.
    local Cfg = {
        Callback = self.Callback,

        Items = {},
        Open = false,
        Tweening = false,
    }

    local Items = Cfg.Items
    do
        Items.Fade = Library:Create('Frame', {
            Visible = false,
            BorderColor3 = rgb(0, 0, 0),
            Parent = self.Items.Window,
            BackgroundTransparency = 0.6000000238418579,
            Name = '\0',
            Size = dim2(1, 0, 1, 0),
            ZIndex = 2,
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(0, 0, 0),
        })

        Library:Create('UICorner', {
            Parent = Items.Fade,
            CornerRadius = dim(0, 11),
        })

        Items.Outline = Library:Create('Frame', {
            BorderColor3 = rgb(0, 0, 0),
            AnchorPoint = vec2(0.5, 0.5),
            Parent = Items.Fade,
            Name = '\0',
            Position = dim2(0.5, 0, 0.5, 0),
            Size = dim2(0, 300, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = themes.preset.background,
            BackgroundColor3 = rgb(21, 22, 29),
        })
        Library:Themify(Items.Outline, 'background', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.Outline,
            CornerRadius = dim(0, 11),
        })

        Items.TopBar = Library:Create('Frame', {
            Name = '\0',
            Parent = Items.Outline,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 50),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
            BackgroundColor3 = rgb(24, 25, 34),
        })
        Library:Themify(Items.TopBar, 'holders', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.TopBar,
            CornerRadius = dim(0, 11),
        })

        Items.Fill = Library:Create('Frame', {
            AnchorPoint = vec2(0, 1),
            Parent = Items.TopBar,
            Name = '\0',
            Position = dim2(0, 0, 1, 0),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 11),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
            BackgroundColor3 = rgb(24, 25, 34),
        })
        Library:Themify(Items.Fill, 'holders', 'BackgroundColor3')

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = 'Login',
            Parent = Items.TopBar,
            Name = '\0',
            BackgroundTransparency = 1,
            Size = dim2(1, 0, 1, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 19,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.Cross = Library:Create('ImageButton', {
            ImageColor3 = themes.preset.accent,
            ImageColor3 = rgb(92, 138, 255),
            Active = false,
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.TopBar,
            Name = '\0',
            Size = dim2(0, 18, 0, 18),
            AnchorPoint = vec2(1, 0),
            Image = 'rbxassetid://79487166337822',
            BackgroundTransparency = 1,
            Position = dim2(1, -16, 0, 16),
            Selectable = false,
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Cross, 'accent', 'ImageColor3')

        Items.Elements = Library:Create('Frame', {
            BorderColor3 = rgb(0, 0, 0),
            Parent = Items.Outline,
            Name = '\0',
            BackgroundTransparency = 1,
            Position = dim2(0, 16, 0, 58),
            Size = dim2(1, -32, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Library:Create('UIListLayout', {
            Parent = Items.Elements,
            Padding = dim(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        Items.Element = Library:Create('Frame', {
            Parent = Items.Elements,
            Name = '\0',
            BackgroundTransparency = 1,
            Size = dim2(1, 0, 0, 0),
            BorderColor3 = rgb(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.TextboxHolder = Library:Create('Frame', {
            Parent = Items.Element,
            Name = '\0',
            Position = dim2(0, 0, 0, 23),
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(1, 0, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.holders,
            BackgroundColor3 = rgb(24, 25, 34),
        })
        Library:Themify(Items.TextboxHolder, 'holders', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.Textbox,
        })

        Items.Textbox = Library:Create('TextBox', {
            CursorPosition = -1,
            Active = false,
            Selectable = false,
            TextSize = 14,
            Size = dim2(1, -9, 1, 0),
            ClipsDescendants = true,
            BorderColor3 = rgb(0, 0, 0),
            Text = 'Input key...',
            Parent = Items.TextboxHolder,
            Name = '\0',
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(138, 138, 142),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            Position = dim2(0, 9, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = 'Key:',
            Parent = Items.Element,
            Name = '\0',
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 16,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.Element = Library:Create('Frame', {
            Parent = Items.Elements,
            Name = '\0',
            BackgroundTransparency = 1,
            Size = dim2(1, 0, 0, 0),
            BorderColor3 = rgb(0, 0, 0),
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Items.Load = Library:Create('TextButton', {
            LayoutOrder = 9999,
            Name = '\0',
            Parent = Items.Element,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 160, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.accent,
        })
        Library:Themify(Items.Load, 'accent', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.Load,
            CornerRadius = dim(0, 4),
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.Bold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = themes.preset.background,
            TextColor3 = rgb(21, 22, 29),
            BorderColor3 = rgb(0, 0, 0),
            Text = 'EXECUTE',
            Parent = Items.Load,
            Name = '\0',
            AnchorPoint = vec2(0.5, 0.5),
            Position = dim2(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 15,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Title, 'background', 'TextColor3')

        Items.GetKeyButton = Library:Create('TextButton', {
            LayoutOrder = 9999,
            Name = '\0',
            Parent = Items.Element,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 160, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.accent,
        })
        Library:Themify(Items.GetKeyButton, 'accent', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.GetKeyButton,
            CornerRadius = dim(0, 4),
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.Bold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = themes.preset.background,
            TextColor3 = rgb(21, 22, 29),
            BorderColor3 = rgb(0, 0, 0),
            Text = 'GET KEY',
            Parent = Items.GetKeyButton,
            Name = '\0',
            AnchorPoint = vec2(0.5, 0.5),
            Position = dim2(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 15,
        })
        Library:Themify(Items.Title, 'background', 'TextColor3')

        Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Parent = Items.Element,
            Padding = dim(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        Library:Create('UIPadding', {
            PaddingBottom = dim(0, 16),
            Parent = Items.Elements,
        })
    end

    function Cfg.Tween(bool)
        if Cfg.Tweening == true then
            return
        end

        Cfg.Tweening = true

        if bool then
            Items.Fade.Visible = true
        end

        local Children = Items.Fade:GetDescendants()
        table.insert(Children, Items.Fade)

        local Tween
        for _, obj in Children do
            local Index = Library:GetTransparency(obj)

            if not Index then
                continue
            end

            if type(Index) == 'table' then
                for _, prop in Index do
                    Tween = Library:Fade(obj, prop, bool, Library.TweeningSpeed)
                end
            else
                Tween = Library:Fade(obj, Index, bool, Library.TweeningSpeed)
            end
        end

        Library:Connection(Tween.Completed, function()
            Cfg.Tweening = false
            Items.Fade.Visible = bool
        end)
    end

    Items.Fade:GetPropertyChangedSignal('Visible'):Connect(function()
        Cfg.Open = Items.Fade.Visible
    end)

    Items.Cross.MouseButton1Click:Connect(function()
        Cfg.Tween(false)
    end)

    Items.Load.MouseButton1Click:Connect(function()
        Cfg.Callback(Items.Textbox.Text)
    end)

    Items.GetKeyButton.MouseButton1Click:Connect(function()
        self.GetKeyCallback()
    end)

    return setmetatable(Cfg, Library)
end

function Library:AddTitle(properties)
    local Cfg = {
        Text = properties.Text or 'Description',

        Items = {},
    }

    local Items = Cfg.Items
    do
        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(255, 255, 255),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Text,
            Parent = self.Items.InfoPage,
            Name = '\0',
            AnchorPoint = vec2(0, 0.5),
            Position = dim2(0, 9, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 16,
            BackgroundColor3 = rgb(255, 255, 255),
        })
    end

    return setmetatable(Cfg, Library)
end

function Library:AddInfo(properties)
    local Cfg = {
        Text = properties.Text or 'Description',

        Items = {},
    }

    local Items = Cfg.Items
    do
        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.SemiBold,
                Enum.FontStyle.Normal
            ),
            Parent = self.Items.InfoPage,
            AnchorPoint = vec2(0, 0.5),
            TextSize = 14,
            Size = dim2(1, 0, 0, 0),
            RichText = true,
            TextColor3 = rgb(138, 138, 142),
            BorderColor3 = rgb(0, 0, 0),
            Text = Cfg.Text,
            Name = '\0',
            Position = dim2(0, 9, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = rgb(255, 255, 255),
        })
    end

    return setmetatable(Cfg, Library)
end

function Library:AddImageHolder(properties)
    local Cfg = {
        Sizing = properties.Sizing or dim2(0, 500, 0, 300),
        Callback = properties.Callback or function() end,

        -- Other
        Items = {},
    }

    local Items = Cfg.Items
    do
        Items.Page = Library:Create('Frame', {
            Parent = self.Items.InfoPage,
            BorderSizePixel = 0,
            Size = dim2(1, 0, 0, 0),
            Name = '\0',
            Position = dim2(0, 212, 0, 100),
            BorderColor3 = rgb(0, 0, 0),
            BackgroundColor3 = themes.preset.background,
            BackgroundColor3 = rgb(21, 22, 29),
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        Library:Themify(Items.Page, 'background', 'BackgroundColor3')

        Library:Create('UIGridLayout', {
            Parent = Items.Page,
            SortOrder = Enum.SortOrder.LayoutOrder,
            CellSize = Cfg.Sizing,
            CellPadding = dim2(0, 10, 0, 10),
        })

        Library:Create('UIPadding', {
            PaddingBottom = dim(0, 15),
            PaddingTop = dim(0, 15),
            Parent = Items.Page,
        })
    end

    return setmetatable(Cfg, Library)
end

function Library:AddImage(properties)
    local Cfg = {
        Image = properties.Image or 'rbxassetid://75517905848910',

        -- Other
        Items = {},
    }

    local Items = Cfg.Items
    do
        Items.Logo = Library:Create('ImageLabel', {
            BorderColor3 = rgb(0, 0, 0),
            Parent = self.Items.Page,
            Name = '\0',
            Image = Cfg.Image,
            BackgroundTransparency = 1,
            Position = dim2(0, 2, 0, 2),
            Size = dim2(1, -4, 1, -4),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
        })

        Library:Create('UICorner', {
            Parent = Items.Logo,
        })
    end

    return setmetatable(Cfg, Library)
end

function Library:Colorpicker(properties)
    local Cfg = {
        Name = properties.Name or self.Name or 'Color',
        Flag = properties.Flag or properties.Name or self.Name or 'Colorpicker',
        Callback = properties.Callback or function() end,

        Color = properties.Color or color(1, 1, 1), -- Default to white color if not provided
        Alpha = properties.Alpha or properties.Transparency or 1,

        -- Other
        Open = false,
        Mode = properties.Mode or 'Animation',
        Items = {},
    }

    local Picker = self:Keypicker(Cfg)

    local Items = Picker.Items
    do
        Cfg.Items = Items
        Cfg.Set = Picker.Set
    end

    Cfg.Set(Cfg.Color, Cfg.Alpha)
    ConfigFlags[Cfg.Flag] = Cfg.Set

    return setmetatable(Cfg, Library)
end

function Library:Button(properties)
    local Cfg = {
        Name = properties.Name or 'Button',
        Callback = properties.Callback or function() end,

        -- Other
        Items = {},
    }

    local Items = Cfg.Items
    do
        if not self.Items.Element then
            Items.Element = Library:Create('Frame', {
                Parent = self.Items.Elements,
                Name = '\0',
                BackgroundTransparency = 1,
                Size = dim2(1, 0, 0, 0),
                BorderColor3 = rgb(0, 0, 0),
                BorderSizePixel = 0,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = themes.preset.text_color,
                BackgroundColor3 = rgb(255, 255, 255),
            })
        end

        Items.Button = Library:Create('Frame', {
            LayoutOrder = 9999,
            Name = '\0',
            Parent = self.Items.Element or self.Items.Elements,
            BorderColor3 = rgb(0, 0, 0),
            Size = dim2(0, 160, 0, 40),
            BorderSizePixel = 0,
            BackgroundColor3 = themes.preset.accent,
        })
        Library:Themify(Items.Element, 'text_color', 'BackgroundColor3')

        Library:Create('UICorner', {
            Parent = Items.Button,
            CornerRadius = dim(0, 4),
        })

        Items.Title = Library:Create('TextLabel', {
            FontFace = Font.new(
                'rbxassetid://12187365364',
                Enum.FontWeight.Bold,
                Enum.FontStyle.Normal
            ),
            TextColor3 = rgb(21, 22, 29),
            BorderColor3 = rgb(0, 0, 0),
            Text = 'GET KEY',
            Parent = Items.Button,
            Name = '\0',
            AnchorPoint = vec2(0.5, 0.5),
            Position = dim2(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
            AutomaticSize = Enum.AutomaticSize.XY,
            TextSize = 15,
            BackgroundColor3 = themes.preset.text_color,
            BackgroundColor3 = rgb(255, 255, 255),
        })
        Library:Themify(Items.Title, 'text_color', 'BackgroundColor3')

        Library:Create('UIListLayout', {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Parent = Items.Element,
            Padding = dim(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
    end

    return setmetatable(Cfg, Library)
end
