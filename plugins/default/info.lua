return function(msg)
    math.randomseed(os.clock())
    libkb.apisay("Вероятность того, что "..msg.user_text..", равна "..math.random(1,146)..'%',msg.toho)
end