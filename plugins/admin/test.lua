return function(msg)
    local token = msg.config.group_token
    ret = requests.post{'https://api.vk.com/method/photos.getMessagesUploadServer?access_token='..token..'&v=5.100'}.json()
    img = requests.get('https://sun9-42.userapi.com/c854424/v854424318/31d08/gSU3id3Aia0.jpg').text

    print(libkb.apisay{'хуй',msg.toho,photo=img}.text)
end