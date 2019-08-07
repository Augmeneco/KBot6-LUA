ins = require('inspect')
requests = require('requests')
urlencode = require('urlencode')
json = require('dkjson')
split = require('split').split
threads = require("llthreads2")
re = require('rex_pcre')
sqlite = require('lsqlite3')

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
    print( "ERROR:", err )
end

function funcs.apisay(text,toho)
    if msg.config ~= nil then config = msg.config end
    local params = {access_token=config.group_token,v='5.80',peer_id=toho,message=urlencode.encode_url(text)}
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

--осторожно, говнокод
function funcs.continue() print(nil/nil) end

return funcs