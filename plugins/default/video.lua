return function(msg)
    param = {v='5.90',q=msg.user_text,count=10,access_token=msg.config.user_token}
    items = requests.post{'https://api.vk.com/method/video.search',params=param}.json().response.items

    attachment = ''
    if #items ~= 0 then
        for _,item in pairs(items) do
            attachment = attachment..'video'..item.owner_id..'_'..item.id..','
        end
        libkb.apisay{'Видео по вашему запросу',msg.toho,attachment=attachment}
    else
        libkb.apisay('Видео по запросу не найдены :(',msg.toho)
    end
end