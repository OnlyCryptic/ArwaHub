return function(Window)
    -- إنشاء خانة "اللاعب"
    local PlayerTab = Window:MakeTab({
        Name = "اللاعب",
        Icon = "rbxassetid://4483345998",
        PremiumOnly = false
    })

    -- إضافة شريط تعديل السرعة
    PlayerTab:AddSlider({
        Name = "تعديل السرعة",
        Min = 16,
        Max = 500,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "سرعة",
        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end    
    })

    -- إضافة زر الطيران
    PlayerTab:AddToggle({
        Name = "قفز لا نهائي (طيران)",
        Default = false,
        Callback = function(Value)
            _G.InfJump = Value
            game:GetService("UserInputService").JumpRequest:Connect(function()
                if _G.InfJump then
                    game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid'):ChangeState("Jumping")
                end
            end)
        end    
    })
end

