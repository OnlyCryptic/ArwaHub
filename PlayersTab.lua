return function(Window)
    local Tab = Window:CreateTab("👥 اللاعبين", 4483345998)
    local Section = Tab:CreateSection("🚀 نظام الانتقال الاحترافي")

    -- متغير لحفظ اللاعب المختار (نستخدم اسم المستخدم الحقيقي لضمان الدقة)
    _G.SelectedTarget = nil

    -- دالة جلب الأسماء بشكل منسق (Emoji + Display Name + Username)
    local function getNames()
        local list = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                -- نضع علامة @ قبل اسم المستخدم لنعرفه برمجياً لاحقاً
                table.insert(list, "👤 " .. p.DisplayName .. " (@" .. p.Name .. ")")
            end
        end
        return list
    end

    -- 1. القائمة المنسدلة (Dropdown) مع إصلاح مشكلة الاختفاء
    local PlayerDropdown = Tab:CreateDropdown({
        Name = "🎯 اختر اللاعب المستهدف",
        Options = getNames(),
        CurrentOption = "",
        Flag = "TargetDropdown",
        Callback = function(Option)
            -- استخراج اسم المستخدم بدقة من بين الأقواس
            local username = string.match(Option, "@([%w_%.]+)")
            if username then
                _G.SelectedTarget = username
                print("تم اختيار اللاعب: " .. _G.SelectedTarget) -- للتأكد في الكونسول
            end
        end,
    })

    -- 2. زر الانتقال (Teleport) مع كود انتقال "قوي"
    Tab:CreateButton({
        Name = "⚡ انتقال فوري للاعب!",
        Callback = function()
            if _G.SelectedTarget then
                local targetPlayer = game.Players:FindFirstChild(_G.SelectedTarget)
                local localPlayer = game.Players.LocalPlayer
                
                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- كود الانتقال المباشر
                        localPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
                        
                        Rayfield:Notify({
                            Title = "✅ نجح الانتقال",
                            Content = "أنت الآن بجانب: " .. targetPlayer.DisplayName,
                            Duration = 3,
                            Image = 4483345998
                        })
                    end
                else
                    Rayfield:Notify({Title = "❌ خطأ", Content = "تعذر العثور على شخصية اللاعب!", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "⚠️ تنبيه", Content = "الرجاء اختيار لاعب من القائمة أولاً!", Duration = 3})
            end
        end,
    })

    -- 3. أزرار التحكم في القائمة (إيموجي + وظائف)
    Tab:CreateButton({
        Name = "🔄 تحديث يدوي للقائمة",
        Callback = function()
            PlayerDropdown:Refresh(getNames(), true)
            Rayfield:Notify({Title = "تحديث", Content = "تم تحديث قائمة اللاعبين بنجاح", Duration = 2})
        end,
    })

    -- التحديث التلقائي عند دخول/خروج لاعب
    game.Players.PlayerAdded:Connect(function() PlayerDropdown:Refresh(getNames(), true) end)
    game.Players.PlayerRemoving:Connect(function() PlayerDropdown:Refresh(getNames(), true) end)

    -- =========================================
    -- قسم كشف الأماكن (ESP)
    -- =========================================
    local ESPSection = Tab:CreateSection("👁️ أدوات الرؤية")
    _G.ESPEnabled = false

    Tab:CreateToggle({
        Name = "🟢 تشغيل كاشف اللاعبين (ESP)",
        CurrentValue = false,
        Callback = function(Value)
            _G.ESPEnabled = Value
        end,
    })

    -- حلقة الـ ESP (High Quality)
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
                            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                            highlight.FillTransparency = 0.4
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
