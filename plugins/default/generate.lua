return function(msg)
    stop = true
    db = sqlite.open('data/db')
    while stop do
        xpcall(
            function()
                main = libkb.sql_get{db,'main','WHERE id='..msg.toho}
                if #main == 0 then
                    libkb.apisay{'Увы но по какой-то причине бд вашей беседы пуста 0_o',msg.toho}
                else
                    dict = json.decode(main[1].json)
                    text = libkb.mc_generate(dict)
                    libkb.apisay{text,msg.toho}
                    stop = false
                end
            end,function()end
        )
    end
end