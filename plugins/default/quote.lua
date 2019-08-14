return function(msg)
    arg = json.encode(msg)
    ret = io.popen("python3 plugins/python/quote.py '"..arg.."'"):read('*a')
    print(ret)
end