local LS = loadstring
if not LS and getgenv then
    LS = getgenv().loadstring
end
if not LS then return end

local HttpService = game:GetService("HttpService")

local function xorDecode(s, key)
    local kb = #key
    local out = {}
    for i = 1, #s do
        out[i] = string.char(string.byte(s, i) ~= string.byte(key, (i - 1) % kb + 1))
    end
    return table.concat(out)
end

local baseUrl = xorDecode("\24\17\29\26\10\31...", "k")
local listPath = xorDecode("\4\22\2\9\28...", "k")

local ok, listSource = pcall(function()
    return HttpService:HttpGetAsync(baseUrl .. listPath)
end)
if not ok then return end

local listChunk = LS(listSource)
if type(listChunk) ~= "function" then return end
local ok2, Games = pcall(listChunk)
if not ok2 or type(Games) ~= "table" then return end

local URL = Games[game.PlaceId]
if not URL then return end

local ok3, codeSource = pcall(function()
    return HttpService:HttpGetAsync(URL)
end)
if not ok3 then return end

local chunk = LS(codeSource)
if chunk then chunk() end
