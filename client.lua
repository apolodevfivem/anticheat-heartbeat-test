-- Apolo Dev --

Citizen.CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            TriggerServerEvent("anticheat_heartbeat")
        end
        Wait(5000)
    end
end)