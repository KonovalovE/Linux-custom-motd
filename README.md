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
Фаил конфигурации /opt/.CNTEC/environment.cfg

~~~
## Включите информацию о вашей системе.

SYSENV="TST"                # тип сервера
SYSFUNCTION="TEST0"         # функциональность сервера
SYSSLA="SLA0"               # уровень обслуживания сервера
SYSNOTE="Test server"       # краткое описание сервера
ONLY_ROOT="n"               # включить уведомление только для root
SYSTEM_INFO="y"             # системная информация
ENVIRONMENT_INFO="y"        # информацию назначении системы
STORAGE_INFO="y"            # информацию о дисках
USER_INFO="y"               # некоторая информация о пользователе

~~~

 * y = Включить
 * n = Выключить

