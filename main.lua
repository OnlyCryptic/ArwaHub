-- 1. استدعاء مكتبة Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 2. إنشاء النافذة الرئيسية (تم تحسين اللون إلى Midnight)
local Window = Library.CreateLib("Arwa Roger Hub", "Midnight")

-- 3. استدعاء ملف خانة اللاعب
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()

-- 4. تشغيل خانة اللاعب
loadPlayerTab(Window)

-- =========================================
-- 5. إضافة الزر الدائري العائم (للهاتف)
-- =========================================
local CoreGui = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArwaToggle"
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- لون خلفية الزر
ToggleBtn.Position = UDim2.new(0.5, -20, 0, 15) -- الموقع في أعلى المنتصف
ToggleBtn.Size = UDim2.new(0, 40, 0, 40) -- حجم الدائرة
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255) -- لون النص (سماوي أنيق)
ToggleBtn.TextSize = 25
ToggleBtn.BorderSizePixel = 0

-- جعل الزر دائرياً
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

-- إضافة إطار خارجي للزر لجمالية أكثر
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

-- برمجة الإخفاء والإظهار
ToggleBtn.MouseButton1Click:Connect(function()
    local kavo = CoreGui:FindFirstChild("Kavo")
    if kavo and kavo:FindFirstChild("Main") then
        kavo.Main.Visible = not kavo.Main.Visible
        if kavo.Main.Visible then
            ToggleBtn.Text = "-"
        else
            ToggleBtn.Text = "+"
        end
    end
end)
