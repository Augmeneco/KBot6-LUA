return function(msg)
    kickid = msg.user_text:gsub('%d+')
    params = {access_token=msg.config.group_token,chat_id=msg.toho-2000000000,member_id=kickid,v='5.90'}
    requests.post{'https://api.vk.com/method/messages.removeChatUser',params=params}
end