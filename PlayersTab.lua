return function(Window)
    local Tab = Window:CreateTab("👥 اللاعبين", 4483345998)
    
    -- =========================================
    -- قسم الانتقال الاحترافي (Teleport System)
    -- =========================================
    local TPSection = Tab:CreateSection("🚀 نظام الانتقال السلس")

    local selectedPlayerName = nil

    -- دالة جلب قائمة الأسماء بتنسيق احترافي
    local function getPlayerList()
        local names = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(names, player.DisplayName .. " (@" .. player.Name .. ")")
            end
        end
        return names
    end

    -- 1. القائمة المنسدلة (تتحدث تلقائياً)
    local PlayerDropdown = Tab:CreateDropdown({
        Name = "👤 اختر لاعب من القائمة",
        Options = getPlayerList(),
        CurrentOption = "",
        Flag = "TargetPlayer",
        Callback = function(Option)
            selectedPlayerName = string.match(Option, "@(%w+)")
        end,
    })

    -- 2. المحرك الذكي للتحديث التلقائي (Join/Leave)
    game.Players.PlayerAdded:Connect(function()
        PlayerDropdown:Refresh(getPlayerList(), true)
    end)

    game.Players.PlayerRemoving:Connect(function()
        PlayerDropdown:Refresh(getPlayerList(), true)
    end)

    -- 3. زر الانتقال اليدوي مع إيموجي
    Tab:CreateButton({
        Name = "⚡ انتقال الآن!",
        Callback = function()
            if selectedPlayerName then
                local target = game.Players:FindFirstChild(selectedPlayerName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    
                    Rayfield:Notify({
                        Title = "✅ تم الوصول!",
                        Content = "أنت الآن بجانب " .. target.DisplayName,
                        Duration = 3,
                        Image = 4483345998,
                    })
                else
                    Rayfield:Notify({Title = "❌ خطأ", Content = "اللاعب غير موجود حالياً", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "⚠️ تنبيه", Content = "اختار ضحيتك.. قصدي لاعب أولاً! 😂", Duration = 3})
            end
        end,
    })

    -- =========================================
    -- قسم كشف الأماكن (ESP)
    -- =========================================
    local ESPSection = Tab:CreateSection("🛡️ أدوات الكشف")
    _G.ESPEnabled = false

    Tab:CreateToggle({
        Name = "👁️ تشغيل كاشف الأماكن (ESP)",
        CurrentValue = false,
        Callback = function(Value)
            _G.ESPEnabled = Value
        end,
    })

    -- حلقة الـ ESP المحسنة
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
