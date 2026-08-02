Cmd.new({"rejoin", "rj"}, "Rejoins the current server.", "rejoin", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)