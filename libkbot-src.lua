ins = require('inspect')
requests = require('requests')
urlencode = require('urlencode')
json = require('cjson')
split = require('split').split
threads = require("llthreads2")
sqlite = require('lsqlite3')
curl = require('cURL')
xml = require("xml")
htmlparser = require("htmlparser")

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
    db = sqlite.open(args[1])
    if #args == 2 then args[3] = '' end
    sqlret = {}
    for row in db:nrows('SELECT * FROM '..args[2]..' '..args[3]) do
        sqlret[#sqlret+1] = row
    end
    db:close()
    return sqlret
end

function funcs.sql_put(...)
    args = ...
    db = sqlite.open(args[1])
    
    values = '('
    for _,v in pairs(args[3]) do 
        if type(v) == 'string' then 
            values = values..'"'..v..'"'..','
        else
            values = values..v..','
        end
    end
    values = values..')'
    values = values:gsub(',%)','%)')

    sqlret = {}
    for row in db:nrows('INSERT INTO '..args[2]..' VALUES '..values) do
        sqlret[#sqlret+1] = row
    end
    db:close()
    return sqlret
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

--осторожно, говнокод
function funcs.continue() print(nil/nil) end

return funcs