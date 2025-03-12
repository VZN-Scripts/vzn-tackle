Citizen.CreateThread(function()
    local resource = GetCurrentResourceName()

    local currentVersion = GetResourceMetadata(resource, "version", 0)

    if currentVersion then
        currentVersion = currentVersion:match("%d+%.%d+%.%d+")
    end

    if not currentVersion then return end

    SetTimeout(1000, function()
        PerformHttpRequest(
            ("https://raw.githubusercontent.com/VZN-Scripts/vzn-version-check/main/%s.json"):format(resource),
            function(status, response)
                if status ~= 200 then return end

                response = json.decode(response)
                if not response or not response.version then return end

                local latestVersion = response.version:match("%d+%.%d+%.%d+")
                if not latestVersion or latestVersion == currentVersion then return end

                local cv = { string.strsplit(".", currentVersion) }
                local lv = { string.strsplit(".", latestVersion) }

                for i = 1, #cv do
                    local current, minimum = tonumber(cv[i]), tonumber(lv[i])

                    if current ~= minimum then
                        if current < minimum then
                            return print(
                                ("^3New update available to [^5%s^3] (current version: ^5%s^3)\r\nNew version: ^2%s^3 | %s^0")
                                :format(
                                    resource,
                                    currentVersion,
                                    response.version,
                                    response.description or ""
                                )
                            )
                        else
                            break
                        end
                    end
                end
            end,
            "GET"
        )
    end)
end)
