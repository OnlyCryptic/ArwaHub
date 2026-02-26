return function(Window)
    local Tab = Window:CreateTab("👥 اللاعبين", 4483345998)
    local Section = Tab:CreateSection("🚀 نظام الانتقال (نسخة مستقرة)")

    -- دالة جلب الأسماء
    local function getPlayerNames()
        local list = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= game.Players.LocalPlayer then
                table.insert(list, p.Name) -- نستخدم اسم المستخدم المباشر فقط لسهولة البرمجة
            end
        end
        return list
    end

    -- 1. القائمة المنسدلة (Dropdown)
    local SelectedPlayer = ""
    local PlayerDropdown = Tab:CreateDropdown({
        Name = "🎯 اختر اسم اللاعب",
        Options = getPlayerNames(),
        CurrentOption = "",
        Flag = "TargetDrop", 
        Callback = function(Option)
            SelectedPlayer = Option
        end,
    })

    -- 2. زر الانتقال (Teleport) مع حماية مضاعفة
    Tab:CreateButton({
        Name = "⚡ انتقال الآن!",
        Callback = function()
            -- التأكد أن هناك اسم تم اختياره
            if SelectedPlayer == "" or SelectedPlayer == nil then
                Rayfield:Notify({Title = "⚠️ تنبيه", Content = "يرجى اختيار لاعب أولاً!", Duration = 3})
                return
            end

            -- البحث عن اللاعب
            local target = game.Players:FindFirstChild(SelectedPlayer)
            
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local localChar = game.Players.LocalPlayer.Character
                if localChar and localChar:FindFirstChild("HumanoidRootPart") then
                    -- عملية الانتقال
                    localChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                    
                    Rayfield:Notify({
                        Title = "✅ نجح الانتقال",
                        Content = "أنت الآن عند " .. target.Name,
                        Duration = 3
                    })
                end
            else
                Rayfield:Notify({Title = "❌ خطأ", Content = "تعذر العثور على اللاعب، جرب تحديث القائمة", Duration = 3})
            end
        end,
    })

    -- 3. زر التحديث (لحل مشكلة اختفاء الأسماء)
    Tab:CreateButton({
        Name = "🔄 تحديث القائمة (Refresh)",
        Callback = function()
            PlayerDropdown:Refresh(getPlayerNames(), true)
            Rayfield:Notify({Title = "تحديث", Content = "تم تحديث الأسماء بنجاح", Duration = 2})
        end,
    })

    -- تحديث تلقائي بسيط
    game.Players.PlayerAdded:Connect(function() PlayerDropdown:Refresh(getPlayerNames(), true) end)
    game.Players.PlayerRemoving:Connect(function() PlayerDropdown:Refresh(getPlayerNames(), true) end)

    -- =========================================
    -- قسم كشف الأماكن (ESP)
    -- =========================================
    local ESPSection = Tab:CreateSection("👁️ أدوات الكشف")
    _G.ESPEnabled = false

    Tab:CreateToggle({
        Name = "🟢 تشغيل كاشف اللاعبين (ESP)",
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
