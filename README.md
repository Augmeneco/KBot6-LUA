## Оглавление

1. [Install](#Install)
2. [Config](#Config)
3. [Run](#Run)

# Install 
## Ubuntu 18.04
```bash
sudo apt install git lua5.1 luajit luarocks imagemagick libssl-dev libcurl4-nss-dev libsqlite3-dev

sudo luarocks install urlencode
sudo luarocks install split
sudo luarocks install lsqlite3
sudo luarocks install htmlparser
sudo luarocks install lua-llthreads2
sudo luarocks install lua-requests
sudo luarocks install inspect
sudo luarocks install Lua-cURL CURL_INCDIR=/usr/include/x86_64-linux-gnu/
sudo luarocks install utf8

git clone https://github.com/Augmeneco/KBot6-Lua
cd KBot6-Lua
luajit -O3 -b main.lua main
luajit -O3 -b libkbot-src.lua libkbot-dev.lua

luajit main
```

## Raspberry Pi
```bash
sudo apt install git lua5.1 luajit luarocks imagemagick libssl-dev libcurl4-nss-dev libsqlite3-dev

sudo luarocks install urlencode
sudo luarocks install split
sudo luarocks install lsqlite3
sudo luarocks install htmlparser
sudo luarocks install lua-llthreads2
sudo luarocks install lua-requests OPENSSL_LIBDIR=/usr/lib/arm-linux-gnueabihf
sudo luarocks install inspect
sudo luarocks install utf8
sudo luarocks --server=https://luarocks.org/dev  install Lua-cURL CURL_INCDIR=/usr/include/arm-linux-gnueabihf

git clone https://github.com/Augmeneco/KBot6-Lua
cd KBot6-Lua
luajit -O3 -b main.lua main
luajit -O3 -b libkbot-src.lua libkbot-dev.lua

```
# Config
Создай файл "bot.cfg" в папке "config" и заполни его нужной информацией
```json
{
"group_token":"токен группы",
"user_token":"токен юзера",
"group_id": ид,
"names":["луа","/","кб","кбот","kb","кл","kbot","карина","кв","бот","/кб"]
}

```
# Run
```bash
luajit main
```
