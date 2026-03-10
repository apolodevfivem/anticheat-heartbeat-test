-- Apolo Dev --

local HeartBeats = {} -- aqui fica os players ativo com os heartbeats

-- Aqui é o evento que vai receber os heartbeat 
RegisterNetEvent("anticheat_heartbeat")
AddEventHandler("anticheat_heartbeat", function()
    local source = source

    HeartBeats[source] = os.time()
end)

-- Thread principal das verificação em tempo dos heartbeat
CreateThread(function()
    while true do
        for ThisSource, OldOsTime in pairs(HeartBeats) do
            if (os.time() - OldOsTime) >= 30 then -- Maior que 30 segundos
                DropPlayer(ThisSource, "Suspeita de desativação de script")
            end
        end

        Wait(10000)
    end
end)