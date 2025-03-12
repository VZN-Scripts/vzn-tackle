local glm = require "glm"

---@return number | nil
function GetPlayerInDirection()
    local playerCoords = GetEntityCoords(cache.ped)
    local forwardVector = GetEntityForwardVector(cache.ped)

    local players = lib.getNearbyPlayers(playerCoords, Config.MaxDistance, false)

    local closestPlayer = nil
    local closestDistance = math.huge
    for _, otherPlayer in ipairs(players) do
        local coords = GetEntityCoords(otherPlayer.ped)
        local toOtherVec = coords - playerCoords
        local dotProduct = glm.dot(toOtherVec, forwardVector)

        -- checking if player is in front
        if dotProduct > 0 then
            local distanceSquared = glm.length2(toOtherVec)
            if distanceSquared < closestDistance then
                closestDistance = distanceSquared
                closestPlayer = otherPlayer.ped
            end
        end
    end

    if not closestPlayer then return nil end

    local coords = GetEntityCoords(closestPlayer)
    if #(playerCoords - coords) > Config.MaxDistance then return end
    if GetEntityType(closestPlayer) ~= 1 or not IsPedAPlayer(closestPlayer) then return end

    return NetworkGetPlayerIndexFromPed(closestPlayer)
end

---@return boolean
function CanUseTackle()
    local ped = cache.ped
    if cache.vehicle then return false end
    if IsPedSwimmingUnderWater(ped) or IsPedSwimming(ped) then return false end
    if IsPedJumping(ped) then return false end


    -- checking job or something like that
    return true
end
