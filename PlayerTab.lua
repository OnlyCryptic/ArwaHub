return function(Window)
    local Tab = Window:CreateTab("اللاعب", 4483345998)
    local Section = Tab:CreateSection("إعدادات السرعة")

    -- متغيرات التحكم
    _G.SpeedEnabled = false
    _G.WalkSpeedValue = 16

    -- زر تفعيل/تعطيل تعديل السرعة
    Tab:CreateToggle({
        Name = "تفعيل تعديل السرعة",
        CurrentValue = false,
        Callback = function(Value)
            _G.SpeedEnabled = Value
            if not Value then
                -- إرجاع السرعة للطبيعي عند الإغلاق
                if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end,
    })

    -- شريط السرعة (يدعم الكتابة المباشرة داخل المربع الصغير)
    local SpeedSlider = Tab:CreateSlider({
        Name = "السرعة الحالية",
        Range = {16, 500},
        Increment = 1,
        CurrentValue = 16,
        Callback = function(Value)
            _G.WalkSpeedValue = Value
        end,
    })

    -- أزرار الزيادة والنقصان السريعة
    Tab:CreateButton({
        Name = "زيادة (+10)",
        Callback = function()
            _G.WalkSpeedValue = math.min(_G.WalkSpeedValue + 10, 500)
            SpeedSlider:Set(_G.WalkSpeedValue)
        end,
    })

    Tab:CreateButton({
        Name = "زيادة (+5)",
        Callback = function()
            _G.WalkSpeedValue = math.min(_G.WalkSpeedValue + 5, 500)
            SpeedSlider:Set(_G.WalkSpeedValue)
        end,
    })

    Tab:CreateButton({
        Name = "نقصان (-10)",
        Callback = function()
            _G.WalkSpeedValue = math.max(_G.WalkSpeedValue - 10, 16)
            SpeedSlider:Set(_G.WalkSpeedValue)
        end,
    })

    Tab:CreateButton({
        Name = "نقصان (-5)",
        Callback = function()
            _G.WalkSpeedValue = math.max(_G.WalkSpeedValue - 5, 16)
            SpeedSlider:Set(_G.WalkSpeedValue)
        end,
    })

    -- حلقة تكرار لضمان ثبات السرعة إذا كانت مفعلة
    task.spawn(function()
        while task.wait() do
            if _G.SpeedEnabled then
                pcall(function()
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.WalkSpeedValue
                end)
            end
        end
    end)

    -- قسم القفز
    Tab:CreateSection("إعدادات القفز")
    Tab:CreateToggle({
        Name = "قفز لا نهائي",
        CurrentValue = false,
        Callback = function(Value)
            _G.InfJump = Value
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfJump then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
                end
            end)
        end,
    })
end
