return function(Window)
    local Tab = Window:CreateTab("🕳️ الثقب الأسود", 4483345998)
    local Section = Tab:CreateSection("التحكم في الجاذبية")

    -- متغيرات التحكم
    _G.BlackHoleEnabled = false
    _G.BlackHoleRadius = 50
    _G.BlackHolePower = 50

    -- 1. زر تشغيل/إيقاف الثقب الأسود
    Tab:CreateToggle({
        Name = "تفعيل الثقب الأسود (Blackhole)",
        CurrentValue = false,
        Callback = function(Value)
            _G.BlackHoleEnabled = Value
            if Value then
                Rayfield:Notify({Title = "تنبيه", Content = "تم تفعيل الجاذبية! اسحبي كل شيء حولكِ 😈", Duration = 3})
            end
        end,
    })

    -- 2. شريط التحكم في القطر (Radius)
    Tab:CreateSlider({
        Name = "قطر السحب (Radius)",
        Range = {10, 500},
        Increment = 10,
        CurrentValue = 50,
        Callback = function(Value)
            _G.BlackHoleRadius = Value
        end,
    })

    -- المحرك البرمجي للثقب الأسود
    task.spawn(function()
        while task.wait(0.1) do
            if _G.BlackHoleEnabled then
                pcall(function()
                    local char = game.Players.LocalPlayer.Character
                    local root = char and char:FindFirstChild("HumanoidRootPart")
                    
                    if root then
                        for _, part in pairs(game.Workspace:GetDescendants()) do
                            -- التأكد أن الشيء هو قطعة قابلة للتحريك وليس جزءاً من جسمك
                            if part:IsA("BasePart") and not part.Anchored and not part:IsDescendantOf(char) then
                                local distance = (root.Position - part.Position).Magnitude
                                
                                if distance <= _G.BlackHoleRadius then
                                    -- جعل القطعة تطير باتجاهك
                                    part.Velocity = (root.Position - part.Position).Unit * _G.BlackHolePower
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    local Section2 = Tab:CreateSection("إضافات التخريب (Troll)")

    -- 3. زر حذف الأشياء المسحوبة (لتنظيف المكان)
    Tab:CreateButton({
        Name = "رمي الأشياء بعيداً! 🚀",
        Callback = function()
            _G.BlackHolePower = 300 -- رفع القوة فجأة
            task.wait(0.5)
            _G.BlackHolePower = 50 -- إعادتها للطبيعي
        end,
    })
end
