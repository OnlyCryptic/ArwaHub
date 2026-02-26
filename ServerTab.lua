return function(Window)
    local Tab = Window:CreateTab("🌐 السيرفر", 4483345998)
    
    -- =========================================
    -- قسم عمليات السيرفر (Server Actions)
    -- =========================================
    local Section1 = Tab:CreateSection("🛠️ عمليات السيرفر")

    -- 1. زر إعادة الدخول (Rejoin)
    Tab:CreateButton({
        Name = "🔄 إعادة دخول السيرفر (Rejoin)",
        Callback = function()
            local ts = game:GetService("TeleportService")
            local p = game:GetService("Players").LocalPlayer
            ts:TeleportToPlaceInstance(game.PlaceId, game.JobId, p)
        end,
    })

    -- 2. زر البحث عن سيرفر جديد (Server Hop)
    Tab:CreateButton({
        Name = "🚀 سيرفر عشوائي (Server Hop)",
        Callback = function()
            local Http = game:GetService("HttpService")
            local Tps = game:GetService("TeleportService")
            local Api = "https://games.roblox.com/v1/games/"
            local _place = game.PlaceId
            local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
            
            local function ListServers(cursor)
                local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
                return Http:JSONDecode(Raw)
            end

            local Server = ListServers()
            if Server.data then
                for _, v in pairs(Server.data) do
                    if v.playing < v.maxPlayers and v.id ~= game.JobId then
                        Tps:TeleportToPlaceInstance(_place, v.id, game.Players.LocalPlayer)
                        break
                    end
                end
            end
        end,
    })

    -- 3. زر نسخ معرف السيرفر (Copy Job ID)
    Tab:CreateButton({
        Name = "🆔 نسخ كود السيرفر (Job ID)",
        Callback = function()
            setclipboard(game.JobId)
            Rayfield:Notify({Title = "تم النسخ!", Content = "تم نسخ كود السيرفر إلى الحافظة", Duration = 3})
        end,
    })

    -- =========================================
    -- قسم الأدوات (Utilities)
    -- =========================================
    local Section2 = Tab:CreateSection("⚙️ أدوات مساعدة")

    -- 4. مانع الطرد للخمول (Anti-AFK)
    local AntiAFKEnabled = false
    Tab:CreateToggle({
        Name = "💤 منع الطرد للخمول (Anti-AFK)",
        CurrentValue = false,
        Callback = function(Value)
            AntiAFKEnabled = Value
            if Value then
                Rayfield:Notify({Title = "Anti-AFK", Content = "تم التفعيل بنجاح!", Duration = 3})
            end
        end,
    })

    -- كود الـ Anti-AFK البرمجي
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        if AntiAFKEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)

    -- =========================================
    -- قسم المعلومات (Server Info)
    -- =========================================
    local Section3 = Tab:CreateSection("📊 معلومات الأداء")

    local PingLabel = Tab:CreateLabel("📶 الـ Ping: جاري الحساب...")
    local FPSLabel = Tab:CreateLabel("🖥️ الـ FPS: جاري الحساب...")
    local PlayersLabel = Tab:CreateLabel("👥 عدد اللاعبين: " .. #game.Players:GetPlayers())

    -- حلقة تحديث المعلومات تلقائياً
    task.spawn(function()
        while task.wait(1) do
            -- تحديث البينج
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            PingLabel:Set("📶 الـ Ping: " .. ping)
            
            -- تحديث عدد اللاعبين
            PlayersLabel:Set("👥 عدد اللاعبين: " .. #game.Players:GetPlayers())
            
            -- تحديث الوقت (Server Time)
            local time = os.date("%X")
            -- يمكنك إضافة Label للوقت هنا إذا أردتِ
        end
    end)
end
