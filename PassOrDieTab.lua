return function(Window)
    local Tab = Window:CreateTab("💣 Pass or Die", 4483345998)
    local Section = Tab:CreateSection("صائد الأكواد والأسهم")

    -- إعدادات الويب هوك (مع البروكسي)
    local webhookURL = "https://hooks.hyra.io/api/webhooks/1476744644183199834/w8CnCw7ehZom4b0MXkb0L4bCd9fy0sQs7LX4HZb4JfFUrqPqykwagx3hybF0UaY8ATr2"
    
    local function sendToDiscord(btnName, guiName, extraInfo)
        local HttpService = game:GetService("HttpService")
        local data = {
            ["embeds"] = {{
                ["title"] = "🎯 تم اصطياد زر تمرير!",
                ["color"] = 16711680, -- لون أحمر
                ["fields"] = {
                    {["name"] = "🔘 اسم الزر", ["value"] = btnName, ["inline"] = true},
                    {["name"] = "📂 الملف (Gui)", ["value"] = guiName, ["inline"] = true},
                    {["name"] = "🔍 بيانات إضافية", ["value"] = extraInfo or "لا يوجد", ["inline"] = false},
                },
                ["footer"] = {["text"] = "Arwa Debugger Mode"},
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
        }
        pcall(function()
            HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data))
        end)
    end

    _G.CaptureMode = false

    -- 1. زر تفعيل الصياد
    Tab:CreateToggle({
        Name = "تفعيل صائد الملفات (Capture Mode)",
        CurrentValue = false,
        Callback = function(Value)
            _G.CaptureMode = Value
            if Value then
                Rayfield:Notify({Title = "وضع الصياد", Content = "سيتم إرسال أي زر تضغطينه إلى الديسكورد فوراً!", Duration = 3})
            end
        end,
    })

    -- المحرك البرمجي لمراقبة الأزرار وإرسال بياناتها
    task.spawn(function()
        while task.wait(0.1) do
            if _G.CaptureMode then
                pcall(function()
                    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                    
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and gui.Enabled then
                            for _, btn in pairs(gui:GetDescendants()) do
                                -- إذا كان الزر ظاهراً (الأسهم التي تظهر عند استلام القنبلة)
                                if (btn:IsA("ImageButton") or btn:IsA("TextButton")) and btn.Visible and btn.AbsoluteSize.X > 0 then
                                    
                                    -- نتحقق إذا كان الزر هو أحد الأسهم (غالباً تظهر في وسط الشاشة)
                                    if string.find(btn.Name:lower(), "arrow") or string.find(btn.Name:lower(), "pass") or btn.Position.Y.Scale > 0.3 then
                                        
                                        -- إرسال البيانات للديسكورد قبل الضغط
                                        sendToDiscord(btn.Name, gui.Name, "المسار الكامل: " .. btn:GetFullName())
                                        
                                        -- تنفيذ الضغط التلقائي
                                        local events = {"MouseButton1Click", "Activated"}
                                        for _, ev in pairs(events) do
                                            for _, con in pairs(getconnections(btn[ev])) do
                                                con:Fire()
                                            end
                                        end
                                        
                                        -- تأخير بسيط لمنع تكرار الإرسال لنفس الزر
                                        task.wait(1) 
                                    end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end
