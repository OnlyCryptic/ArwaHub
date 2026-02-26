local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Arwa Hub - V5",
   LoadingTitle = "Arwa Hub",
   LoadingSubtitle = "بواسطة Arwa Roger",
   ConfigurationSaving = {
      Enabled = true,
      Folder = "ArwaHubConfig",
      FileName = "MainConfig"
   },
   KeySystem = false
})

-- تحميل ملف الخانة من GitHub
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()
loadPlayerTab(Window)

Rayfield:Notify({
   Title = "تم التحديث لـ V5",
   Content = "تم تفعيل نظام السرعة الجديد وحذف الزر العائم",
   Duration = 5,
   Image = 4483345998,
})
