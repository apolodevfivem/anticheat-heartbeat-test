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

-- Duvidas: "Será se stopado o anticheat de começo ele não adicione automaticamente o source??"
-- Duvidas: "Se for adicionado um wait para quando o player conectar em menos de tal tempo ele não conectar seja dropado, porém pode ser que o resource seja stopado e fique mandando os heartbeat via trigger"
-- Duvidas: "Se a de cima ai for real então se for um trigger de 5 em 5 segundos pode se passar por um player com o resource rodando normalmente, possível solução abaixo"
-- Possível Solução: "Se for triggado de 5 em 5 segundos fora o script ou seja resource stopado e triggado de 5 em 5 segundos se passando por estar em heart beat ativo então coloca uma nova verificação,
-- a nova verificação consistiria em pedir uma informação do server para o client e o client retorna uma resposta aleatória e definida pelo server pra evitar o a informação claramente exposta do server aqui
-- exposta então, poderia ser criada uma resposta aleatória que não seja exposta justamente para evitar que o resource seja stopado e seja mais eficiente"