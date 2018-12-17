#!/bin/bash

FECHA=$(date +%d-%m-%Y)
EXCLUDEAZNAR={"/boot","/bin","/lib","/dev","/lib*","/media","/mnt","/proc","/usr","/sys","/sbin","/var","/run","/initrd.img*","/srv","/opt","/srv","/tmp","/vmlinuz*"}
EXCLUDEZAPATERO={"/boot","/bin","/lib","/dev","/lib*","/media","/mnt","/proc","/usr","/sys","/sbin","/var","/run","/initrd.img*","/srv","/opt","/srv","/tmp","/vmlinuz*"}

if [[ $(date +%u) -eq 7 ]]; then
  #Copia completa de aznar
  ssh root@10.0.0.13 "rsync -azvhe ssh --exclude=$EXCLUDEAZNAR / root@10.0.0.11:/copias/aznar/completa-$FECHA"
  cd /copias/aznar/completa-$FECHA/ && tar -zcf root.tar.gz root/ && gpg --encrypt --recipient JesusArias root.tar.gz && rm -rf root.tar.gz && rm -rf root/
  cd /copias/aznar && tar -zcf COMP-$FECHA.tar.gz completa-$FECHA/ && rm -rf completa-$FECHA


  #Copia completa de zapatero
  ssh root@10.0.0.3 "rsync -azvhe ssh --exclude=$EXCLUDEZAPATERO / root@10.0.0.11:/copias/zapatero/completa-$FECHA"
  cd /copias/zapatero/completa-$FECHA/ && tar -zcf root.tar.gz root/ && gpg --encrypt --recipient JesusArias root.tar.gz && rm -rf root.tar.gz && rm -rf root/
  cd /copias/zapatero && tar -zcf COMP-$FECHA.tar.gz completa-$FECHA/ && rm -rf completa-$FECHA

  #Copia completa de rajoy
  rsync -azv --exclude={"/boot","/bin","/lib","/dev","/lib*","/media","/mnt","/proc","/usr","/sys","/sbin","/var","/run","/initrd.img*","/srv","/opt","/srv","/tmp","/vmlinuz*","/copias"} / /copias/rajoy/completa-$FECHA
  cd /copias/rajoy/completa-$FECHA/ && tar -zcf root.tar.gz root/ && gpg --encrypt --recipient JesusArias root.tar.gz && rm -rf root.tar.gz && rm -rf root/
  cd /copias/rajoy && tar -zcf COMP-$FECHA.tar.gz completa-$FECHA/ && rm -rf completa-$FECHA

else
  #Copia incremental en aznar
  ssh root@10.0.0.13 "rsync -azvhe ssh --exclude=$EXCLUDEAZNAR / root@10.0.0.11:/copias/aznar/incrementales"
  cp -R /copias/aznar/incrementales/ /copias/aznar/incremental-$FECHA/
  cd /copias/aznar/incremental-$FECHA/ && tar -zcf root.tar.gz root/ && gpg --encrypt --recipient JesusArias root.tar.gz && rm -rf root.tar.gz && rm -rf root/
  cd /copias/aznar/ && tar -zcf INCR-$FECHA.tar.gz incremental-$FECHA/ && rm -rf incremental-$FECHA

  #Copia incremental en zapatero
  ssh root@10.0.0.3 "rsync -azvhe ssh --exclude=$EXCLUDEZAPATERO / root@10.0.0.11:/copias/zapatero/incrementales"
  cp -R /copias/zapatero/incrementales/ /copias/zapatero/incremental-$FECHA/
  cd /copias/zapatero/incremental-$FECHA/ && tar -zcf root.tar.gz root/ && gpg --encrypt --recipient JesusArias root.tar.gz && rm -rf root.tar.gz && rm -rf root/
  cd /copias/zapatero/ && tar -zcf INCR-$FECHA.tar.gz incremental-$FECHA/ && rm -rf incremental-$FECHA

  #Copia incremental en rajoy
  rsync -azv --exclude={"/boot","/bin","/lib","/dev","/lib*","/media","/mnt","/proc","/usr","/sys","/sbin","/var","/run","/initrd.img*","/srv","/opt","/srv","/tmp","/vmlinuz*","/copias"} / /copias/rajoy/incrementales
  cp -R /copias/rajoy/incrementales/ /copias/rajoy/incremental-$FECHA/
  cd /copias/rajoy/incremental-$FECHA/ && tar -zcf root.tar.gz root/ && gpg --encrypt --recipient JesusArias root.tar.gz && rm -rf root.tar.gz && rm -rf root/
  cd /copias/rajoy/ && tar -zcf INCR-$FECHA.tar.gz incremental-$FECHA/ && rm -rf incremental-$FECHA
fi
