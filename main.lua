-- 1. استدعاء مكتبة Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- 2. إنشاء النافذة الرئيسية
local Window = Library.CreateLib("Arwa Roger Hub", "Synapse")

-- 3. استدعاء ملف خانة اللاعب من حسابك في جيتهاب
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()

-- 4. تشغيل الخانة وربطها بالنافذة
loadPlayerTab(Window)
