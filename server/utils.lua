---@param playerId number
---@return boolean
function CanPlayerUseTackle(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if not xPlayer or xPlayer.job.name ~= 'police' then return false end
    return true
end
