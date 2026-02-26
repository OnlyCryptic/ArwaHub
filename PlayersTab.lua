return function(Window)
    local Tab = Window:CreateTab("اللاعبين الآخرين", 4483345998)
    
    -- =========================================
    -- قسم الانتقال الاحترافي (Teleport System)
    -- =========================================
    local TPSection = Tab:CreateSection("نظام الانتقال الذكي")

    local selectedPlayerName = nil
    local allPlayerNames = {}

    -- دالة لتحديث قائمة الأسماء
    local function updatePlayerList()
        allPlayerNames = {}
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                table.insert(allPlayerNames, player.DisplayName .. " (@" .. player.Name .. ")")
            end
        end
        return allPlayerNames
    end

    -- 1. قائمة اللاعبين (Dropdown)
    local PlayerDropdown = Tab:CreateDropdown({
        Name = "اختر اللاعب من القائمة",
        Options = updatePlayerList(),
        CurrentOption = "",
        Flag = "SelectedPlayer",
        Callback = function(Option)
            -- استخراج اسم المستخدم الحقيقي من بين الأقواس
            selectedPlayerName = string.match(Option, "@(%w+)")
        end,
    })

    -- 2. خانة البحث والتصفية (Search Box)
    Tab:CreateInput({
        Name = "بحث عن لاعب (فلترة القائمة)",
        PlaceholderText = "اكتب حرفاً للبحث...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            local search = Text:lower()
            local filteredList = {}
            for _, name in pairs(updatePlayerList()) do
                if string.find(name:lower(), search) then
                    table.insert(filteredList, name)
                end
            end
            -- تحديث القائمة فوراً بناءً على البحث
            PlayerDropdown:Refresh(filteredList, true)
        end,
    })

    -- 3. زر تحديث القائمة (Refresh)
    Tab:CreateButton({
        Name = "تحديث قائمة اللاعبين 🔄",
        Callback = function()
            PlayerDropdown:Refresh(updatePlayerList(), true)
        end,
    })

    -- 4. زر الانتقال (Teleport) - يدوي وغير تلقائي
    Tab:CreateButton({
        Name = "انتقال إلى اللاعب المختار 🚀",
        Callback = function()
            if selectedPlayerName then
                local target = game.Players:FindFirstChild(selectedPlayerName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    
                    Rayfield:Notify({
                        Title = "تم الانتقال!",
                        Content = "أنت الآن عند " .. target.DisplayName,
                        Duration = 3,
                        Image = 4483345998,
                    })
                else
                    Rayfield:Notify({Title = "خطأ", Content = "تعذر العثور على الشخصية", Duration = 3})
                end
            else
                Rayfield:Notify({Title = "تنبيه", Content = "الرجاء اختيار لاعب أولاً", Duration = 3})
            end
        end,
    })

    -- =========================================
    -- قسم كشف الأماكن (ESP)
    -- =========================================
    local ESPSection = Tab:CreateSection("كشف الأماكن (ESP)")
    _G.ESPEnabled = false

    Tab:CreateToggle({
        Name = "تفعيل Box ESP",
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
