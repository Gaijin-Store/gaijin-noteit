local isUsingNoteIt = false
local placedNoteIts = {}
local tempNoteItCoords = nil
local noteitZone = nil

-- ===== drawing helpers =====
local function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if not onScreen then return end
    SetTextFont(4)
    SetTextScale(0.35, 0.35)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry('STRING')
    SetTextCentre(true)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = string.len(text) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 140)
end

-- point in front of the player, aligned to the ground (fallback for onSelect)
local function GetPlacementCoords()
    local ped  = PlayerPedId()
    local from = GetEntityCoords(ped)
    local fwd  = GetEntityForwardVector(ped)
    local to   = from + (fwd * 2.5)

    local ray = StartShapeTestCapsule(
        from.x, from.y, from.z + 0.8,
        to.x,   to.y,   to.z - 2.0,
        0.4, 1, ped, 7
    )
    local _, hit, hitCoords = GetShapeTestResult(ray)
    local x, y, z = to.x, to.y, to.z
    if hit == 1 and hitCoords then
        x, y, z = hitCoords.x, hitCoords.y, hitCoords.z
    end
    local found, gz = GetGroundZFor_3dCoord(x, y, z + 1.0, false)
    if found then z = gz end
    return vec3(x, y, z + 0.02)
end

-- converts camera rotation to a direction (unit vector)
local function RotToDir(rot)
    local z = math.rad(rot.z)
    local x = math.rad(rot.x)
    local num = math.abs(math.cos(x))
    return vec3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

-- ground point under the camera crosshair (more precise than data.coords)
local function GetAimedGroundCoords(maxDist)
    maxDist = maxDist or 30.0
    local camPos = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local dir = RotToDir(camRot)
    local dest = camPos + (dir * maxDist)

    local handle = StartShapeTestRay(
        camPos.x, camPos.y, camPos.z,
        dest.x,   dest.y,   dest.z,
        1,   -- world
        -1,  -- ignore entities
        7
    )
    local _, hit, hitCoords = GetShapeTestResult(handle)
    if hit == 1 and hitCoords then
        local x, y, z = hitCoords.x, hitCoords.y, hitCoords.z
        local found, gz = GetGroundZFor_3dCoord(x, y, z + 1.0, false)
        if found then z = gz end
        return vec3(x, y, z + 0.02)
    end
    return GetPlacementCoords()
end
-- ===============================

local function removePlacementZone()
    if noteitZone then
        exports.ox_target:removeZone(noteitZone)
        noteitZone = nil
    end
end

-- starts placement mode with ONE big zone centered on the player
local function startPlacementMode()
    removePlacementZone()

    local ped     = PlayerPedId()
    local center  = GetEntityCoords(ped)
    local radius  = (Config and Config.PlaceRadius) or 10.5
    local label   = (Config and (Config.PlaceLabel or 'Place the note here')) or 'Place the note here'
    local icon    = (Config and Config.TargetIcon) or 'fas fa-sticky-note'
    local maxText = (Config and Config.MaxTextLength) or 160

    noteitZone = exports.ox_target:addSphereZone({
        coords = center,
        radius = radius,
        debug  = false,
        drawSprite = true,
        options = {
            {
                name  = 'noteit_place',
                icon  = icon,
                label = label,
                onSelect = function(_data)
                    tempNoteItCoords = GetAimedGroundCoords(30.0)

                    if Config and Config.DebugDev then
                        print(('[noteit][DEBUG] onSelect coords: %s'):format(
                            json.encode({ x = tempNoteItCoords.x, y = tempNoteItCoords.y, z = tempNoteItCoords.z })
                        ))
                    end

                    TriggerScreenblurFadeIn(250)
                    SetNuiFocus(true, true)
                    SendNUIMessage({ action = 'open', max = maxText })

                    removePlacementZone()
                end
            }
        }
    })

    if lib and lib.notify then
        lib.notify({
            title = 'NoteIt',
            description = ('Ready to place your note?'),
            type = 'inform'
        })
    end
end

-- ox_inventory export (uses the item → enters placement mode)
exports('useItem', function(item)
    if isUsingNoteIt then return end
    if item and Config and Config.ItemName and item.name ~= Config.ItemName then
        if Config.DebugDev then print('[noteit][DEBUG] useItem ignored: item != Config.ItemName') end
        return
    end

    isUsingNoteIt = true
    if Config and Config.DebugDev then print('[noteit][DEBUG] useItem export called') end
    startPlacementMode()
end)

-- NUI: close interface
RegisterNUICallback('close', function(_, cb)
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(250)
    isUsingNoteIt = false
    tempNoteItCoords = nil
    removePlacementZone()
    if cb then cb({}) end
end)

-- NUI: create the note at the chosen location
RegisterNUICallback('createNoteit', function(data, cb)
    if not tempNoteItCoords then
        tempNoteItCoords = GetAimedGroundCoords(30.0)
        if not tempNoteItCoords then
            print('[NOTEIT] No saved position to place.')
            if cb then cb({}) end
            return
        end
    end

    local rawText = tostring((data and data.text) or '')
    local text = rawText:sub(1, (Config and Config.MaxTextLength) or 160):gsub('%s+$','')
    if text == '' then
        if lib and lib.notify then
            lib.notify({ title = 'NoteIt', description = 'Text cannot be empty.', type = 'error' })
        end
        if cb then cb({}) end
        return
    end

    local place = tempNoteItCoords + vec3(0.0, 0.0, 0.48)
    placedNoteIts[#placedNoteIts + 1] = { coords = place, text = text }

    local maxLocal = (Config and Config.MaxLocalNotes) or 200
    if #placedNoteIts > maxLocal then table.remove(placedNoteIts, 1) end

    if Config and Config.DebugDev then
        print(('[noteit][DEBUG] Note created at %s'):format(
            json.encode({ x = place.x, y = place.y, z = place.z })
        ))
    end

    tempNoteItCoords = nil
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(250)
    isUsingNoteIt = false

    TriggerServerEvent('noteit:server:consumeItem')

    if cb then cb({}) end
end)

-- 3D text display if the player is nearby (throttled)
CreateThread(function()
    while true do
        local waitMs = 1000
        if #placedNoteIts > 0 then
            local p = GetEntityCoords(PlayerPedId())
            local maxDist = (Config and Config.ReadDistance) or 12.0
            for i = 1, #placedNoteIts do
                local note = placedNoteIts[i]
                if #(p - note.coords) < maxDist then
                    DrawText3D(note.coords, note.text)
                    waitMs = 5
                end
            end
        end
        Wait(waitMs)
    end
end)

-- cleanup when the resource stops
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    removePlacementZone()
    SetNuiFocus(false, false)
    TriggerScreenblurFadeOut(0)
end)
