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
        img = requests.get('http://lunach.ru/?cum=&url='..url).text
        libkb.apisay{'Готово!',msg.toho,photo=img}
    else
        libkb.apisay{'Картинку забыл сунуть',msg.toho}
    end
end