-- 1. استدعاء مكتبة Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 2. إنشاء النافذة الرئيسية (تحديث V3)
local Window = Library.CreateLib("Arwa Hub - V3", "Midnight")

-- 3. استدعاء ملف خانة اللاعب
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()

-- 4. تشغيل خانة اللاعب
loadPlayerTab(Window)

-- =========================================
-- 5. إضافات الهاتف الاحترافية (V3)
-- =========================================
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- إنشاء شاشة الزر العائم
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ArwaToggleV3"
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleBtn.Position = UDim2.new(0.5, -20, 0, 10)
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Text = "-"
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.TextSize = 30
ToggleBtn.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0)
UICorner.Parent = ToggleBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 255, 255)
UIStroke.Thickness = 2
UIStroke.Parent = ToggleBtn

-- دالة سحب عالمية للموبايل (Touch)
local function MakeDraggable(dragArea, moveTarget)
	moveTarget = moveTarget or dragArea
	local dragging, dragInput, dragStart, startPos

	dragArea.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = moveTarget.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			moveTarget.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

-- جعل الزر الدائري نفسه قابلاً للسحب
MakeDraggable(ToggleBtn)

-- البحث عن واجهة السكربت وربطها (طريقة V3 المضمونة)
local function FixUI()
	local foundMain = nil
	-- البحث في كل الواجهات الممكنة
	for _, v in pairs(CoreGui:GetChildren()) do
		if v:IsA("ScreenGui") and v:FindFirstChild("Main") then
			local main = v.Main
			if main:FindFirstChild("Top") then
				foundMain = main
				-- جعل السحب من المستطيل العلوي فقط كما طلبتِ
				MakeDraggable(main.Top, main)
				
				-- برمجة الإخفاء والإظهار
				ToggleBtn.MouseButton1Click:Connect(function()
					main.Visible = not main.Visible
					ToggleBtn.Text = main.Visible and "-" or "+"
				end)
				return true
			end
		end
	end
	return false
end

-- المحاولة مراراً وتكراراً حتى يجد الواجهة ويصلحها
spawn(function()
	for i = 1, 20 do -- يحاول لـ 20 ثانية
		if FixUI() then break end
		wait(1)
	end
end)
