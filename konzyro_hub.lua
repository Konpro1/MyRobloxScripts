-- [[ KON ZYRO EXECUTOR GUI ]] --

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Prevent duplicate GUIs
if CoreGui:FindFirstChild("KonZyroGUI") then
    CoreGui.KonZyroGUI:Destroy()
end

-- Variables for Features
local InfJumpEnabled = false
local FlyEnabled = false
local WalkSpeedAmount = 16
local FlySpeedAmount = 50
local SpeedLoop = nil
local FlyLoop = nil

-- [[ 1. MAIN UI SETUP ]] --
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KonZyroGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Draggable Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
ToggleBtn.Position = UDim2.new(0, 50, 0, 50)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Text = "KZ"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.TextSize = 20
ToggleBtn.Draggable = true
ToggleBtn.Active = true

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleBtn

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 450, 0, 300)
MainFrame.Visible = false
MainFrame.Draggable = true
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Title
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 10)
Title.Size = UDim2.new(0, 200, 0, 30)
Title.Font = Enum.Font.GothamBlack
Title.Text = "KON ZYRO"
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextSize = 24
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Container
local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 15, 0, 50)
TabContainer.Size = UDim2.new(1, -30, 0, 35)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = TabContainer
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Content Container
local ContentContainer = Instance.new("Frame")
ContentContainer.Parent = MainFrame
ContentContainer.BackgroundTransparency = 1
ContentContainer.Position = UDim2.new(0, 15, 0, 95)
ContentContainer.Size = UDim2.new(1, -30, 1, -110)

-- [[ 2. UI CREATION FUNCTIONS ]] --
local Tabs = {}
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Parent = TabContainer
    TabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    TabBtn.Size = UDim2.new(0, 130, 1, 0)
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.TextSize = 14
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabPage = Instance.new("ScrollingFrame")
    TabPage.Parent = ContentContainer
    TabPage.BackgroundTransparency = 1
    TabPage.Size = UDim2.new(1, 0, 1, 0)
    TabPage.ScrollBarThickness = 4
    TabPage.Visible = false
    
    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = TabPage
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 10)

    Tabs[name] = {Btn = TabBtn, Page = TabPage}

    TabBtn.MouseButton1Click:Connect(function()
        for tName, tData in pairs(Tabs) do
            tData.Page.Visible = (tName == name)
            tData.Btn.TextColor3 = (tName == name) and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
        end
    end)

    return TabPage
end

-- UI Element Generators
local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Parent = btn
    ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    ExecBtn.Size = UDim2.new(0, 80, 0, 25)
    ExecBtn.Position = UDim2.new(1, -90, 0.5, -12.5)
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.Text = "Execute"
    ExecBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
    ExecBtn.TextSize = 12
    Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)
    
    ExecBtn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "  " .. text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    
    local Status = Instance.new("Frame")
    Status.Parent = btn
    Status.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Status.Size = UDim2.new(0, 20, 0, 20)
    Status.Position = UDim2.new(1, -30, 0.5, -10)
    Instance.new("UICorner", Status).CornerRadius = UDim.new(1, 0)
    
    local toggled = false
    btn.MouseButton1Click:Connect(function()
        toggled = not toggled
        Status.BackgroundColor3 = toggled and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 50, 50)
        callback(toggled)
    end)
end

