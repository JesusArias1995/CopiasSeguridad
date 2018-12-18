# Sistema Copias de Seguridad
Realizado con shell script con tar y rsync.
Utilizo instancia rajoy para almacenar en un volumen las copias realizadas.
Las copias completas semanales se harán el domingo y los demás días se irán haciendo copias incrementales.

### Creacion de Timers en Systemd
```sh
nano /etc/systemd/system/copias.service
```

```sh
[Unit]
Description=Copias de Seguridad

[Service]
User=root
Type=simple
ExecStart=/bin/bash /usr/local/sbin/copias.sh

[Install]
WantedBy=multi-user.target
```

```sh
nano /etc/systemd/system/copias.timer
```
```sh
[Unit]
Description=Copias de Seguridad

[Timer]
OnCalendar=*-*-* 23:15:00
Persistent=true

[Install]
WantedBy=multi-user.target
```
```sh
systemctl start copias.timer 
systemctl enable copias.timer 
```
```sh
root@rajoy:~# systemctl list-timers
NEXT                         LEFT          LAST                         PASSED    UNIT                   
Mon 2018-12-17 23:15:00 UTC  1min 26s left n/a                          n/a       copias.timer           
Tue 2018-12-18 06:51:26 UTC  7h left       Mon 2018-12-17 06:51:53 UTC  16h ago   apt-daily-upgrade.timer
Tue 2018-12-18 12:44:59 UTC  13h left      Mon 2018-12-17 22:43:31 UTC  30min ago apt-daily.timer        
Tue 2018-12-18 22:57:52 UTC  23h left      Mon 2018-12-17 22:57:52 UTC  15min ago systemd-tmpfiles-clean.

4 timers listed.
Pass --all to see loaded but inactive timers, too.
lines 1-8/8 (END)
```
