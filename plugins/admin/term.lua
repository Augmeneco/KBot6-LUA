return function(msg)
    ret = io.popen(msg.user_text):read('*a')
    libkb.apisay{ret,msg.toho}
end