return function(Window)
    local Tab = Window:CreateTab("👥 اللاعبين", 4483345998)
    local Section = Tab:CreateSection("🚀 انتقال سريع (بدون أخطاء)")

    -- 1. مربع نصي لكتابة الاسم (أو جزء منه)
    Tab:CreateInput({
        Name = "🎯 اكتب اسم اللاعب (أو جزء منه)",
        PlaceholderText = "مثلاً: Arwa",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            _G.TargetName = Text
        end,
    })

    -- 2. زر الانتقال اليدوي
    Tab:CreateButton({
        Name = "⚡ انتقال الآن!",
        Callback = function()
            local targetInput = _G.TargetName
            
            if not targetInput or targetInput == "" then
                Rayfield:Notify({Title = "⚠️ تنبيه", Content = "يرجى كتابة اسم في المربع أولاً!", Duration = 3})
                return
            end

            local success, err = pcall(function()
                local foundPlayer = nil
                -- البحث عن اللاعب بالاسم التقريبي
                for _, p in pairs(game.Players:GetPlayers()) do
                    if p ~= game.Players.LocalPlayer then
                        if string.find(p.Name:lower(), targetInput:lower()) or string.find(p.DisplayName:lower(), targetInput:lower()) then
                            foundPlayer = p
                            break
                        end
                    end
                end

                if foundPlayer and foundPlayer.Character and foundPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local localChar = game.Players.LocalPlayer.Character
                    if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                        -- الانتقال
                        localChar.HumanoidRootPart.CFrame = foundPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        
                        Rayfield:Notify({
                            Title = "✅ تم الوصول",
                            Content = "أنت الآن عند: " .. foundPlayer.DisplayName,
                            Duration = 3
                        })
                    end
                else
                    Rayfield:Notify({Title = "❌ خطأ", Content = "لم يتم العثور على لاعب بهذا الاسم", Duration = 3})
                end
            end)

            if not success then
                warn("Error: " .. err)
            end
        end,
    })

    -- =========================================
    -- قسم كشف الأماكن (ESP)
    -- =========================================
    local ESPSection = Tab:CreateSection("👁️ كشف الأماكن")
    _G.ESPEnabled = false

    Tab:CreateToggle({
        Name = "🟢 تشغيل ESP",
        CurrentValue = false,
        Callback = function(Value)
            _G.ESPEnabled = Value
        end,
    })

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
