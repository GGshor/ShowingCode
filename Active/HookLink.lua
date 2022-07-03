--[[
    A wrapper for multiple webhooks
--]]

-- TODO: Think of a way to support multiple webhooks instead of just one.


local HttpService = game:GetService("HttpService")


local HookLink = {}
local Debug = true


--[[
    Adds prefix to warning if debug is true
--]]
local function debugWarn(...:any)
    if Debug == true then
        warn("[HookLink]:", ...)
    end
end


--[[
    Sends the data to the url using ApplicationJson.

    @tag Yield
]]
function HookLink:Send()
    local sent, response = pcall(
        HttpService.RequestAsync,
        HttpService,
        {
            Url = self.url,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(self.data)
        }
    )

    if sent == true then
        return true
    else
        if response:find("")
    end
end

function HookLink:TestResponse(url: string)
    local success, reason = pcall(HttpService.GetAsync, HttpService, url)

    if success then
        return true
    else
        debugWarn("Response test failed:", reason)
        return false
    end
    
end

function HookLink:EnableProxy(url: string)
    if typeof(url) == "string" then
        if HookLink:TestResponse(url) then
            self.proxy.enabled = true
            self.proxy.url = url
        end
    end
end

function HookLink.new(hookAPI: string, token: string?, key: string?)
    local self = {
        ["API"] = "None",
        ["url"] = "None",
        ["token"] = (typeof(token) == "string") and token or "None",
        ["key"] = (typeof(key) == "string") and key or "None",
        ["proxy"] = {
            ["enabled"] = false,
            ["url"] = false
        }
    }

    if hookAPI == "Discord" then
        self.API = "Discord"
    end

    return self
end