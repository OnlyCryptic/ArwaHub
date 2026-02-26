return function(Window)
    -- إنشاء خانة اللاعب
    local Tab = Window:CreateTab("اللاعب", 4483345998) -- أيقونة اللاعب

    -- قسم إعدادات الحركة
    local Section = Tab:CreateSection("إعدادات الحركة")

    -- شريط السرعة (مدعوم باللمس بالكامل)
    local SpeedSlider = Tab:CreateSlider({
        Name = "تعديل السرعة",
        Range = {16, 500},
        Increment = 1,
        Suffix = "سرعة",
        CurrentValue = 16,
        Flag = "SpeedSlider",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end,
    })

    -- زر الطيران (القفز اللانهائي)
    local JumpToggle = Tab:CreateToggle({
        Name = "طيران (قفز مستمر)",
        CurrentValue = false,
        Flag = "JumpToggle",
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
