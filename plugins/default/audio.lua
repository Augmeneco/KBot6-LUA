return function(msg)
    param = {v='5.90',q=msg.user_text,count=0,sort=2,access_token=msg.config.user_token}
    count = requests.post{'https://api.vk.com/method/audio.search',params=param}.json().response.count
    if count > 10 then count = count-10 end
    if count < 11 then count = 0 end
    math.randomseed(os.clock())
    param = {v='5.90',q=msg.user_text,offset=math.random(0,count),count=10,sort=2,access_token=msg.config.user_token}
    items = requests.post{'https://api.vk.com/method/audio.search',params=param}.json().response.items

    attachment = ''
    if #items ~= 0 then
        for _,item in pairs(items) do
            attachment = attachment..'audio'..item.owner_id..'_'..item.id..','
        end
        libkb.apisay{'Музыка по вашему запросу',msg.toho,attachment=attachment}
    else
        libkb.apisay('Музыка по запросу не найдена :(',msg.toho)
    end
end