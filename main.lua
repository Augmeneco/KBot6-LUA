libkb = require('libkbot-dev')

config = json.decode(io.open('./config/bot.cfg','r'):read("*a"))
cmds = json.decode(io.open('./config/cmds.cfg','r'):read("*a"))

lpb = requests.post{'https://api.vk.com/method/groups.getLongPollServer',params={access_token=config.group_token, v='5.80',group_id=config.group_id}}.json().response
ts = lpb.ts

bot_stat = {msgs=0,cmds=0,work_start=os.time()}

while true do
    xpcall(
        function()
            updates = requests.post(lpb.server..'?act=a_check&key='..lpb.key..'&ts='..ts..'&wait=25').json()
            if libkb.check('failed',updates) then 
                lpb = requests.post{'https://api.vk.com/method/groups.getLongPollServer',params={access_token=config.group_token, v='5.80',group_id=config.group_id}}.json().response
                ts = lpb.ts
                updates = requests.post(lpb.server..'?act=a_check&key='..lpb.key..'&ts='..ts..'&wait=25').json()
            end
            bot_stat.msgs = bot_stat.msgs+1
            ts = updates.ts
            for _,result in pairs(updates.updates) do 
                text = result.object.text
                msgid = result.object.conversation_message_id
                toho = result.object.peer_id
                userid = result.object.from_id
                text_split = split(text,' ')
				if utf8.lower(text_split[1]) == 'f' and userid > 0 then
					libkb.apisay{'F',toho,attachment='photo-158856938_457255856',token = config.group_token}
				end
                if libkb.check(utf8.lower(text_split[1]),config.names) then
                    bot_stat.cmds = bot_stat.cmds+1
                    print(os.date('%H:%M:%S')..' | Упоминание Кбота в '..toho..' с текстом '..text)
                    if libkb.check(text_split[2],cmds) then
                        user_text = split(text,' ')
                        table.remove(user_text,1)
                        table.remove(user_text,1)
                        user_text = table.concat(user_text,' ')
                        
                        msg = {}
                        msg.longpoll = result.object
                        msg.toho = toho
                        msg.text = text
                        msg.userid = userid
                        msg.text_split = text_split
                        msg.user_text = user_text
                        msg.plugin = 'plugins/'..cmds[text_split[2]][1]..'/'..cmds[text_split[2]][2]
                        msg.config = config
                        msg.bot_stat = bot_stat

                        user_info = libkb.sql_get{'data/users.db','users','WHERE id='..userid}
                        
                        if #user_info == 0 then
                            user_info[#user_info+1] = {userid,1,'{}'}
                            libkb.sql_put{'data/users.db','users',{userid,1,'{}'}}
                        end
                        pass = true
                        if cmds[text_split[2]][1] == 'admin' and user_info[1].perm ~= 3 then
                            libkb.apisay{'Не дорос до админки :(',toho}
                            pass = false
                        end
                        if cmds[text_split[2]][1] == 'vip' and user_info[1].perm == 1 then
                            libkb.apisay{'У тебя нет випки чтобы юзать эту команду',toho}
                            pass = false
                        end
                        if pass then
                            thread = threads.new(function(...) libkb = require('libkbot-dev') msg = ... require(msg.plugin)(msg) end,msg)
                            assert(thread:start(true))
                        end
                    else
                        user_text = split(text,' ')
                        table.remove(user_text,1)
                        user_text = table.concat(user_text,' ')
                        if not libkb.check(text_split[2],{'34pic','34gif','34tag'}) then
                            ret = requests.get{'https://isinkin-bot-api.herokuapp.com/1/talk',params={q=urlencode.encode_url(user_text)}}
                            libkb.apisay{ret.json().text,toho,token = config.group_token}
                        end
                    end
                end
            end
        end,libkb.errorhandler
    )
end
