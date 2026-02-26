return function(Window)
    -- إنشاء خانة "اللاعب"
    local PlayerTab = Window:NewTab("اللاعب")
    
    -- إنشاء قسم داخل الخانة
    local PlayerSection = PlayerTab:NewSection("إعدادات السرعة والطيران")

    -- إضافة شريط تعديل السرعة
    PlayerSection:NewSlider("تعديل السرعة", "تغيير سرعة المشي", 500, 16, function(s) 
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
    end)

    -- إضافة زر الطيران (القفز اللانهائي)
    PlayerSection:NewToggle("طيران (قفز مستمر)", "تشغيل أو إيقاف القفز", function(state)
        _G.InfJump = state
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump then
                game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
            end
        end)
    end)
end
