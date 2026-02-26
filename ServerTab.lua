return function(Window)
    local Tab = Window:CreateTab("🌐 السيرفر", 4483345998)
    
    -- =========================================
    -- قسم الانتقال بواسطة الكود (Join by ID)
    -- =========================================
    local SectionID = Tab:CreateSection("🔑 الدخول بواسطة الكود")

    local inputJobID = ""

    -- 1. مربع نص لصق الكود (هنا تضعين الـ ID)
    Tab:CreateInput({
        Name = "صق كود السيرفر (Job ID) هنا",
        PlaceholderText = "e1d16acf-...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            inputJobID = Text
        end,
    })

    -- 2. زر التنفيذ للانتقال للسيرفر المطلوب
    Tab:CreateButton({
        Name = "🚀 انتقال للسيرفر الآن!",
        Callback = function()
            if inputJobID ~= "" then
                local ts = game:GetService("TeleportService")
                -- يحاول الانتقال للسيرفر باستخدام الكود الذي وضعتِه
                local success, err = pcall(function()
                    ts:TeleportToPlaceInstance(game.PlaceId, inputJobID, game.Players.LocalPlayer)
                end)
                
                if not success then
                    Rayfield:Notify({Title = "خطأ", Content = "الكود غير صحيح أو السيرفر ممتلئ", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "تنبيه", Content = "الرجاء لصق الكود أولاً", Duration = 3})
            end
        end,
    })

    -- =========================================
    -- بقية العمليات السابقة (Rejoin, Hop, etc.)
    -- =========================================
    local Section1 = Tab:CreateSection("🛠️ عمليات السيرفر")

    Tab:CreateButton({
        Name = "🔄 إعادة دخول السيرفر (Rejoin)",
        Callback = function()
            local ts = game:GetService("TeleportService")
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
        end,
    })

    Tab:CreateButton({
        Name = "🆔 نسخ كود سيرفري الحالي",
        Callback = function()
            setclipboard(game.JobId)
            Rayfield:Notify({Title = "تم النسخ!", Content = "انسخي الكود وأرسليه لأصدقائك", Duration = 3})
        end,
    })

    local Section2 = Tab:CreateSection("📊 معلومات الأداء")
    local PingLabel = Tab:CreateLabel("📶 الـ Ping: جاري الحساب...")
    
    task.spawn(function()
        while task.wait(1) do
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            PingLabel:Set("📶 الـ Ping: " .. ping)
        end
    end)
end
