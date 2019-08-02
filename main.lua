libkb = require('libkbot-dev')

config = json.decode(io.open('./config/bot.cfg','r'):read("*a"))
cmds = json.decode(io.open('./config/cmds.cfg','r'):read("*a"))

plugins = {}
for _,dir in pairs(libkb.scandir('./plugins')) do 
    plugins[dir] = {}
    for _,plugin in pairs(libkb.scandir('./plugins/'..dir)) do 
        plugin = string.gsub(plugin,'.lua','')
        plugins[dir][plugin] = require("plugins/"..dir.."/"..plugin)
    end 
end

lpb = requests.post{'https://api.vk.com/method/groups.getLongPollServer',params={access_token=config.group_token, v='5.80',group_id=config.group_id}}.json().response
ts = lpb.ts

bot_stat = {msgs=0,cmds=0,work_start=os.time()}
while true do
    xpcall(
        function()
            result = requests.post(lpb.server..'?act=a_check&key='..lpb.key..'&ts='..ts..'&wait=25').json()
            if libkb.check('failed',result) then 
                lpb = requests.post{'https://api.vk.com/method/groups.getLongPollServer',params={access_token=config.group_token, v='5.80',group_id=config.group_id}}.json().response
                ts = lpb.ts
                result = requests.post(lpb.server..'?act=a_check&key='..lpb.key..'&ts='..ts..'&wait=25').json()
            end
            bot_stat.msgs = bot_stat.msgs+1
            ts = result.ts
            result = result.updates[1]
            text = result.object.text
            msgid = result.object.conversation_message_id
            toho = result.object.peer_id
            userid = result.object.from_id
            text_split = split(text,' ')
            if libkb.check(text_split[1],config.names) then
                bot_stat.cmds = bot_stat.cmds+1
                print(os.date('%H:%M:%S')..'| Упоминание Кбота в '..toho..' с текстом '..text)
                if libkb.check(text_split[2],cmds) then
                    user_text = split(text,' ')
                    table.remove(user_text,1)
                    table.remove(user_text,1)
                    user_text = table.concat(user_text,' ')

                    msg = {}
                    msg.toho = toho
                    msg.text = text
                    msg.userid = userid
                    msg.text_split = text_split
                    msg.user_text = user_text
                    msg.plugin = 'plugins/'..cmds[text_split[2]][1]..'/'..cmds[text_split[2]][2]
                    msg.config = config
                    msg.bot_stat = bot_stat

                    thread = threads.new("libkb = require('libkbot-dev') msg = ... require(msg.plugin)(msg)",msg)
                    assert(thread:start(true))
                else
                    user_text = split(text,' ')
                    table.remove(user_text,1)
                    user_text = table.concat(user_text,' ')
                    ret = requests.get{'https://isinkin-bot-api.herokuapp.com/1/talk',params={q=urlencode.encode_url(user_text)}}
                    libkb.apisay(ret.json().text,toho)
                end
            end
        end,libkb.errorhandler
    )
end