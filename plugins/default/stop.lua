return function(msg)
    stop = true
    while stop do
        xpcall(
            function()
                db = sqlite.open('data/db')
                main = libkb.sql_get{db,'main','WHERE id='..msg.toho}
                if #main > 0 then
                    if json.decode(main[1].data)['ignore'] == nil then
                        main = json.decode(main[1].data)
                        main['ignore'] = true
                        action = 'ignore'
                    else
                        main = json.decode(main[1].data)
                        main['ignore'] = nil
                        action = 'delete'
                    end
                end
                db:exec('UPDATE main SET data=\''..json.encode(main)..'\' WHERE id='..msg.toho)
                stop = false
            end,
            function(err)end
        )
    end
    if action == 'ignore' then
        libkb.apisay{'Беседа добавлена в игнор :(, чтобы вернуть её в актив пропиши эту же команду снова',msg.toho}
    else
        libkb.apisay{'Беседа удалена из игнора :)',msg.toho} 
    end
end