local function CreateInput(parent, text, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    frame.Size = UDim2.new(1, 0, 0, 35)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left

    local box = Instance.new("TextBox")
    box.Parent = frame
    box.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    box.Size = UDim2.new(0, 60, 0, 25)
    box.Position = UDim2.new(1, -155, 0.5, -12.5)
    box.Font = Enum.Font.GothamBold
    box.Text = tostring(defaultVal)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.TextSize = 12
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    
    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Parent = frame
    ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    ExecBtn.Size = UDim2.new(0, 75, 0, 25)
    ExecBtn.Position = UDim2.new(1, -85, 0.5, -12.5)
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.Text = "Apply"
    ExecBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
    ExecBtn.TextSize = 12
    Instance.new("UICorner", ExecBtn).CornerRadius = UDim.new(0, 4)
    
    ExecBtn.MouseButton1Click:Connect(function()
        callback(box.Text)
    end)
end

-- [[ 3. CREATING TABS & FEATURES ]] --
local PageUniversal = CreateTab("Universal")
local PageAntiKick = CreateTab("Anti Kick Scripts")
local PageCredits = CreateTab("Credits")

-- Toggle Functionality
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- *** UNIVERSAL TAB *** --
CreateToggle(PageUniversal, "Infinite Jump", function(state)
    InfJumpEnabled = state
end)

UserInputService.JumpRequest:Connect(function()
    if InfJumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

CreateInput(PageUniversal, "Speed Hack", "50", function(val)
    local num = tonumber(val)
    if num then
        WalkSpeedAmount = num
        if SpeedLoop then SpeedLoop:Disconnect() end
        SpeedLoop = RunService.RenderStepped:Connect(function()
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = WalkSpeedAmount
            end
        end)
    end
end)

CreateInput(PageUniversal, "Fly Speed", "50", function(val)
    local num = tonumber(val)
    if num then FlySpeedAmount = num end
end)

CreateToggle(PageUniversal, "Toggle Fly", function(state)
    FlyEnabled = state
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if FlyEnabled then
        local bg = Instance.new("BodyGyro", root)
        bg.Name = "FlyGyro"
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = root.CFrame
        
        local bv = Instance.new("BodyVelocity", root)
        bv.Name = "FlyVel"
        bv.velocity = Vector3.new(0, 0.1, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        FlyLoop = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            bg.cframe = cam.CFrame
            local moveDir = Vector3.new()
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
            
            bv.velocity = moveDir * FlySpeedAmount
        end)
        
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = true
        end
    else
        if root:FindFirstChild("FlyGyro") then root.FlyGyro:Destroy() end
        if root:FindFirstChild("FlyVel") then root.FlyVel:Destroy() end
        if FlyLoop then FlyLoop:Disconnect() end
        if char:FindFirstChild("Humanoid") then
            char.Humanoid.PlatformStand = false
        end
    end
end)

-- *** ANTI KICK SCRIPTS TAB *** --

CreateButton(PageAntiKick, "1. Ver-Sv Anti Kick", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Ver-Sv/Best-Anti-Kick/refs/heads/main/Best%20anti%20kick%20verosv"))()
end)

CreateButton(PageAntiKick, "2. KGB-RT Anti Kick", function()
    -- Injecting your exact KGB-RT Script
    local ScreenGui = Instance.new("ScreenGui")local Frame = Instance.new("Frame")local TopBar = Instance.new("Frame")local UIGradient = Instance.new("UIGradient")local RainbowStroke = Instance.new("UIStroke")ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")ScreenGui.ResetOnSpawn = falseScreenGui.Name = "KGB_RT_ANTI_KICK"Frame.Parent = ScreenGui Frame.Size = UDim2.new(0, 220, 0, 300)Frame.Position = UDim2.new(0.5, -110, 0.5, -150)Frame.BackgroundColor3 = Color3.fromRGB(110, 0, 0)Frame.BorderSizePixel = 0 Frame.Draggable = true Frame.Active = true local Corner = Instance.new("UICorner")Corner.CornerRadius = UDim.new(0, 18)Corner.Parent = Frame UIGradient.Parent = Frame UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(139, 0, 0)),ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 0, 0))}UIGradient.Rotation = 85 RainbowStroke.Parent = Frame RainbowStroke.Thickness = 4 RainbowStroke.Transparency = 0.2 task.spawn(function()while Frame.Parent do for i = 0, 1, 0.008 do RainbowStroke.Color = Color3.fromHSV(i, 1, 1)task.wait(0.03)end end end)TopBar.Parent = Frame TopBar.Size = UDim2.new(1, 0, 0, 52)TopBar.BackgroundColor3 = Color3.fromRGB(45, 0, 0)TopBar.BorderSizePixel = 0 local TopCorner = Instance.new("UICorner")TopCorner.CornerRadius = UDim.new(0, 18)TopCorner.Parent = TopBar local Title = Instance.new("TextLabel")Title.Parent = TopBar Title.Size = UDim2.new(1, -70, 1, 0)Title.BackgroundTransparency = 1 Title.Text = "☭ KGB-RT ANTI KICK ☭"Title.Font = Enum.Font.GothamBlack Title.TextColor3 = Color3.fromRGB(255, 215, 0)Title.TextSize = 20 Title.TextStrokeTransparency = 0.6 local CloseBtn = Instance.new("TextButton")CloseBtn.Parent = TopBar CloseBtn.Size = UDim2.new(0, 38, 0, 38)CloseBtn.Position = UDim2.new(1, -45, 0.5, -19)CloseBtn.Text = "✕"CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)CloseBtn.TextColor3 = Color3.new(1,1,1)CloseBtn.Font = Enum.Font.GothamBold CloseBtn.TextSize = 22 Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1,0)CloseBtn.MouseButton1Click:Connect(function() Frame.Visible = false end)local MobileBtn = Instance.new("TextButton")MobileBtn.Parent = ScreenGui MobileBtn.Size = UDim2.new(0, 68, 0, 68)MobileBtn.Position = UDim2.new(0.91, 0, 0.35, 0)MobileBtn.BackgroundColor3 = Color3.fromRGB(139, 0, 0)MobileBtn.Text = "☭"MobileBtn.TextColor3 = Color3.new(1,1,1)MobileBtn.TextSize = 38 MobileBtn.Font = Enum.Font.GothamBlack Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1,0)local MobileStroke = Instance.new("UIStroke", MobileBtn)MobileStroke.Thickness = 3 MobileBtn.MouseButton1Click:Connect(function()Frame.Visible = not Frame.Visible end)local AntiKickBtn = Instance.new("TextButton")AntiKickBtn.Parent = Frame AntiKickBtn.Size = UDim2.new(0, 180, 0, 75)AntiKickBtn.Position = UDim2.new(0.5, -90, 0, 85)AntiKickBtn.BackgroundColor3 = Color3.fromRGB(110, 0, 0)AntiKickBtn.TextColor3 = Color3.new(1,1,1)AntiKickBtn.Font = Enum.Font.GothamBold AntiKickBtn.TextSize = 21 AntiKickBtn.Text = "ANTI KICK: OFF"Instance.new("UICorner", AntiKickBtn).CornerRadius = UDim.new(0, 16)local BtnStroke = Instance.new("UIStroke", AntiKickBtn)BtnStroke.Thickness = 2.5 BtnStroke.Color = Color3.fromRGB(255, 215, 0)local AntiKickEnabled = false AntiKickBtn.MouseButton1Click:Connect(function()AntiKickEnabled = not AntiKickEnabled if AntiKickEnabled then AntiKickBtn.Text = "ANTI KICK: ON"AntiKickBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)BtnStroke.Color = Color3.fromRGB(0, 255, 80)else AntiKickBtn.Text = "ANTI KICK: OFF"AntiKickBtn.BackgroundColor3 = Color3.fromRGB(110, 0, 0)BtnStroke.Color = Color3.fromRGB(255, 215, 0)end end)local DestroyBtn = Instance.new("TextButton")DestroyBtn.Parent = Frame DestroyBtn.Size = UDim2.new(0, 180, 0, 45)DestroyBtn.Position = UDim2.new(0.5, -90, 1, -65)DestroyBtn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)DestroyBtn.TextColor3 = Color3.new(1,1,1)DestroyBtn.Font = Enum.Font.GothamBold DestroyBtn.TextSize = 18 DestroyBtn.Text = "🗑 DESTROY GUI"Instance.new("UICorner", DestroyBtn).CornerRadius = UDim.new(0, 12)DestroyBtn.MouseButton1Click:Connect(function()ScreenGui:Destroy()print("☭ KGB-RT GUI Destroyed!")end)local mt = getrawmetatable(game)local oldNamecall = mt.__namecall local oldNewIndex = mt.__newindex setreadonly(mt, false)mt.__namecall = newcclosure(function(self, ...)local method = getnamecallmethod()if not AntiKickEnabled then return oldNamecall(self, ...) end if method == "Kick" or method == "kick" then warn("☭ KGB-RT: Kick engellendi!")return end if self.Name:lower():find("kick") or self.Name:lower():find("ban") or self.Name:lower():find("moderation") then if method == "FireServer" or method == "InvokeServer" then warn("☭ KGB-RT: Remote engellendi → " .. self.Name)return end end return oldNamecall(self, ...)end)mt.__newindex = newcclosure(function(self, key, value)if not AntiKickEnabled then return oldNewIndex(self, key, value) end if self == game.Players.LocalPlayer and key == "Parent" and value == nil then return end return oldNewIndex(self, key, value)end)setreadonly(mt, true)game:GetService("StarterGui"):SetCore("SendNotification", {Title = "☭ KGB-RT",Text = "Rainbow Kenar + Destroy GUI Yüklendi!",Duration = 7})print("☭ KGB-RT PREMIUM RAINBOW AKTİF! ☭")
end)

CreateButton(PageAntiKick, "3. Rixer95-x2 Anti Kick", function()
    -- Injecting your exact Rixer95 Script
    getgenv().AntiKickMax = true local Players = game:GetService("Players")local LocalPlayer = Players.LocalPlayer local RunService = game:GetService("RunService")local StarterGui = game:GetService("StarterGui")local mt = getrawmetatable(game)local function showKickBlocked()pcall(function()StarterGui:SetCore("SendNotification", {Title = "",Text = "Kick blocked",Duration = 2,Icon = "",})end)end if getgenv().AntiKickLoaded then return end getgenv().AntiKickLoaded = true setreadonly(mt, false)local old_namecall = mt.__namecall mt.__namecall = newcclosure(function(self, ...)local method = getnamecallmethod()local args = {...}if self == LocalPlayer and (method == "Kick" or method:lower():find("kick") or method:lower():find("ban")) then showKickBlocked()return end if method == "FireServer" and (tostring(self):find("Kick") or tostring(self):find("Ban") or tostring(self):find("exploit")) then showKickBlocked()return end if method == "Disconnect" and self == LocalPlayer then showKickBlocked()return end return old_namecall(self, ...)end)if hookfunction then hookfunction(LocalPlayer.Kick, function() showKickBlocked() end)end local old_error = error error = function(msg, level)local s = tostring(msg):lower()if s:find("kick") or s:find("exploit") or s:find("ban") or #tostring(msg) > 1000 then showKickBlocked()return end return old_error(msg, level)end spawn(function()while task.wait(0.15) do pcall(function()for _, c in ipairs(getconnections(LocalPlayer.Idled)) do c:Disable()end end)pcall(function()setreadonly(mt, false)mt.__namecall = newcclosure(function(self, ...)if self == LocalPlayer and getnamecallmethod():lower():find("kick") then showKickBlocked()return end return old_namecall(self, ...)end)setreadonly(mt, true)end)end end)setreadonly(mt, true)
end)

CreateButton(PageAntiKick, "4. Pastefy Anti Kick", function()
    loadstring(game:HttpGet("https://pastefy.app/puryVwow/raw"))()
end)

-- *** CREDITS TAB *** --
local CreditsText = Instance.new("TextLabel")
CreditsText.Parent = PageCredits
CreditsText.BackgroundTransparency = 1
CreditsText.Size = UDim2.new(1, 0, 1, -20)
CreditsText.Font = Enum.Font.GothamBold
CreditsText.Text = "Made by Kon, enjoy (:"
CreditsText.TextColor3 = Color3.fromRGB(0, 255, 255)
CreditsText.TextSize = 22
CreditsText.TextWrapped = true

-- Initialize First Tab
Tabs["Universal"].Btn.TextColor3 = Color3.fromRGB(0, 255, 255)
Tabs["Universal"].Page.Visible = true
