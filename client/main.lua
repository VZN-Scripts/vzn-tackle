ANIM = {
    DICT = "missmic2ig_11",
    COP = "mic_2_ig_11_intro_goon",
    FLEE = "mic_2_ig_11_intro_p_one"
}
TIME = 3000

local cooldown = false

lib.addKeybind({
    name = 'vzn-tackle',
    description = "Tackle player",
    onPressed = function(self)
        if not CanUseTackle() then return end
        if cooldown then return end
        Tackle()
    end,
})

---@param target number
---@param targetPed number
local function tacklePlayer(target, targetPed)
    lib.requestAnimDict(ANIM.DICT)
    local result = lib.callback.await('vzn-tackle/server/tacklePlayer', false, target)
    if not result then return end

    local ped = cache.ped
    AttachEntityToEntity(ped, targetPed, 11816, 0.25, 0.5, 0.0, 0.5, 0.5, 180.0, false, false, false, false, 2, false)
    TaskPlayAnim(ped, ANIM.DICT, ANIM.COP, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Citizen.CreateThread(function()
        Wait(TIME)
        ---@diagnostic disable-next-line: missing-parameter
        DetachEntity(ped)
        ClearPedTasks(ped)
    end)
end

function Tackle()
    local playerPed = cache.ped
    if not IsPedRunning(playerPed) and not IsPedSprinting(playerPed) then return end
    local player = GetPlayerInDirection()
    if not player or player == -1 then return end

    local targetPed = GetPlayerPed(player)

    local ply = Player(GetPlayerServerId(player))
    if ply.state.dead or ply.state.isHandcuffed then return end

    if IsPedInAnyVehicle(targetPed, false) then return end

    cooldown = true
    Citizen.CreateThread(function()
        Wait(Config.Cooldown)
        cooldown = false
    end)


    if IsPedRunning(targetPed) or IsPedSprinting(targetPed) then
        local result = nil

        local rand = math.random(1, 100)
        if rand < Config.DoneChance then
            result = true
        elseif rand < Config.DoneChance + Config.RagdollChance then
            result = false
        else
            result = nil
        end

        if result == false then
            local forwardVector = GetEntityForwardVector(playerPed)
            SetPedToRagdollWithFall(playerPed, 1500, 2000, 0, forwardVector.x, forwardVector.y, forwardVector.z, 1.0, 0.0,
                0.0, 0.0, 0.0, 0.0, 0.0)
            return
        end
        if result == nil then
            return
        end

        tacklePlayer(GetPlayerServerId(player), targetPed)
    else
        tacklePlayer(GetPlayerServerId(player), targetPed)
    end
end

lib.callback.register('vzn-tackle/client/beenTackled', function()
    lib.requestAnimDict(ANIM.DICT)
    local ped = cache.ped
    TaskPlayAnim(ped, ANIM.DICT, ANIM.FLEE, 8.0, -8.0, -1, 0, 0.0, false, false, false)
    Citizen.CreateThread(function()
        Wait(TIME)
        ClearPedTasks(ped)
        SetPedToRagdoll(ped, 5000, 5000, 0, false, false, false)
    end)
    return true
end)
