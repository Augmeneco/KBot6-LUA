return function(msg)
    text = [[ [ ОБЫЧНЫЙ ЮЗЕР ]
&#8195;kb_name ген - сгенерировать текст из сообщений этой беседы
&#8195;kb_name стоп - добавить беседу в игнор для генератора текста каждые 10 сообщений
&#8195;kb_name инфо - статистика обучения в данной беседе
&#8195;kb_name жмых - сжимает изображение через CAS
&#8195;kb_name 34 - хентай с rule34 по тегу
&#8195;kb_name кончи - кончить на картинку
&#8195;kb_name что - определяет что на изображении
&#8195;kb_name 34gif - поиск хентайных гифок (от Lanode)
&#8195;kb_name 34pic - поиск хентайных картинок (от Lanode)
&#8195;kb_name двач - рандомный тред из b, либо указанной борды
&#8195;kb_name инфа - вероятность текста
&#8195;kb_name стата - статистика бота
&#8195;kb_name музыка - поиск музыки по запросу
&#8195;kb_name видео - поиск видео по запросу
&#8195;kb_name доки - поиск документов по запросу
&#8195;kb_name когда - когда произойдет событие

Автор бота - [id354255965|Кикер] ]]
    text = text:gsub('kb_name',msg.text_split[1])
    libkb.apisay{text,msg.toho}
end