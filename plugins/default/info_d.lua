return function(msg)
    status = [[
        [ Статистика беседы ]
        Всего сообщений обработано: COUNT
        До следующего моего сообщения: NEXT  
    ]]
    stop = true
    while stop do
        xpcall(
            function()
                main = libkb.sql_get{'data/db','main','WHERE id='..msg.toho}
                stop = false
            end,
            function()end
    )
    end
    if msg.dialogs[msg.toho] == nil then msg.dialogs[msg.toho] = 0 end
    status = status:gsub('COUNT',main[1].count):gsub('NEXT',10-msg.dialogs[msg.toho])

    libkb.apisay{status,msg.toho}
end