RegisterNetEvent('noteit:server:consumeItem', function()
    local src = source
    local itemName = (Config and Config.ItemName) or 'noteit'

    local has = exports.ox_inventory:Search(src, 'count', itemName)
    if (has or 0) < 1 then return end

    local removed = exports.ox_inventory:RemoveItem(src, itemName, 1)

    if Config.DebugDev then
        local success = (type(removed) == 'boolean' and removed)
                     or (type(removed) == 'number'  and removed > 0)

        if success then
            print(('[gaijin-noteit][DEBUG] Removed 1x %s from player %s'):format(itemName, src))
        else
            print(('[gaijin-noteit][DEBUG] Failed to remove %s from player %s'):format(itemName, src))
        end
    end
end)
