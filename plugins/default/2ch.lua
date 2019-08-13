return function(msg)
    if msg.user_text == '' then msg.user_text = 'b' end
    math.randomseed(os.clock())
    xpcall(
        function()
            thread = requests.get('https://2ch.hk/'..msg.user_text..'/'..tostring(math.random(0,9)):gsub('0','index')..'.json').json().threads
            thread = thread[math.random(1,#thread)]
            url = 'https://2ch.hk/'..msg.user_text..'/res/'..thread.posts[1].num..'.html'
            text = 'Оригинал: '..url..'<br>'..thread.posts[1].comment:gsub('<(.*)>','')
            img = requests.get('https://2ch.hk'..thread.posts[1].files[1].path).text
            libkb.apisay{text,msg.toho,photo=img}
        end,function() libkb.apisay{'Такой борды не существует',msg.toho} end
    )
end