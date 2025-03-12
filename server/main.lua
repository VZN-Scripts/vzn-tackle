lib.callback.register('vzn-tackle/server/tacklePlayer', function(source, target)
    if not CanPlayerUseTackle(source) then return false end
    if not target or target == -1 or target <= 0 then return false end

    local result = lib.callback.await('vzn-tackle/client/beenTackled', target)
    if not result then return false end

    return true
end)
