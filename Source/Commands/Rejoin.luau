Cmd.Reg(Cmd.new({"rejoin", "rj"}, "Rejoins the current server.", "rejoin", function()
    local TeleportService = Services.TeleportService
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end))