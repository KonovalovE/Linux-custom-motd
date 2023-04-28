# Linux-custom-motd
 Linux custom motd. System info

Installation
------------

Script runs only as root.
~~~
git clone https://github.com/KonovalovE/Linux-custom-motd.git
cd Linux-custom-motd
cp custom-motd.sh /usr/local/bin
chmod +x /usr/local/bin/custom-motd.sh
echo "/usr/local/bin/custom-motd.sh" > /etc/profile.d/motd.sh
~~~

Some dynmotd Options
--------------------

~~~
vim /usr/local/bin/custom-motd.sh
~~~

Вы можете включать или отключать информационные блоки 

~~~
## enable system related information about your system
SYSTEM_INFO="1"             # show system information
ENVIRONMENT_INFO="1"        # show environement information
STORAGE_INFO="1"            # show storage information
USER_INFO="1"               # show some user infomration
~~~

 * 1 = Включить
 * 0 = Выключить

