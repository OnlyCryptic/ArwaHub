return function(Window)
    local Tab = Window:CreateTab("👥 اللاعبين", 4483345998)
    local Section = Tab:CreateSection("🚀 انتقال بالاسم (النسخة المستقرة)")

    -- متغير لحفظ النص المكتوب
    local targetInput = ""

    -- 1. مربع كتابة الاسم (البحث التقريبي)
    Tab:CreateInput({
        Name = "🎯 اكتب اسم اللاعب (أو جزء منه)",
        PlaceholderText = "مثلاً: Arwa",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            targetInput = Text
        end,
    })

    -- 2. زر الانتقال اليدوي مع إيموجي ⚡
    Tab:CreateButton({
        Name = "⚡ انتقال فوري!",
        Callback = function()
            if targetInput == "" then
                Rayfield:Notify({Title = "⚠️ تنبيه", Content = "اكتبي اسم اللاعب أولاً!", Duration = 3})
                return
            end

            local found = false
            local searchName = targetInput:lower()

            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    -- البحث في اسم المستخدم والاسم المستعار
                    if string.find(player.Name:lower(), searchName) or string.find(player.DisplayName:lower(), searchName) then
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                            
                            Rayfield:Notify({
                                Title = "✅ تم الانتقال",
                                Content = "وصلتِ عند: " .. player.DisplayName,
                                Duration = 3
                            })
                            found = true
                            break
                        end
                    end
                end
            end

            if not found then
                Rayfield:Notify({Title = "❌ خطأ", Content = "لم أجد لاعباً بهذا الاسم!", Duration = 3})
            end
        end,
    })

    -- =========================================
    -- قسم كشف الأماكن (ESP) مع إيموجي 👁️
    -- =========================================
    local ESPSection = Tab:CreateSection("👁️ كشف الأماكن")
    _G.ESPEnabled = false

    Tab:CreateToggle({
        Name = "🟢 تشغيل كاشف اللاعبين (ESP)",
        CurrentValue = false,
        Callback = function(Value)
            _G.ESPEnabled = Value
        end,
    })

    -- حلقة الـ ESP
    task.spawn(function()
        while task.wait(1) do
            if _G.ESPEnabled then
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and player.Character then
                        if not player.Character:FindFirstChild("ArwaESP") then
                            local highlight = Instance.new("Highlight")
                            highlight.Name = "ArwaESP"
                            highlight.Parent = player.Character
                            highlight.FillColor = Color3.fromRGB(0, 255, 150)
                            highlight.FillTransparency = 0.5
                        end
                    end
                end
            else
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("ArwaESP") then
                        player.Character.ArwaESP:Destroy()
                    end
                end
            end
        end
    end)
end
