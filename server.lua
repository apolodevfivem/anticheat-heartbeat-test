-- Apolo Dev --

local HeartBeats = {} -- aqui fica os players ativo com os heartbeats
local WaitingHeartBeat = {}

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
                -- Pode adicionar ban caso queira
            end
        end

        for ThisSource, OldOsTime in pairs(WaitingHeartBeat) do -- Verificando se depois que o player entrou ele foi pro heart beat default
            if (os.time() - OldOsTime) >= 90 then -- 1 minuto e 30 segundos
                if HeartBeats[ThisSource] then
                    WaitingHeartBeat[ThisSource] = nil -- Fazendo o exit da table pra evitar ficar verificando sempre
                else
                    WaitingHeartBeat[ThisSource] = nil
                    DropPlayer(ThisSource, "Suspeita de desativação de script")
                    -- Pode adicionar ban caso queira
                end
                -- Se a pessoa não se verificou ou seja, ao iniciar o resource client side esteja pausado então ele é kickado
            end
        end

        Wait(10000)
    end
end)

RegisterNetEvent("playerConnecting") -- Não tenho certeza que o playerconnecting funciona 100% das vezes altere caso prefira
AddEventHandler("playerConnecting", function()
    local source = source

    WaitingBeat[source] = os.time() -- Adicionando ao wait pra ser verificado depois pra ver se o player se conectou mesmo
end)

-- Duvidas: "Será se stopado o anticheat de começo ele não adicione automaticamente o source??"
-- Duvidas: "Se for adicionado um wait para quando o player conectar em menos de tal tempo ele não conectar seja dropado, porém pode ser que o resource seja stopado e fique mandando os heartbeat via trigger"
-- Duvidas: "Se a de cima ai for real então se for um trigger de 5 em 5 segundos pode se passar por um player com o resource rodando normalmente, possível solução abaixo"
-- Possível Solução: "Se for triggado de 5 em 5 segundos fora o script ou seja resource stopado e triggado de 5 em 5 segundos se passando por estar em heart beat ativo então coloca uma nova verificação,
-- a nova verificação consistiria em pedir uma informação do server para o client e o client retorna uma resposta aleatória e definida pelo server pra evitar o a informação claramente exposta do server aqui
-- exposta então, poderia ser criada uma resposta aleatória que não seja exposta justamente para evitar que o resource seja stopado e seja mais eficiente"