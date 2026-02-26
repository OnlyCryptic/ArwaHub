return function(Window)
    local Tab = Window:CreateTab("👥 اللاعبين", 4483345998)
    local Section = Tab:CreateSection("🚀 نظام الانتقال المحمي")

    -- متغير عالمي لحفظ الهدف
    _G.SelectedTarget = nil

    -- دالة جلب الأسماء (تم تحسينها لتكون أكثر استقراراً)
    local function getNames()
        local list = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                -- نستخدم تنسيقاً بسيطاً لضمان عدم حدوث خطأ في استخراج الاسم
                table.insert(list, p.DisplayName .. " (@" .. p.Name .. ")")
            end
        end
        return list
    end

    -- 1. القائمة المنسدلة
    local PlayerDropdown = Tab:CreateDropdown({
        Name = "🎯 اختر اللاعب",
        Options = getNames(),
        CurrentOption = "",
        Flag = "TargetDropdown",
        Callback = function(Option)
            -- محاولة استخراج الاسم بطريقة أكثر مرونة
            local username = string.match(Option, "@([%w_]+)")
            if username then
                _G.SelectedTarget = username
            end
        end,
    })

    -- 2. زر الانتقال (بنظام الحماية من الأخطاء)
    Tab:CreateButton({
        Name = "⚡ انتقال آمن",
        Callback = function()
            -- استخدام pcall لمنع ظهور Callback Error المزعج
            local success, err = pcall(function()
                if not _G.SelectedTarget then
                    Rayfield:Notify({Title = "⚠️ تنبيه", Content = "الرجاء اختيار لاعب أولاً!", Duration = 3})
                    return
                end

                local targetPlayer = game.Players:FindFirstChild(_G.SelectedTarget)
                local localPlayer = game.Players.LocalPlayer

                if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        -- تنفيذ الانتقال
                        local targetPos = targetPlayer.Character.HumanoidRootPart.CFrame
                        localPlayer.Character.HumanoidRootPart.CFrame = targetPos * CFrame.new(0, 3, 0)
                        
                        Rayfield:Notify({
                            Title = "✅ نجح الانتقال",
                            Content = "أنت الآن عند " .. targetPlayer.DisplayName,
                            Duration = 3,
                            Image = 4483345998
                        })
                    else
                        Rayfield:Notify({Title = "❌ خطأ", Content = "شخصيتك غير موجودة!", Duration = 3})
                    end
                else
                    Rayfield:Notify({Title = "❌ خطأ", Content = "لاعب غير موجود أو ميت!", Duration = 3})
                end
            end)

            -- إذا فشل الكود لأي سبب تقني، سيظهر لك السبب هنا بدلاً من تعليق السكربت
            if not success then
                warn("حدث خطأ في الانتقال: " .. err)
                Rayfield:Notify({Title = "⚠️ خطأ برمجبي", Content = "تعذر الانتقال، حاول اختيار الاسم مجدداً", Duration = 3})
            end
        end,
    })

    -- 3. أزرار التحكم
    Tab:CreateButton({
        Name = "🔄 تحديث الأسماء",
        Callback = function()
            PlayerDropdown:Refresh(getNames(), true)
        end,
    })

    -- التحديث التلقائي
    game.Players.PlayerAdded:Connect(function() PlayerDropdown:Refresh(getNames(), true) end)
    game.Players.PlayerRemoving:Connect(function() PlayerDropdown:Refresh(getNames(), true) end)

    -- =========================================
    -- قسم الـ ESP
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
