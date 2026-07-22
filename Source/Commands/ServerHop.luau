Cmd.Reg(Cmd.new({"serverhop", "shop"}, "Teleports you to a random available server without joining the current server.", ".serverhop", function()
    local TeleportService = Services.TeleportService
    local HttpService = Services.HttpService

    local CurrentJobId = game.JobId
    local PlaceId = game.PlaceId

    local Success, Result = pcall(function()
        return HttpService:JSONDecode(
            game:HttpGet(
                "https://games.roblox.com/v1/games/" .. PlaceId ..
                "/servers/Public?sortOrder=Asc&limit=100"
            )
        )
    end)

    if not Success or not Result or not Result.data then
        return
    end

    local Servers = {}

    for _, Server in ipairs(Result.data) do
        if Server.id ~= CurrentJobId and Server.playing < Server.maxPlayers then
            table.insert(Servers, Server.id)
        end
    end

    if #Servers > 0 then
        local ServerId = Servers[math.random(1, #Servers)]
        TeleportService:TeleportToPlaceInstance(PlaceId, ServerId)
    end
end))