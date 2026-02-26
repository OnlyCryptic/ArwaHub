-- 1. استدعاء مكتبة Rayfield (الأفضل للموبايل)
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. إنشاء النافذة (Arwa Hub V4)
local Window = Rayfield:CreateWindow({
   Name = "Arwa Hub - V4",
   LoadingTitle = "Arwa Hub",
   LoadingSubtitle = "بواسطة Arwa Roger",
   ConfigurationSaving = {
      Enabled = true,
      Folder = "ArwaHubConfig",
      FileName = "MainConfig"
   },
   KeySystem = false -- لا نحتاج مفتاح حالياً
})

-- 3. استدعاء خانة اللاعب من جيتهاب
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()
loadPlayerTab(Window)

-- 4. برمجة زر الإخفاء العائم (Toggle Button)
local CoreGui = game:GetService("CoreGui")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArwaToggleV4"
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.Position = UDim2.new(0.5, -20, 0, 20)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Text = "A" -- اختصار Arwa
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.TextSize = 25

-- جعل الزر دائرياً مع ستايل
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 150)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

-- دالة السحب للزر (Touch Draggable)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

ToggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = ToggleBtn.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- برمجة الإخفاء والإظهار لواجهة Rayfield
ToggleBtn.MouseButton1Click:Connect(function()
    local targetGui = CoreGui:FindFirstChild("Rayfield") or game.Players.LocalPlayer.PlayerGui:FindFirstChild("Rayfield")
    if targetGui then
        targetGui.Enabled = not targetGui.Enabled
    end
end)

Rayfield:Notify({
   Title = "تم التشغيل!",
   Content = "Arwa Hub V4 جاهز للاستخدام",
   Duration = 5,
   Image = 4483345998,
})
