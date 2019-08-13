return function(str)
    if libkb.check('photo',msg.longpoll.attachments[1]) then
        ret = msg.longpoll.attachments[1].photo.sizes
        num = 0
        for _,size in pairs(ret) do 
            if size.width > num then 
                num = size.width
                url = size.url
            end
        end
        url = 'https://yandex.ru/images/search?url='..url..'&rpt=imageview'


        index = htmlparser.parse(libkb.curl_proxy(url)) --яндекс мрази забанили меня(
        root = index('div.tags__wrapper > a')
        tags = ''
        for _,e in pairs(root) do 
            tags = tags..'• '..e:getcontent()..'<br>'
        end
        libkb.apisay{'Я думаю на изображении что-то из этого: <br>'..tags,msg.toho}
    else
        libkb.apisay{'Картинку забыл сунуть',msg.toho}
    end
end