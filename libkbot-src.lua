ins = require('inspect')
requests = require('requests')
urlencode = require('urlencode')
json = require('cjson')
split = require('split').split
threads = require("llthreads2.ex")
sqlite = require('lsqlite3')
curl = require('cURL')
xml = require("xml")
htmlparser = require("htmlparser")
utf8 = require('utf8')

funcs = {}

function funcs.scandir(directory) 
    local i, t, popen = 0, {}, io.popen 
    local pfile = popen('ls -a "'..directory..'"') 
    for filename in pfile:lines() do 
        if not funcs.check(filename,{'.','..'}) then
            i = i + 1 
            t[i] = filename 
        end
    end 
    pfile:close() 
    return t
end

function funcs.check(str,t)
    for _, v in pairs(t) do
        if v == str then return true end
    end
    return t[str] ~= nil
end

function funcs.errorhandler( err )
    if string.find(err,'wantread') then return 0 end
    if string.find(err,'arithmetic on a nil value') then return 0 end
    if string.find(err,'number/string expected') then return 0 end
    if string.find(err,'attempt to call a boolean value') then return 0 end
    print( "ERROR:", err )
end

function funcs.apisay(...)
    args = ...
    if args.photo ~= nil then
        ret = requests.get('https://api.vk.com/method/photos.getMessagesUploadServer?access_token='..msg.config.group_token..'&v=5.100').json()
        curl.easy{
            url = ret.response.upload_url,
            ssl_verifypeer = false,
            ssl_verifyhost = false,
            httppost = curl.form{
                file = {
                    data = args.photo,
                    name = "shit.jpg",
                    type='image/jpeg'
                }
            },
            writefunction = function(str)
                ret = json.decode(str)
            end
        }:perform()
        ret = requests.get('https://api.vk.com/method/photos.saveMessagesPhoto?v=5.100&server='..ret.server..'&photo='..ret.photo..'&hash='..ret.hash..'&access_token='..msg.config.group_token).json()
        args.attachment = 'photo'..ret.response[1].owner_id..'_'..ret.response[1].id
    end
    if args.token ~= nil then
        msg = {config={}}
        msg.config.group_token = args.token
    end
    params = {access_token=msg.config.group_token,v='5.80',peer_id=args[2],message=urlencode.encode_url(args[1]),attachment=args.attachment}
    return requests.post{'https://api.vk.com/method/messages.send',params=params}
end

function funcs.sql_get(...)
    args = ...
    if type(args[1]) == 'string' then
        db = sqlite.open(args[1])
    else
        db = args[1]
    end
    if #args == 2 then args[3] = '' end
    sqlret = {}
    for row in db:nrows('SELECT * FROM '..args[2]..' '..args[3]) do
        sqlret[#sqlret+1] = row
    end
    return sqlret
end

function funcs.sql_put(...)
    args = ...
    if type(args[1]) == 'string' then
        db = sqlite.open(args[1])
    else
        db = args[1]
    end
    values = '('
    for _,v in pairs(args[3]) do 
        if type(v) == 'string' then 
            values = values..'\''..v..'\''..','
        else
            values = values..v..','
        end
    end
    values = values..')'
    values = values:gsub(',%)','%)')

    db:exec('INSERT INTO '..args[2]..' VALUES '..values)
end

function funcs.curl_proxy(url)
    ret = ''
    c = curl.easy{
        url = url,
        ssl_verifypeer = false,
        ssl_verifyhost = false,
        writefunction = function(str) ret = ret..str end
    }
    c:setopt(curl.OPT_PROXYTYPE, curl.PROXY_SOCKS5_HOSTNAME)
    c:setopt(curl.OPT_PROXY, 'socks5h://localhost:9050')
    c:setopt(curl.OPT_PROXYPORT, 9050)
    c:perform()
    return ret
end

function funcs.mc_add()
    main = libkb.sql_get{db,'main','WHERE id='..toho}
    if #main == 0 then
        dict = {}
        count = 1
    else
        dict = json.decode(main[1].json)
        count = main[1].count
    end
    text = 'START '..utf8.lower(text)..' END'
    text = text:gsub('[.()!]',''):gsub('\n',' ')
    text = split(text,' ')
    for key,word in pairs(text) do
        if dict[word] == nil then
            dict[word] = {text[key+1]}
        else
            table.insert(dict[word],text[key+1])
        end
    end
    if #main == 0 then
        libkb.sql_put{db,'main',{toho,json.encode(dict),1,'{}'}}
    else
        db:exec('UPDATE main SET json=\''..json.encode(dict)..'\', count = '..(count+1)..' WHERE id='..toho)
    end
end

function funcs.mc_generate(dict)
    math.randomseed(os.time())
    word = dict['START'][math.random(1,#dict['START'])]
    out = word..' '
    keys = {}
    for k,_ in pairs(dict) do
        table.insert(keys,k)
    end
    while true do
        if dict[word] ~= nil then
            word = dict[word]
        else
            math.randomseed(os.clock())
            word = dict[keys[math.random(1,#keys)]]
        end
        word = word[math.random(1,#word)]
        if word ~= nil then
            out = out..word..' '
        end
        if word == 'END' then break end
    end
    out = out:gsub('END','')
    return out
end

--осторожно, говнокод
function funcs.continue() print(nil/nil) end

return funcs
