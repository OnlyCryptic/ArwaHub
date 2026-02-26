-- 1. استدعاء مكتبة Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 2. إنشاء النافذة الرئيسية (تم تغيير الاسم إلى Arwa)
local Window = Library.CreateLib("Arwa", "Midnight")

-- 3. استدعاء ملف خانة اللاعب
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()

-- 4. تشغيل خانة اللاعب
loadPlayerTab(Window)

-- =========================================
-- 5. إضافات الهاتف (السحب باللمس وزر الإخفاء)
-- =========================================
local CoreGui = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- إنشاء شاشة الزر
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArwaToggle"
ScreenGui.Parent = CoreGui

-- تصميم الزر
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Position = UDim2.new(0.5, -20, 0, 15)
ToggleBtn.Size = UDim2.new(0, 40, 0, 40)
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.TextSize = 25
ToggleBtn.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

-- دالة السحب المخصصة للهاتف (اللمس والماوس)
local function MakeDraggable(gui)
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- تفعيل السحب للزر الدائري
MakeDraggable(ToggleBtn)

-- تفعيل السحب لواجهة Arwa باللمس
spawn(function()
    wait(1) -- ننتظر ثانية لتتأكد من تحميل الواجهة
    local kavoGui = CoreGui:FindFirstChild("Kavo")
    if kavoGui and kavoGui:FindFirstChild("Main") then
        MakeDraggable(kavoGui.Main)
    end
end)

-- برمجة الإخفاء والإظهار (إصلاح جذري)
ToggleBtn.MouseButton1Click:Connect(function()
    local kavoGui = CoreGui:FindFirstChild("Kavo")
    if kavoGui then
        kavoGui.Enabled = not kavoGui.Enabled
        if kavoGui.Enabled then
            ToggleBtn.Text = "-"
        else
            ToggleBtn.Text = "+"
        end
    end
end)
