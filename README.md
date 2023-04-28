# Linux-custom-motd
 Linux custom motd. System info

Установка
------------

Все действия необходимо выполнять под root
~~~
git clone https://github.com/KonovalovE/Linux-custom-motd.git
cd Linux-custom-motd
cp custom-motd.sh /usr/local/bin
chmod +x /usr/local/bin/custom-motd.sh
echo "/usr/local/bin/custom-motd.sh" > /etc/profile.d/motd.sh
~~~

Изменение опций.
--------------------

~~~
vim /usr/local/bin/custom-motd.sh
~~~

Вы можете включать или отключать информационные блоки 

~~~
## Включите информацию о вашей системе.
SYSTEM_INFO="1"             # системная информация
ENVIRONMENT_INFO="1"        # информацию назначении системы
STORAGE_INFO="1"            # информацию о дисках
USER_INFO="1"               # некоторая информация о пользователе
~~~

 * 1 = Включить
 * 0 = Выключить

