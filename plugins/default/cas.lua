return function(str)
    if libkb.check('photo',msg.longpoll.attachments[1]) then
        libkb.apisay{'Жмыхаю картинку... создание шок контента может занять до 20 секунд',msg.toho}
        ret = msg.longpoll.attachments[1].photo.sizes
        num = 0
        for _,size in pairs(ret) do 
            if size.width > num then 
                num = size.width
                img = size.url
            end
        end
        img = io.open('data/tmpfs/'..msg.userid..'.jpg','w'):write(requests.get(img).text)
        size = io.popen('identify -format "%G" data/tmpfs/'..msg.userid..'.jpg'):read('*a')
        io.popen('convert data/tmpfs/'..msg.userid..'.jpg -liquid-rescale 50x50%! data/tmpfs/'..msg.userid..'_out.jpg;rm data/tmpfs/'..msg.userid..'.jpg'):read('*a')
        io.popen('convert -resize '..size..' data/tmpfs/'..msg.userid..'_out.jpg data/tmpfs/'..msg.userid..'_out.jpg'):read('*a')
        img = io.open('data/tmpfs/'..msg.userid..'_out.jpg','r'):read('*a')
        io.popen('rm data/tmpfs/'..msg.userid..'_out.jpg')
        libkb.apisay{'Готово',msg.toho,photo=img}
    else
        libkb.apisay{'Картинку забыл сунуть',msg.toho}
    end
end