-- 1. استدعاء مكتبة Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- 2. إنشاء النافذة الرئيسية
local Window = Rayfield:CreateWindow({
   Name = "Arwa Hub - Auto Loader",
   LoadingTitle = "Arwa Hub",
   LoadingSubtitle = "بواسطة Arwa Roger",
   ConfigurationSaving = { Enabled = true, Folder = "ArwaHubConfig", FileName = "MainConfig" },
   KeySystem = false
})

-- 3. المحرك الذكي: جلب قائمة الملفات من GitHub API
local HttpService = game:GetService("HttpService")
local repoOwner = "OnlyCryptic"
local repoName = "ArwaHub"
local apiUrl = "https://api.github.com/repos/" .. repoOwner .. "/" .. repoName .. "/contents/"

local success, response = pcall(function()
    return game:HttpGet(apiUrl)
end)

if success then
    local files = HttpService:JSONDecode(response)
    for _, file in pairs(files) do
        -- شرطنا الذكي: أي ملف ينتهي بـ "Tab.lua" سيتم تحميله فوراً
        if file.name:match("Tab%.lua$") then
            local rawUrl = "https://raw.githubusercontent.com/" .. repoOwner .. "/" .. repoName .. "/main/" .. file.name
            local loadTab = loadstring(game:HttpGet(rawUrl))()
            
            -- تشغيل الملف وربطه بالواجهة
            local tabSuccess, err = pcall(function()
                loadTab(Window)
            end)
            
            if not tabSuccess then
                warn("خطأ في تحميل الملف: " .. file.name .. " | " .. err)
            end
        end
    end
else
    Rayfield:Notify({Title = "خطأ!", Content = "لم يتمكن السكربت من الاتصال بـ GitHub API", Duration = 5})
end

Rayfield:Notify({Title = "تم التحديث!", Content = "تم تحميل جميع الخانات تلقائياً بنجاح", Duration = 5})
