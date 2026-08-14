local HttpGet = game.HttpGet
local GameId = game.GameId

-- 1. Fetch + compile the list
local listSource = HttpGet(game, "https://raw.githubusercontent.com/ramreading/whohateroblox/main/robloxgamelist.lua", true)
local listChunk, listErr = loadstring(listSource)
if not listChunk then
    warn("[Loader] Failed to compile list: " .. tostring(listErr))
    return
end

-- 2. Run it — should return the Games table
local ok, Games = pcall(listChunk)
if not ok or type(Games) ~= "table" then
    warn("[Loader] List did not return a table")
    return
end

-- 3. Game check
local URL = Games[GameId]
if not URL then
    warn("Wrong game! This script only works in supported games.")
    return
end

-- 4. Fetch + compile + run the per-game script
local codeSource = HttpGet(game, URL, true)
local codeChunk, codeErr = loadstring(codeSource)
if not codeChunk then
    warn("[Loader] Failed to compile script: " .. tostring(codeErr))
    return
end
codeChunk()
