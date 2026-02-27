return function(Window)
    local Tab = Window:CreateTab("💣 Pass or Die", 4483345998)
    local Section = Tab:CreateSection("نظام التمرير عبر الأسهم")

    _G.AutoArrowPass = false

    -- 1. زر تفعيل التمرير التلقائي للأسهم
    Tab:CreateToggle({
        Name = "ضغط الأسهم تلقائياً (Auto Click Arrows)",
        CurrentValue = false,
        Callback = function(Value)
            _G.AutoArrowPass = Value
            if Value then
                Rayfield:Notify({Title = "تم التفعيل", Content = "سيتم ضغط سهم التمرير فور ظهوره! ⚡", Duration = 3})
            end
        end,
    })

    -- المحرك البرمجي الذي يراقب الشاشة (PlayerGui)
    task.spawn(function()
        while task.wait(0.1) do -- فحص سريع جداً لمواكبة اللعبة
            if _G.AutoArrowPass then
                pcall(function()
                    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                    
                    -- البحث داخل كل واجهات المستخدم المفعلة
                    for _, gui in pairs(playerGui:GetChildren()) do
                        if gui:IsA("ScreenGui") and gui.Enabled then
                            -- البحث عن الأزرار التي قد تمثل الأسهم
                            for _, element in pairs(gui:GetDescendants()) do
                                if element:IsA("ImageButton") or element:IsA("TextButton") then
                                    -- البحث عن كلمات دليلة مثل Arrow أو Pass أو اتجاهات
                                    local name = element.Name:lower()
                                    if string.find(name, "arrow") or string.find(name, "pass") or string.find(name, "button") then
                                        -- إذا كان الزر مرئياً في وسط الشاشة (مكان ظهور الأسهم)
                                        if element.Visible and element.AbsoluteSize.X > 0 then
                                            -- محاكاة الضغط (استخدام Activated هو الأكثر أماناً)
                                            -- ملاحظة: قد نحتاج لاستخدام VirtualInputService إذا كانت الأزرار معقدة
                                            local events = {"MouseButton1Click", "Activated", "MouseButton1Down"}
                                            for _, event in pairs(events) do
                                                if element[event] then
                                                    -- استدعاء الوظيفة المرتبطة بالزر
                                                    for _, connection in pairs(getconnections(element[event])) do
                                                        connection:Fire()
                                                    end
                                                end
                                            end
                                        end
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
