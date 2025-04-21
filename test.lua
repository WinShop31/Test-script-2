local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ContextActionService = game:GetService("ContextActionService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

local INVISIBLE_CHAR = "\u{001E}"
local NEWLINE = "\u{000D}"
local PRESET_FILE_NAME = "drawing_presets.json"
local PREMIUM_GAMEPASS_ID = 1170613566

-- Проверка премиум-статуса
local function isPremiumPlayer()
    local success, hasPass = pcall(function()
        return MarketplaceService:UserOwnsGamePassAsync(Players.LocalPlayer.UserId, PREMIUM_GAMEPASS_ID)
    end)
    return success and hasPass
end

-- Создание таблицы для хранения пресетов
local presets = {
    {name="pensil",grid={{"⬛","⬛","🔴","🔴","🔴","⬛","⬛"},{"⬛","⬛","🔴","🔴","🔴","⬛","⬛"},{"⬛","⬛","🤎","🤎","🤎","⬛","⬛"},{"⬛","⬛","🤎","🤎","🤎","⬛","⬛"},{"⬛","⬛","🤎","🤎","🤎","⬛","⬛"},{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"},{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"}}},
    {name="lover",grid={{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬛","❤️","⬜","⬛","❤️","⬜"},{"⬜","⬛","⬛","⬜","⬛","⬛","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬛","⬛","⬛","⬛","⬛","⬜"},{"⬜","⬛","⬛","⬛","⬛","⬛","⬜"},{"⬜","⬜","⬛","⬛","⬛","⬜","⬜"}}},
    {name="bad",grid={{"💚","💚","💚","💚","💚","💚","💚"},{"💚","⬛","⬛","💚","⬛","⬛","💚"},{"💚","⬛","⬛","💚","⬛","⬛","💚"},{"💚","💚","💚","💚","💚","💚","💚"},{"💚","⬛","⬛","⬛","⬛","⬛","💚"},{"💚","⬛","💚","💚","💚","⬛","💚"},{"💚","💚","💚","💚","💚","💚","💚"}}},
    {name="bee",grid={{"💛","💛","💛","💛","💛","💛","💛"},{"⬛","⬛","💛","💛","💛","⬛","⬛"},{"⬛","⬛","💛","💛","💛","⬛","⬛"},{"⬛","⬛","💛","💛","💛","⬛","⬛"},{"⬛","⬛","💛","💛","💛","⬛","⬛"},{"💛","💛","💛","💛","💛","💛","💛"},{"💛","💛","💛","💛","💛","💛","💛"}}},
    {name=":D",grid={{"⬜","⬛","⬛","⬜","⬛","⬛","⬜"},{"⬜","⬛","⬛","⬜","⬛","⬛","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬛","⬛","⬛","⬛","⬛","⬜"},{"⬜","⬛","🏮","🏮","🏮","⬛","⬜"},{"⬜","⬜","⬛","⬛","⬛","⬜","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"}}},
    {name="bee v2",grid={{"🧡","⬛","🧡","🧡","🧡","⬛","🧡"},{"🧡","🧡","🧡","🧡","🧡","🧡","🧡"},{"⬛","⬛","🧡","🧡","🧡","⬛","⬛"},{"⬛","💛","🧡","🧡","🧡","💛","⬛"},{"⬛","💛","🧡","🧡","🧡","💛","⬛"},{"⬛","⬛","🧡","🧡","🧡","⬛","⬛"},{"🧡","🧡","🧡","🧡","🧡","🧡","🧡"}}},
    {name="dxbn",grid={{"⬛","⬜","⬛","⬛","⬛","⬜","⬛"},{"⬜","⬛","⬛","⬛","⬛","⬛","⬜"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬜","⬛","🔲","⬛","🔲","⬛","⬜"},{"⬜","⬛","⬛","⬛","⬛","⬛","⬜"},{"⬛","⬜","⬛","⬛","⬛","⬜","⬛"},{"⬛","⬛","⬜","⬜","⬜","⬛","⬛"}}},
    {name="⚽",grid={{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬛","⬜","⬛","⬜","⬛","⬜","⬛"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬛","⬜","⬛","⬜","⬛","⬜","⬛"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬛","⬜","⬛","⬜","⬛","⬜","⬛"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"}}},
    {name="memer",grid={{"","","","","","",""},{"⬛","⬛","","","⬛","⬛",""},{"","","","","","",""},{"","⬛","⬛","⬛","⬛","⬛",""},{"⬛","","⬛","","⬛","","⬛"},{"⬛","","","","","","⬛"},{"","⬛","⬛","⬛","⬛","⬛",""}}},
    {name="цветок",grid={{"⬛","⬛","⬛","❤️","⬛","⬛","⬛"},{"⬛","⬛","⬛","💚","💚","⬛","⬛"},{"⬛","⬛","⬛","💚","⬛","⬛","⬛"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬛","⬛","⬜","⬜","⬜","⬛","⬛"},{"⬛","⬛","⬜","⬜","⬜","⬛","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"}}},
    {name="hi!",grid={{"⬛","⬛","⬛","⬛","⬜","⬛","⬜"},{"⬜","⬛","⬜","⬛","⬛","⬛","⬜"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬜","⬜","⬜","⬛","⬜","⬛","⬜"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬛"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name=":b",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬜","⬛","⬛"},{"⬛","⬜","⬛","⬛","⬜","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬜","⬜","⬜"},{"⬛","⬛","⬛","⬛","⬜","⬛","⬜"},{"⬛","⬜","⬛","⬛","⬜","⬜","⬜"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name="imposter",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬜","🔵","🔴","🔴","🔵","⬛"},{"⬛","🔵","🔵","🔴","🔴","🔵","🔵"},{"⬛","🔴","🔴","🔴","🔴","🔵","🔵"},{"⬛","🔴","🔴","🔴","🔴","🔵","🔵"},{"⬛","🔴","🔴","🔴","🔴","🔵","⬛"},{"⬛","🔴","🔴","🔴","🔴","⬛","⬛"}}},
    {name="skull",grid={{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬜","⬛","⬛","⬜","⬛","⬛","⬜"},{"⬜","⬛","⬛","⬜","⬛","⬛","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬜","⬜","⬛","⬜","⬜","⬜"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"}}},
    {name="poor",grid={{"⬛","⬛","⬛","🤎","⬛","⬛","⬛"},{"⬛","⬛","🤎","🤎","🤎","⬛","⬛"},{"⬛","🤎","🤎","🤎","🤎","🤎","⬛"},{"⬛","🤎","🔳","🤎","🔳","🤎","⬛"},{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"},{"🤎","⬜","⬜","⬜","⬜","⬜","🤎"},{"🤎","🤎","⬜","⬜","⬜","🤎","🤎"}}},
    {name="adolf",grid={{"📔","📔","📔","📔","📔","📔","📔"},{"📔","📔","📔","📔","📔","📔","📔"},{"📔","⬛","⬛","📔","⬛","⬛","📔"},{"📔","📔","📔","📔","📔","📔","📔"},{"📔","📔","⬛","⬛","⬛","📔","📔"},{"📔","⬛","⬛","⬛","⬛","⬛","📔"},{"📔","📔","📔","📔","📔","📔","📔"}}},
    {name="noob",grid={{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"},{"🤎","📔","📔","📔","📔","📔","🤎"},{"📔","⬜","⬛","📔","⬛","⬜","📔"},{"📔","📔","📔","📔","📔","📔","📔"},{"📔","📔","⬛","⬛","⬛","📔","📔"},{"📔","⬜","⬜","⬜","⬜","⬜","📔"},{"📔","📔","📔","📔","📔","📔","📔"}}},
    {name="yea",grid={{"⬜","⬛","⬜","⬛","⬜","⬜","⬜"},{"⬛","⬜","⬛","⬛","⬜","🔲","🔲"},{"⬜","⬛","⬛","⬛","⬜","⬜","⬜"},{"⬛","⬛","⬛","⬜","⬛","⬛","⬛"},{"⬛","⬛","⬜","⬛","⬜","⬛","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬜","⬛","⬛","⬛","⬛","⬛","⬜"}}},
    {name="oh",grid={{"⬛","⬜","⬜","⬛","🔲","⬛","🔲"},{"⬜","⬛","⬛","⬜","🔲","⬛","🔲"},{"⬜","⬛","⬛","⬜","🔲","🔲","🔲"},{"⬜","⬛","⬛","⬜","🔲","🔲","🔲"},{"⬜","⬛","⬛","⬜","🔲","⬛","🔲"},{"⬛","⬜","⬜","⬛","🔲","⬛","🔲"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name="rock",grid={{"⬛","⬜","⬛","⬛","⬛","⬜","⬛"},{"⬛","⬜","⬛","⬛","⬛","⬜","⬛"},{"⬛","⬜","⬛","⬛","⬛","⬜","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"}}},
    {name="pac green",grid={{"\31","📗","📗","⬛","📗","📗","\31"},{"📗","📗","📗","📗","📗","📗","📗"},{"📗","📗","⬜","🔳","📗","⬜","🔳"},{"📗","📗","📗","📗","📗","📗","📗"},{"📗","🏮","🏮","🏮","🏮","🏮","⬛"},{"📗","📗","📗","📗","📗","📗","⬛"},{"📗","📗","📗","📗","📗","📗","📗"}}},
    {name="fuck",grid={{"⬛","⬛","⬛","⬜","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬜","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬜","⬛","⬛","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬛","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"}}},
    {name="svastika",grid={{"📕","�15","📕","📕","📕","📕","📕"},{"📕","⬛","📕","⬛","⬛","⬛","📕"},{"📕","⬛","📕","⬛","📕","📕","📕"},{"📕","⬛","⬛","⬛","⬛","⬛","📕"},{"📕","📕","📕","⬛","📕","⬛","📕"},{"📕","⬛","⬛","⬛","📕","⬛","📕"},{"📕","📕","📕","📕","📕","📕","📕"}}},
    {name="heheh",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬜","🔳","⬛","⬜","🔳","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬜","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬜","⬜","⬜","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name="18+",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","🤎"},{"🤎","⬛","⬛","⬛","⬛","🤎","🤎"},{"🤎","🤎","🤎","🔴","⬛","🌸","🤎"},{"🤎","⬛","⬛","⬛","⬛","🤎","🤎"},{"⬛","⬛","⬛","⬛","⬛","⬛","🤎"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name="zemlya",grid={{"📘","📘","📘","📘","📒","📒","📒"},{"📘","📘","📘","📘","📘","📒","📒"},{"📘","📘","�18","📘","📘","📘","📒"},{"📘","📘","📘","📘","📘","📘","📘"},{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"},{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"},{"\31","\31","\31","\31","\31","\31","\31"}}},
    {name="🤨",grid={{"📒","📒","📒","📒","⬛","📒","📒"},{"📒","⬛","⬛","📒","📒","⬛","📒"},{"📒","📒","📒","📒","📒","📒","📒"},{"📒","⬛","⬛","📒","⬛","⬛","📒"},{"📒","📒","📒","📒","📒","📒","📒"},{"📒","⬛","⬛","⬛","⬛","⬛","📒"},{"📒","📒","📒","📒","📒","📒","📒"}}},
    {name="car",grid={{"\31","\31","\31","\31","\31","\31","\31"},{"🚦","⬛","🔵","🔴","🔴","🔴","⬛"},{"⬛","🔵","🔵","🔴","🔴","🔴","🔴"},{"🔴","🔴","🔴","🔴","🔴","🔴","🔴"},{"⬛","🔴","⬛","⬛","⬛","🔴","⬛"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"}}},
    {name="doroga",grid={{"\31","\31","\31","\31","\31","\31","\31"},{"📘","☁️","📘","🚀","📘","☁️","📘"},{"☁️","📘","☁️","☁️","📘","✈️","☁️"},{"🚦","📘","📘","📘","📘","📘","📘"},{"🚧","🚲","🚑","📘","🚒","📘","🚗"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"}}},
    {name="pac green v2",grid={{"⬛","📗","📗","⬛","📗","📗","⬛"},{"📗","📗","📗","📗","📗","📗","📗"},{"📗","📗","⬜","🔳","📗","⬜","🔳"},{"📗","📗","📗","📗","📗","📗","📗"},{"📗","🏮","🏮","🏮","🏮","🏮","⬛"},{"📗","📗","📗","📗","📗","📗","⬛"},{"\31","\31","\31","\31","\31","\31","\31"}}},
    {name="sonic",grid={{"📘","📘","📒","📘","📘","📒","📘"},{"📘","📘","📘","📘","📘","📘","📘"},{"📘","📘","⬜","📘","📘","📘","⬜"},{"📘","📘","⬜","⬛","📘","⬛","⬜"},{"📘","📘","⬜","📗","⬜","📗","⬜"},{"📘","📒","📒","📒","⬛","📒","📒"},{"📘","📘","⬛","📒","📒","📒","📘"}}},
    {name="among us face",grid={{"📕","📕","📕","📕","📕","�15","📕"},{"📕","⬛","⬛","⬛","⬛","⬛","📕"},{"📕","⬛","📘","📘","📘","⬛","📕"},{"📕","⬛","📘","📘","📘","⬛","📕"},{"📕","⬛","⬛","⬛","⬛","⬛","�15"},{"📕","�15","📕","📕","�15","�15","�15"},{"�15","�15","�15","�15","�15","�15","�15"}}},
    {name="adolf v2",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"📙","📙","📙","📙","⬛","⬛","⬛"},{"📙","⬜","⬛","📙","⬛","⬜","📙"},{"📙","📙","📙","📙","📙","📙","📙"},{"📙","📙","⬛","⬛","⬛","📙","📙"},{"📙","📙","📙","📙","📙","📙","📙"}}},
    {name="XD",grid={{"⬜","⬛","⬜","⬛","⬜","⬜","⬛"},{"⬜","⬛","⬜","⬛","⬜","⬛","⬜"},{"⬛","⬜","⬛","⬛","⬜","⬛","⬜"},{"⬛","⬜","⬛","⬛","⬜","⬛","⬜"},{"⬜","⬛","⬜","⬛","⬜","⬜","⬜"},{"⬜","⬛","⬜","⬛","⬜","⬜","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name="russia",grid={{"\31","\31","\31","\31","\31","\31","\31"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"📘","📘","📘","📘","📘","📘","📘"},{"📘","📘","�18","📘","📘","📘","📘"},{"�15","�15","�15","�15","�15","�15","�15"},{"�15","�15","�15","�15","�15","�15","�15"}}},
    {name="smile",grid={{"📔","�14","�14","�14","�14","�14","�14"},{"�14","⬜","⬛","�14","�14","⬜","⬛"},{"�14","⬛","⬛","�14","�14","⬛","⬛"},{"�14","�14","�14","�14","�14","�14","�14"},{"�14","⬛","�14","�14","�14","⬛","�14"},{"�14","⬛","⬛","⬛","⬛","⬛","�14"},{"�14","�14","⬛","⬛","⬛","�14","�14"}}},
    {name="ukraine",grid={{"📘","�18","📘","�18","📘","�18","�18"},{"�18","�18","�18","�18","�18","�18","�18"},{"�18","�18","�18","�18","�18","�18","�18"},{"�18","�18","�18","�18","�18","�18","�18"},{"📒","📒","📒","📒","📒","📒","📒"},{"📒","📒","📒","📒","📒","📒","📒"},{"📒","📒","📒","📒","📒","📒","📒"}}},
    {name="R | U",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬜","⬜","⬜","⬛","�18","�18","�18"},{"�18","�18","�18","⬛","�18","�18","�18"},{"�15","�15","�15","⬛","📒","📒","📒"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name="cow",grid={{"�15","�15","�15","⬜","⬜","⬜","�15"},{"�15","�15","�15","⬜","⬜","�15","�15"},{"⬛","⬛","�15","⬜","�15","⬛","⬛"},{"⬛","⬛","�15","�15","�15","⬛","⬛"},{"�15","�15","⬜","⬜","⬜","�15","�15"},{"�15","⬜","⬛","�14","⬛","⬜","�15"},{"�15","⬜","�14","�14","�14","⬜","�15"}}},
    {name="cow default",grid={{"🤎","🤎","🤎","⬜","⬜","⬜","🤎"},{"🤎","🤎","🤎","⬜","⬜","🤎","🤎"},{"⬜","⬜","🤎","⬜","🤎","⬜","⬜"},{"⬛","⬜","🤎","🤎","🤎","⬜","⬛"},{"🤎","🤎","⬜","⬜","⬜","🤎","🤎"},{"🤎","⬜","⬛","�14","⬛","⬜","🤎"},{"🤎","⬜","�14","�14","�14","⬜","🤎"}}},
    {name="овца",grid={{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"📙","📙","📙","📙","📙","📙","📙"},{"⬛","⬜","📙","📙","📙","⬜","⬛"},{"⬜","📙","�14","�14","�14","📙","⬜"},{"⬜","📙","�14","�14","�14","📙","⬜"},{"⬜","📙","�14","�14","�14","📙","⬜"}}},
    {name="житель",grid={{"\31","\31","\31","\31","\31","\31","\31"},{"�14","�14","�14","�14","�14","�14","�14"},{"�14","⬛","⬛","⬛","⬛","⬛","�14"},{"�14","⬜","📗","�14","📗","⬜","�14"},{"�14","�14","🤎","🤎","🤎","�14","�14"},{"�14","🍪","🤎","🤎","🤎","🍪","�14"},{"�14","�14","🤎","🤎","🤎","�14","�14 14📔","�14","🤎","🤎","🤎","📔","📔"}}},
    {name="вумен из майна",grid={{"\31","\31","\31","\31","\31","\31","\31"},{"📙","📙","📙","📙","📒","📙","📙"},{"📙","📙","📙","📒","📒","📒","📙"},{"⬜","📗","📒","📒","📒","📗","⬜"},{"📒","📒","📒","📒","📒","📒","📒"},{"📒","📒","�14","�14","�14","📒","📒"},{"📒","📒","📒","📒","📒","📒","📒"}}},
    {name="печенька",grid={{"🏈","🏈","🏈","🏈","🏈","🏈","🏈"},{"🏈","🏈","🏈","🏈","🏈","🏈","🏈"},{"⬛","⬜","🏈","🏈","🏈","⬛","⬜"},{"⬛","⬛","🏈","🏈","🏈","⬛","⬛"},{"🏈","🏈","🏈","⬛","⬛","🏈","🏈"},{"🏈","🏈","🏈","⬛","�15","🏈","🏈"},{"🏈","🏈","🏈","🏈","🏈","🏈","🏈"}}},
    {name="свинка",grid={{"\31","\31","\31","\31","\31","\31","\31"},{"�14","�14","�14","�14","�14","�14","�14"},{"�14","�14","�14","�14","�14","�14","�14"},{"⬛","⬜","�14","�14","�14","⬜","⬛"},{"�14","�14","⬜","⬜","⬜","�14","�14"},{"�14","�14","📙","�14","📙","�14","�14"},{"�14","�14","⬜","⬜","⬜","�14","�14"}}},
    {name="стив типо",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","📙","📙","📙","📙","📙","⬛"},{"📙","⬜","�18","📙","�18","⬜","📙"},{"📙","📙","📙","📙","📙","📙","📙"},{"📙","⬛","📙","📙","📙","⬛","📙"},{"📙","⬛","⬛","⬛","⬛","⬛","📙"}}},
    {name="wth",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","📙","📙","📙","📙","📙","⬛"},{"📙","⬜","⬜","📙","⬜","⬜","📙"},{"📙","⬜","⬜","📙","⬜","⬜","📙"},{"📙","📙","📙","⬛","📙","📙","📙"},{"📙","⬛","📙","📙","📙","⬛","📙"},{"📙","⬛","⬛","⬛","⬛","⬛","📙"}}},
    {name="invizer",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"🎮","🎮","🎮","⬛","🎮","🎮","🎮"},{"⬛","⬜","⬜","⬛","⬜","⬜","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬜","⬜","⬜","⬜","⬜","⬛"},{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}}},
    {name="meming",grid={{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬛","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬛","⬜"},{"⬜","⬛","⬜","⬜","⬜","⬜","⬜"},{"⬜","⬜","⬛","⬜","⬜","⬛","⬛"},{"⬜","⬜","⬜","⬛","⬛","⬜","⬜"},{"⬜","⬜","⬜","⬜","⬜","⬜","⬜"}}},
    {name="zombie",grid={{"📗","📗","📗","📗","📗","📗","📗"},{"📗","📗","📗","📗","📗","📗","📗"},{"📗","📗","📗","📗","📗","📗","📗"},{"⬛","⬛","📗","�97","�97","⬛","⬛"},{"�97","�97","⬛","⬛","⬛","�97","�97"},{"�97","⬛","�97","�97","�97","⬛","�97"},{"�97","⬛","⬛","⬛","⬛","⬛","�97"}}},
    {name="ded",grid={{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"},{"�14","�14","�14","�14","🤎","�14","�14"},{"⬛","⬛","�14","�14","�14","⬛","⬛"},{"⬜","�18","�14","�14","�14","�18","⬜"},{"�14","�14","🤎","🤎","🤎","�14","�14"},{"�14","�14","🤎","�14","🤎","�14","�14"},{"\31","\31","\31","\31","\31","\31","\31"}}},
    {name="hz",grid={{"🤎","🤎","🤎","🤎","🤎","🤎","🤎"},{"🤎","🤎","�14","�14","�14","�14","�14"},{"⬜","⬛","�14","�14","�14","⬛","⬜"},{"⬜","⬛","�14","�14","�14","⬛","⬜"},{"�14","�14","�14","�14","�14","�14","�14"},{"�14","�14","⬜","⬜","⬜","�14","�14"},{"�14","�14","�14","�14","�14","�14","�14"}}},
    {name="sprytel",grid={{"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},{"⬛","⬛","�18","�18","�18","⬛","⬛"},{"⬛","🔳","⬜","�18","⬜","🔳","⬛"},{"⬛","⬜","⬜","�18","⬜","⬜","⬛"},{"⬛","�18","�18","�18","�18","�18","⬛"},{"⬛","⬛","�18","�18","�18","⬛","⬛"},{"⬛","⬛","⬛","�18","⬛","⬛","⬛"}}}
}

-- Премиум-пресеты
local premiumPresets = {
    {
        name = "Premium Star",
        grid = {
            {"🌟","⬛","⬛","⬛","⬛","⬛","🌟"},
            {"⬛","🌟","⬛","⬛","⬛","🌟","⬛"},
            {"⬛","⬛","🌟","⬛","🌟","⬛","⬛"},
            {"⬛","⬛","⬛","🌟","⬛","⬛","⬛"},
            {"⬛","⬛","🌟","⬛","🌟","⬛","⬛"},
            {"⬛","🌟","⬛","⬛","⬛","🌟","⬛"},
            {"🌟","⬛","⬛","⬛","⬛","⬛","🌟"}
        }
    },
    {
        name = "Premium Crown",
        grid = {
            {"👑","⬛","⬛","⬛","⬛","⬛","👑"},
            {"⬛","👑","⬛","⬛","⬛","👑","⬛"},
            {"⬛","⬛","👑","⬛","👑","⬛","⬛"},
            {"⬛","⬛","⬛","👑","⬛","⬛","⬛"},
            {"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},
            {"⬛","⬛","⬛","⬛","⬛","⬛","⬛"},
            {"⬛","⬛","⬛","⬛","⬛","⬛","⬛"}
        }
    },
    {
        name = "Coca-Cola",
        grid = {
            {"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},
            {"⬜","⬛","⬜","⬜","⬜","⬛","⬜"},
            {"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},
            {"⬜","⬛","⬛","⬛","⬛","⬛","⬜"},
            {"⬜","⬜","⬜","⬜","⬜","⬜","⬜"},
            {"⬜","⬛","⬜","⬜","⬜","⬛","⬜"},
            {"⬜","⬜","⬜","⬜","⬜","⬜","⬜"}
        }
    }
}

local function chatMessage(str)
    str = tostring(str)
    if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.TextChannels.RBXGeneral:SendAsync(str)
    else
        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(str, "All")
    end
end

local function createButton(text, parent, size, position, backgroundColor)
    local button = Instance.new("TextButton")
    button.Text = text
    button.Size = size
    button.Position = position
    button.BackgroundColor3 = backgroundColor or Color3.fromRGB(60, 60, 60)
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamSemibold
    button.TextSize = 14
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = true
    button.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    local originalColor = button.BackgroundColor3
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = backgroundColor and backgroundColor:Lerp(Color3.fromRGB(255, 255, 255), 0.2) or Color3.fromRGB(80, 80, 80)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.3), {
            BackgroundColor3 = originalColor
        }):Play()
    end)

    return button
end

local function addShadow(frame)
    local shadow = Instance.new("ImageLabel")
    shadow.Size = UDim2.new(1, 20, 1, 20)
    shadow.Position = UDim2.new(0, -10, 0, -10)
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://297774371"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.8
    shadow.ZIndex = frame.ZIndex - 1
    shadow.Parent = frame
end

local drawingGui = nil
local selectedEmoji = "❓"
local interfaceEnabled = false
local savedGrid = {}
local actionBound = false
local drawing = false

local function savePresetsToFile()
    local success, errorMessage = pcall(function()
        local data = {basic = presets, premium = premiumPresets}
        local jsonString = HttpService:JSONEncode(data)
        writefile(PRESET_FILE_NAME, jsonString)
    end)
    if not success then
        warn("Error saving presets:", errorMessage)
    end
end

local function loadPresetsFromFile()
    local success, fileContent = pcall(function()
        return readfile(PRESET_FILE_NAME)
    end)

    if success and fileContent then
        local decodeSuccess, decodedData = pcall(function()
            return HttpService:JSONDecode(fileContent)
        end)

        if decodeSuccess and decodedData then
            if decodedData.basic then
                presets = decodedData.basic
            end
            if decodedData.premium then
                premiumPresets = decodedData.premium
            end
        else
            warn("Error decoding presets: ", decodedData)
        end
    else
        warn("Error loading or reading the file:", fileContent)
    end
end

local function createDrawingInterface()
    local gui = Instance.new("ScreenGui")
    gui.Name = "DrawingInterface"
    gui.DisplayOrder = 2
    gui.ResetOnSpawn = false
    gui.Parent = CoreGui

    local isTouchEnabled = UserInputService.TouchEnabled
    local mainFrameScale = isTouchEnabled and 0.7 or 1

    local baseWidth = 300
    local baseHeight = 490
    local baseX = -150
    local baseY = -245

    local scaledWidth = baseWidth * mainFrameScale
    local scaledHeight = baseHeight * mainFrameScale
    local scaledX = baseX * mainFrameScale
    local scaledY = baseY * mainFrameScale

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, scaledWidth, 0, scaledHeight)
    mainFrame.Position = UDim2.new(0.5, scaledX, 0.5, scaledY)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10 * mainFrameScale)
    corner.Parent = mainFrame

    addShadow(mainFrame)

    local titleBarHeight = 30 * mainFrameScale
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, titleBarHeight)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10 * mainFrameScale)
    titleCorner.Parent = titleBar

    local titleTextOffset = 10 * mainFrameScale
    local titleText = Instance.new("TextLabel")
    titleText.Text = "Chat Draw | Avtor Scripts"
    titleText.Size = UDim2.new(1, -40 * mainFrameScale, 1, 0)
    titleText.Position = UDim2.new(0, titleTextOffset, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Font = Enum.Font.Gotham
    titleText.TextSize = 14 * mainFrameScale
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    local GRID_SIZE = 7
    local CELL_SIZE = 35 * mainFrameScale
    local grid = {}
    local cells = {}

    local gridOffsetX = -(GRID_SIZE * CELL_SIZE) / 2
    local gridOffsetY = 40 * mainFrameScale

    local gridFrame = Instance.new("Frame")
    gridFrame.Size = UDim2.new(0, GRID_SIZE * CELL_SIZE, 0, GRID_SIZE * CELL_SIZE)
    gridFrame.Position = UDim2.new(0.5, gridOffsetX, 0, gridOffsetY)
    gridFrame.BackgroundTransparency = 1
    gridFrame.Parent = mainFrame

    local function updateCell(cell, i, j)
        grid[i][j] = selectedEmoji
        cell.Text = selectedEmoji
        local scaleUp = TweenService:Create(cell, TweenInfo.new(0.1), {Size = UDim2.new(0, CELL_SIZE, 0, CELL_SIZE)})
        local scaleDown = TweenService:Create(cell, TweenInfo.new(0.1), {Size = UDim2.new(0, CELL_SIZE - 2 * mainFrameScale, 0, CELL_SIZE - 2 * mainFrameScale)})
        scaleUp:Play()
        scaleUp.Completed:Connect(function()
            scaleDown:Play()
        end)
    end

    for i = 1, GRID_SIZE do
        grid[i] = {}
        cells[i] = {}
        for j = 1, GRID_SIZE do
            local cellOffsetX = (j - 1) * CELL_SIZE + 1 * mainFrameScale
            local cellOffsetY = (i - 1) * CELL_SIZE + 1 * mainFrameScale
            local cell = createButton("", gridFrame, UDim2.new(0, CELL_SIZE - 2 * mainFrameScale, 0, CELL_SIZE - 2 * mainFrameScale), UDim2.new(0, cellOffsetX, 0, cellOffsetY), Color3.fromRGB(45, 45, 45))
            cell.Font = Enum.Font.Gotham
            cell.TextSize = 20 * mainFrameScale
            cell.Text = ""

            grid[i][j] = ""
            cells[i][j] = cell

            cell.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    drawing = true
                    updateCell(cell, i, j)
                end
            end)
            cell.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                    if drawing then
                        updateCell(cell, i, j)
                    end
                end
            end)
            cell.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    drawing = false
                end
            end)
        end
    end

    if #savedGrid > 0 then
        for x = 1, GRID_SIZE do
            for y = 1, GRID_SIZE do
                grid[x][y] = savedGrid[x][y]
                gridFrame:GetChildren()[(x - 1) * GRID_SIZE + y].Text = savedGrid[x][y]
            end
        end
    end

    local emojiScrollFrameHeight = 40 * mainFrameScale
    local emojiScrollFrameOffsetY = 295 * mainFrameScale

    local emojiScrollFrame = Instance.new("ScrollingFrame")
    emojiScrollFrame.Size = UDim2.new(0.95, 0, 0, emojiScrollFrameHeight)
    emojiScrollFrame.Position = UDim2.new(0.025, 0, 0, emojiScrollFrameOffsetY)
    emojiScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    emojiScrollFrame.BorderSizePixel = 0
    emojiScrollFrame.ScrollBarThickness = 4 * mainFrameScale
    emojiScrollFrame.ScrollingDirection = Enum.ScrollingDirection.X
    emojiScrollFrame.Parent = mainFrame

    local emojiScrollFrameCorner = Instance.new("UICorner")
    emojiScrollFrameCorner.CornerRadius = UDim.new(0, 4 * mainFrameScale)
    emojiScrollFrameCorner.Parent = emojiScrollFrame

    local emojis = {"","⬜", "⬛", "🔲", "🔳", "🏮", "🔴", "🔵", "💜", "🤎", "❤️", "💛", "💚", "💙", "💖", "🧡", "🌸", "🌺", "🌻", "🌼", "🌷", "🌹", "�15", "📙", "📒", "📗", "�18", "�14", "📚", "📖", "❓", "❗", "💯", "🔥", "⭐", "✨", "🌙", "🌞", "☁️", "🌈", "🍕", "🍔", "🍟", "🍦", "🍩", "🍪", "☕", "🍺", "🍷", "🍸", "⚽", "🏀", "🏈", "⚾", "🎾", "🎮", "🎧", "🎵", "🎸", "🎻", "🎺", "🎷", "🎤", "🎨", "📷", "💡", "💻", "📱", "⏰", "🔒", "🔑", "🎁", "🎈", "🎉", "🎀", "📌", "📍", "🗺️", "✂️", "✏️", "✒️", "📝", "📖", "🔒", "🔔", "📞", "🛒", "💰", "💳", "💎", "🔨", "🔧", "🧰", "🧱", "🧲", "🧪", "🔬", "🔭", "🚑", "🚒", "🚓", "🚕", "🚗", "🚌", "🚲", "🚂", "✈️", "🚢", "🚀", "🛸", "🗿", "🚧", "🚦", "🛑", "🚫", "✅", "❌", "❓", "❗", "💯", "🔥", "⭐", "✨", "🌙", "🌞", "☁️", "🌈", "🍕", "🍔", "🍟", "🍦", "🍩", "🍪", "☕", "🍺", "🍷", "🍸", "⚽", "🏀", "🏈", "⚾", "🎾", "🎮", "🎧", "🎵", "🎸", "🎻", "🎺", "🎷", "🎤", "🎨", "📷", "💡", "💻", "📱", "⏰", "🔒", "🔑", "🎁", "🎈", "🎉", "🎀", "📌", "📍", "🗺️", "✂️", "✏️", "✒️", "📝", "📖", "🔒", "🔔", "📞", "🛒", "💰", "💳", "💎", "🔨", "🔧", "🧰", "🧱", "🧲", "🧪", "🔬", "🔭", "🚑", "🚒", "🚓", "🚕", "🚗", "🚌", "🚲", "🚂", "✈️", "🚢", "🚀", "🛸", "🗿", "🚧", "🚦", "🛑", "🚫", "✅", "❌"}
    local emojiButtons = {}

    local totalWidth = #emojis * 35 * mainFrameScale
    emojiScrollFrame.CanvasSize = UDim2.new(0, totalWidth, 0, 0)

    for i, emoji in ipairs(emojis) do
        local emojiButtonOffsetX = (i - 1) * 35 * mainFrameScale + 5 * mainFrameScale
        local emojiButton = createButton(emoji, emojiScrollFrame, UDim2.new(0, 30 * mainFrameScale, 0, 30 * mainFrameScale), UDim2.new(0, emojiButtonOffsetX, 0, 5 * mainFrameScale), Color3.fromRGB(60, 60, 60))
        emojiButton.Font = Enum.Font.Gotham
        emojiButton.TextSize = 20 * mainFrameScale

        table.insert(emojiButtons, emojiButton)

        emojiButton.MouseButton1Click:Connect(function()
            selectedEmoji = emoji
            for _, btn in ipairs(emojiButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
            emojiButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        end)
    end

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(0.95, 0, 0, 30 * mainFrameScale)
    tabFrame.Position = UDim2.new(0.025, 0, 0, 285 * mainFrameScale)
    tabFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = mainFrame

    local tabFrameCorner = Instance.new("UICorner")
    tabFrameCorner.CornerRadius = UDim.new(0, 6 * mainFrameScale)
    tabFrameCorner.Parent = tabFrame

    local basicTabButton = createButton("Basic", tabFrame, UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(60, 60, 60))
    local premiumTabButton = createButton("Premium", tabFrame, UDim2.new(0.48, 0, 1, 0), UDim2.new(0.52, 0, 0, 0), Color3.fromRGB(60, 60, 60))

    local presetFrameHeight = 125 * mainFrameScale
    local presetFrameOffsetY = 340 * mainFrameScale

    local basicPresetFrame = Instance.new("Frame")
    basicPresetFrame.Size = UDim2.new(0.95, 0, 0, presetFrameHeight)
    basicPresetFrame.Position = UDim2.new(0.025, 0, 0, presetFrameOffsetY)
    basicPresetFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    basicPresetFrame.BorderSizePixel = 0
    basicPresetFrame.Parent = mainFrame
    basicPresetFrame.Visible = true

    local basicPresetFrameCorner = Instance.new("UICorner")
    basicPresetFrameCorner.CornerRadius = UDim.new(0, 6 * mainFrameScale)
    basicPresetFrameCorner.Parent = basicPresetFrame

    local premiumPresetFrame = Instance.new("Frame")
    premiumPresetFrame.Size = UDim2.new(0.95, 0, 0, presetFrameHeight)
    premiumPresetFrame.Position = UDim2.new(0.025, 0, 0, presetFrameOffsetY)
    premiumPresetFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    premiumPresetFrame.BorderSizePixel = 0
    premiumPresetFrame.Parent = mainFrame
    premiumPresetFrame.Visible = false

    local premiumPresetFrameCorner = Instance.new("UICorner")
    premiumPresetFrameCorner.CornerRadius = UDim.new(0, 6 * mainFrameScale)
    premiumPresetFrameCorner.Parent = premiumPresetFrame

    local presetInputHeight = 30 * mainFrameScale
    local presetInputOffsetY = 10 * mainFrameScale

    local presetInput = Instance.new("TextBox")
    presetInput.Size = UDim2.new(0.7, 0, 0, presetInputHeight)
    presetInput.Position = UDim2.new(0.025, 0, 0, presetInputOffsetY)
    presetInput.PlaceholderText = "Enter preset name..."
    presetInput.Text = ""
    presetInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    presetInput.BorderSizePixel = 0
    presetInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    presetInput.Font = Enum.Font.Gotham
    presetInput.TextSize = 14 * mainFrameScale
    presetInput.Parent = basicPresetFrame

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4 * mainFrameScale)
    inputCorner.Parent = presetInput

    local savePresetButtonSize = 30 * mainFrameScale
    local savePresetButtonOffsetY = 10 * mainFrameScale
    local savePresetButton = createButton("Save", basicPresetFrame, UDim2.new(0.225, 0, 0, savePresetButtonSize), UDim2.new(0.75, 0, 0, savePresetButtonOffsetY), Color3.fromRGB(70, 170, 70))

    local presetListHeight = 80 * mainFrameScale
    local presetListOffsetY = 45 * mainFrameScale
    local basicPresetList = Instance.new("ScrollingFrame")
    basicPresetList.Size = UDim2.new(0.95, 0, 0, presetListHeight)
    basicPresetList.Position = UDim2.new(0.025, 0, 0, presetListOffsetY)
    basicPresetList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    basicPresetList.BorderSizePixel = 0
    basicPresetList.ScrollBarThickness = 4 * mainFrameScale
    basicPresetList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    basicPresetList.ScrollBarImageTransparency = 0.5
    basicPresetList.Parent = basicPresetFrame

    local basicListCorner = Instance.new("UICorner")
    basicListCorner.CornerRadius = UDim.new(0, 4 * mainFrameScale)
    basicListCorner.Parent = basicPresetList

    local premiumPresetList = Instance.new("ScrollingFrame")
    premiumPresetList.Size = UDim2.new(0.95, 0, 0, presetListHeight)
    premiumPresetList.Position = UDim2.new(0.025, 0, 0, presetListOffsetY)
    premiumPresetList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    premiumPresetList.BorderSizePixel = 0
    premiumPresetList.ScrollBarThickness = 4 * mainFrameScale
    premiumPresetList.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    premiumPresetList.ScrollBarImageTransparency = 0.5
    premiumPresetList.Parent = premiumPresetFrame

    local premiumListCorner = Instance.new("UICorner")
    premiumListCorner.CornerRadius = UDim.new(0, 4 * mainFrameScale)
    premiumListCorner.Parent = premiumPresetList

    local function updatePresetList(isPremium)
        local targetList = isPremium and premiumPresetList or basicPresetList
        local targetPresets = isPremium and premiumPresets or presets

        for _, child in ipairs(targetList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local yOffset = 5 * mainFrameScale
        for i, presetData in ipairs(targetPresets) do
            local name = presetData.name
            local preset = presetData.grid
            local presetButtonHeight = 25 * mainFrameScale
            local presetButton = createButton(name, targetList, UDim2.new(0.9, 0, 0, presetButtonHeight), UDim2.new(0.05, 0, 0, yOffset))

            presetButton.MouseButton1Click:Connect(function()
                if isPremium and not isPremiumPlayer() then
                    MarketplaceService:PromptGamePassPurchase(Players.LocalPlayer, PREMIUM_GAMEPASS_ID)
                    return
                end
                for x = 1, GRID_SIZE do
                    for y = 1, GRID_SIZE do
                        grid[x][y] = preset[x][y]
                        gridFrame:GetChildren()[(x - 1) * GRID_SIZE + y].Text = preset[x][y]
                    end
                end
            end)

            if not isPremium then
                local deleteButtonSize = 20 * mainFrameScale
                local deleteButtonOffsetX = -25 * mainFrameScale
                local deleteButtonOffsetY = 2 * mainFrameScale
                local deleteButton = createButton("X", presetButton, UDim2.new(0, deleteButtonSize, 0, deleteButtonSize), UDim2.new(1, deleteButtonOffsetX, 0, deleteButtonOffsetY), Color3.fromRGB(200, 50, 50))
                deleteButton.TextSize = 12 * mainFrameScale
                deleteButton.MouseButton1Click:Connect(function()
                    table.remove(presets, i)
                    updatePresetList(false)
                    savePresetsToFile()
                end)
            end

            yOffset = yOffset + 30 * mainFrameScale
        end

        targetList.CanvasSize = UDim2.new(0, 0, 0, yOffset)
    end

    savePresetButton.MouseButton1Click:Connect(function()
        local name = presetInput.Text
        if name ~= "" then
            local currentGrid = {}
            for x = 1, GRID_SIZE do
                currentGrid[x] = {}
                for y = 1, GRID_SIZE do
                    currentGrid[x][y] = grid[x][y]
                end
            end

            table.insert(presets, {name = name, grid = currentGrid})
            savePresetsToFile()
            presetInput.Text = ""
            updatePresetList(false)
        end
    end)

    basicTabButton.MouseButton1Click:Connect(function()
        basicPresetFrame.Visible = true
        premiumPresetFrame.Visible = false
        basicTabButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        premiumTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        updatePresetList(false)
    end)

    premiumTabButton.MouseButton1Click:Connect(function()
        basicPresetFrame.Visible = false
        premiumPresetFrame.Visible = true
        basicTabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        premiumTabButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        updatePresetList(true)
    end)

    local actionButtonsHeight = 35 * mainFrameScale
    local actionButtonsOffsetY = 455 * mainFrameScale

    local actionButtons = Instance.new("Frame")
    actionButtons.Size = UDim2.new(0.95, 0, 0, actionButtonsHeight)
    actionButtons.Position = UDim2.new(0.025, 0, 0, actionButtonsOffsetY)
    actionButtons.BackgroundTransparency = 1
    actionButtons.Parent = mainFrame

    local sendButton = createButton("Send", actionButtons, UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0), Color3.fromRGB(70, 170, 70))
    sendButton.MouseButton1Click:Connect(function()
        local art = ""
        for x = 1, GRID_SIZE do
            for y = 1, GRID_SIZE do
                art = art .. (grid[x][y] ~= "" and grid[x][y] or "⬜")
            end
            if x < GRID_SIZE then
                art = art .. NEWLINE
            end
        end
        chatMessage(INVISIBLE_CHAR .. string.rep(NEWLINE, 8) .. art)
    end)

    local clearButton = createButton("Clear", actionButtons, UDim2.new(0.48, 0, 1, 0), UDim2.new(0.52, 0, 0, 0), Color3.fromRGB(170, 70, 70))
    clearButton.MouseButton1Click:Connect(function()
        for x = 1, GRID_SIZE do
            for y = 1, GRID_SIZE do
                grid[x][y] = ""
                gridFrame:GetChildren()[(x - 1) * GRID_SIZE + y].Text = ""
            end
        end
    end)

    local dragging = false
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

        local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(mainFrame, tweenInfo, {Position = position}):Play()
    end

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    gui.DescendantRemoving:Connect(function(descendant)
        if descendant == gui then
            savedGrid = {}
            for x = 1, GRID_SIZE do
                savedGrid[x] = {}
                for y = 1, GRID_SIZE do
                    savedGrid[x][y] = grid[x][y]
                end
            end
        end
    end)

    updatePresetList(false)

    return gui
end

loadPresetsFromFile()

drawingGui = createDrawingInterface()
drawingGui.Enabled = true
interfaceEnabled = true

local ScreenGui1 = Instance.new("ScreenGui")
ScreenGui1.Parent = game.CoreGui

local TextButton1 = Instance.new("TextButton")
TextButton1.Parent = ScreenGui1
TextButton1.Size = UDim2.new(0, 50, 0, 50)
TextButton1.Position = UDim2.new(0.21, 0, -0.14)
TextButton1.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton1.BackgroundTransparency = 0.3
TextButton1.BorderSizePixel = 0
TextButton1.Text = "🖌"
TextButton1.TextColor3 = Color3.fromRGB(242, 243, 243)
TextButton1.TextSize = 18

local UICorner1 = Instance.new("UICorner")
UICorner1.Parent = TextButton1
UICorner1.CornerRadius = UDim.new(0.5, 0)

local function toggleInterface()
    interfaceEnabled = not interfaceEnabled
    drawingGui.Enabled = interfaceEnabled
end

TextButton1.MouseButton1Click:Connect(function()
    toggleInterface()
end)
