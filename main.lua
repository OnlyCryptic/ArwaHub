-- 1. استدعاء مكتبة الواجهة
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- 2. إنشاء النافذة الرئيسية
local Window = OrionLib:MakeWindow({Name = "Arwa Roger Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "ArwaHub"})

-- 3. استدعاء ملف خانة اللاعب من حسابك
local loadPlayerTab = loadstring(game:HttpGet("https://raw.githubusercontent.com/OnlyCryptic/ArwaHub/main/PlayerTab.lua"))()

-- 4. تشغيل خانة اللاعب وربطها بالنافذة الرئيسية
loadPlayerTab(Window)

-- 5. إنهاء إعداد الواجهة لتظهر في اللعبة
OrionLib:Init()

