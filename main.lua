-- 1. استدعاء مكتبة Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 2. إنشاء النافذة الرئيسية (تم التحديث إلى V2)
local Window = Library.CreateLib("Arwa Hub - V2", "Midnight")

-- 3. استدعاء ملف خانة اللاعب
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()

-- 4. تشغيل خانة اللاعب
loadPlayerTab(Window)

-- =========================================
-- 5. إضافات الهاتف (إصلاح نهائي للسحب والإخفاء)
-- =========================================
local CoreGui = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- إنشاء شاشة الزر
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArwaToggleV2"
ScreenGui.Parent = CoreGui

-- تصميم الزر الدائري
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

-- دالة سحب ذكية (تسمح بسحب عنصر عند الضغط على عنصر آخر)
local function MakeDraggable(dragArea, moveTarget)
    moveTarget = moveTarget or dragArea
    local dragging, dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        moveTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = moveTarget.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
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

-- تفعيل السحب للزر الدائري نفسه
MakeDraggable(ToggleBtn)

-- البحث عن الواجهة وتفعيل السحب من المستطيل العلوي + زر الإخفاء
spawn(function()
    wait(1.5) -- ننتظر قليلاً لضمان بناء الواجهة
    
    local MainFrame = nil
    
    -- البحث في كل الواجهات عن "Arwa Hub"
    local guis = {}
    for _, v in pairs(CoreGui:GetChildren()) do table.insert(guis, v) end
    if game.Players.LocalPlayer and game.Players.LocalPlayer:FindFirstChild("PlayerGui") then
        for _, v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do table.insert(guis, v) end
    end

    for _, v in pairs(guis) do
        if v:IsA("ScreenGui") and v:FindFirstChild("Main") then
            local main = v.Main
            if main:FindFirstChild("Top") and main.Top:FindFirstChild("Title") then
                if string.find(main.Top.Title.Text, "Arwa Hub") then
                    MainFrame = main
                    break
                end
            end
        end
    end
    
    -- إذا وجدنا الواجهة
    if MainFrame then
        -- 1. تفعيل السحب فقط عند لمس الشريط العلوي (Top)
        if MainFrame:FindFirstChild("Top") then
            MakeDraggable(MainFrame.Top, MainFrame)
        end
        
        -- 2. برمجة زر الإخفاء والإظهار المضمون
        ToggleBtn.MouseButton1Click:Connect(function()
            MainFrame.Visible = not MainFrame.Visible
            if MainFrame.Visible then
                ToggleBtn.Text = "-"
            else
                ToggleBtn.Text = "+"
            end
        end)
    end
end)
