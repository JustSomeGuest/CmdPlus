Cmd.Reg(Cmd.new({"setshader", "ss"}, "Changes the current weather and time shader. Supports realistic mode and resetting the shader.", ".setshader <weather> <time>", function(Args)
    local first = Args[2]
    local second = Args[3]

    if not first then
        DebugNotif("Usage: .setshader <weather> <time> / .setshader realistic / .setshader off")
        return
    end

    local lowerFirst = first:lower()

    if lowerFirst == "realistic" then
        StartRealistic()
        DebugNotif("Time of Day: Realistic (following local time)")
        return
    end

    if lowerFirst == "off" or lowerFirst == "stop" then
        ResetShader()
        DebugNotif("Shader reset to default")
        return
    end

    StopRealistic()

    local timeName = ResolveTimeName(first)
    local weatherName = ResolveWeatherName(first)

    if second then
        local secondTime = ResolveTimeName(second)
        local secondWeather = ResolveWeatherName(second)
        if secondTime then timeName = secondTime end
        if secondWeather then weatherName = secondWeather end
    end

    if not timeName and not weatherName then
        DebugNotif("Invalid input. Try: .setshader clear noon / .setshader rainy morning")
        return
    end

    if timeName then
        CurrentTimeName = timeName
    end
    if weatherName then
        CurrentWeatherName = weatherName
    end

    ApplyCombined(CurrentTimeName, CurrentWeatherName)

    local TimeEmoji = TimeOfDay[CurrentTimeName].Emoji
    local WeatherEmoji = Weather[CurrentWeatherName].Emoji
    DebugNotif(WeatherEmoji .. " " .. TimeEmoji .. " Shader set to " .. CurrentWeatherName .. " " .. CurrentTimeName)
end))