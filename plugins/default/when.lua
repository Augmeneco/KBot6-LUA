return function(msg)
    months = {'сентября','октября','ноября','декабря','января','февраля','марта','апреля','мая','июня','июля','августа'}
    math.randomseed(os.clock())
    randnum = math.random(1,10)
    libkb.apisay{'Я уверена '..msg.user_text..' '..math.random(1,31)..' '..months[math.random(1,#months)]..' '..math.random(2019,2050),msg.toho}
end