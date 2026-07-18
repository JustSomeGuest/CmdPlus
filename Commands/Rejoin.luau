Cmd.Reg(Cmd.new({"rejoin", "rj"}, function()
    local TeleportService = Services.TeleportService
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end))
