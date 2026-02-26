return function(Window)
    local Tab = Window:CreateTab("اللاعبين الآخرين", 4483345998)
    local Section = Tab:CreateSection("كشف الأماكن (ESP)")

    -- متغيرات الـ ESP
    _G.ESPEnabled = false

    -- زر تفعيل الـ ESP
    Tab:CreateToggle({
        Name = "تفعيل كشف الأماكن (Box ESP)",
        CurrentValue = false,
        Flag = "ESPToggle",
        Callback = function(Value)
            _G.ESPEnabled = Value
        end,
    })

    -- حلقة الـ ESP (تستخدم Highlights لمظهر احترافي)
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
                            highlight.FillTransparency = 0.5
                        end
                    end
                end
            else
                -- مسح الـ ESP عند الإغلاق
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player.Character and player.Character:FindFirstChild("ArwaESP") then
                        player.Character.ArwaESP:Destroy()
                    end
                end
            end
        end
    end)

    local Section2 = Tab:CreateSection("الانتقال (Teleport)")

    -- نظام الانتقال بالاسم التقريبي
    Tab:CreateInput({
        Name = "انتقال للاعب (اكتب جزء من اسمه)",
        PlaceholderText = "مثلاً: Arwa...",
        RemoveTextAfterFocusLost = true,
        Callback = function(Text)
            local targetName = Text:lower()
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and (string.find(player.Name:lower(), targetName) or string.find(player.DisplayName:lower(), targetName)) then
                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                        
                        -- إشعار بنجاح الانتقال
                        game:GetService("StarterGui"):SetCore("SendNotification", {
                            Title = "تم الانتقال!",
                            Text = "أنت الآن عند: " .. player.DisplayName,
                            Duration = 3
                        })
                        break
                    end
                end
            end
        end,
    })
end

