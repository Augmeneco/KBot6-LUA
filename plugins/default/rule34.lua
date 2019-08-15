return function(msg)
    blacklist = '-anthro+-fur+-scat*+-darling_in_the_franxx+-furry+-dragon+-guro+-animal_penis+-animal+-wolf+-fox+-webm+-my_little_pony+-monster*+-3d+-animal*+-ant+-insects+-mammal+-horse+-blotch+-deer+-real*+-shit+-everlasting_summer+-copro*+-wtf+'
    url = 'https://rule34.xxx/index.php?page=dapi&s=post&q=index&limit=1000&tags='..blacklist..msg.user_text:gsub('%s','+')

    index = libkb.curl_proxy(url)
    
    index = xml.load(index)
    if tonumber(index.count) > 0 then
        math.randomseed(os.clock())
        rand = math.random(1,#index)
        img = libkb.curl_proxy(index[rand].file_url)
        tags = index[rand].tags
        libkb.apisay{'Дрочевня подкатила<br>('..rand..'/'..index.count..')<br>----------<br>Остальные теги: '..tags,msg.toho,photo=img}
    else
        libkb.apisay{'Ничего не найдено :(',msg.toho}
    end

end
