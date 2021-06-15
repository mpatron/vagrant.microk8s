# Fabrication d'une VM vagrant

[==> go home](../README.md)

## Provisionning

~~~bash
sudo yum -y update
sudo yum -y install rng-tools ntpdate vim lsof nmap bind-utils dos2unix sshpass cockpit cockpit-dashboard policycoreutils-python
sudo sed -i -e "\\#PasswordAuthentication no# s#PasswordAuthentication no#PasswordAuthentication yes#g" /etc/ssh/sshd_config
sudo systemctl restart sshd
sudo cp /usr/lib/systemd/system/rngd.service /etc/systemd/system
sudo vim /usr/lib/systemd/system/rngd.service
# ExecStart=/sbin/rngd -f -r /dev/urandom
sudo systemctl daemon-reload
sudo systemctl status rngd -l
sudo systemctl enable rngd --now
sudo systemctl status rngd -l
sudo rngd -v
cat /proc/cpuinfo | grep rdrand
cat /dev/random | rngtest -c 1000
~~~

Compresssion de la surfaced disque

~~~bash
sudo yum -y install epel-release
sudo yum -y install zerofree
# Il faut se mettre sur la fenetre virtualbox et pas sur putty, sshd ne fonctionnera plus après cette commande :
sudo su -
sudo localectl set-keymap fr
sudo systemctl rescue
mount -o remount,ro /dev/sda1
zerofree -v /dev/sda1

cat /dev/null > ~/.bash_history && history -c && exit
exit
~~~

Exportation de la VM

~~~cmd
rm mycentos7.box
vagrant package --output mycentos7.box
vagrant box add mycentos7 mycentos7.box --force
~~~

Sorti d'écran

~~~bash
PS C:\TEMP\vagrant.mycentos7> vagrant ssh
Last login: Sat Aug  3 17:18:27 2019 from 10.0.2.2
[vagrant@localhost ~]$ sudo systemctl status rngd -l
● rngd.service - Hardware RNG Entropy Gatherer Daemon
   Loaded: loaded (/etc/systemd/system/rngd.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2019-08-04 18:55:47 UTC; 1min 5s ago
 Main PID: 433 (rngd)
   CGroup: /system.slice/rngd.service
           └─433 /sbin/rngd -f -r /dev/urandom -o /dev/random

Aug 04 18:55:47 localhost.localdomain systemd[1]: Started Hardware RNG Entropy Gatherer Daemon.
Aug 04 18:55:48 localhost.localdomain rngd[433]: Initalizing available sources
Aug 04 18:55:48 localhost.localdomain rngd[433]: Enabling RDSEED rng support
Aug 04 18:55:50 localhost.localdomain rngd[433]: Enabling JITTER rng support
[vagrant@localhost ~]$ cat /proc/cpuinfo | grep rdrand
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp lm constant_tsc art rep_good nopl nonstop_tsc extd_apicid pni pclmulqdq monitor ssse3 cx16 sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx rdrand hypervisor lahf_lm cr8_legacy abm sse4a misalignsse 3dnowprefetch retpoline_amd ssbd vmmcall fsgsbase avx2 rdseed clflushopt arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif
[vagrant@localhost ~]$ cat /dev/random | rngtest -c 1000
rngtest 6
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 999
rngtest: FIPS 140-2 failures: 1
rngtest: FIPS 140-2(2001-10-10) Monobit: 1
rngtest: FIPS 140-2(2001-10-10) Poker: 0
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=17.264; avg=70.754; max=19531250.000)Kibits/s
rngtest: FIPS tests speed: (min=103.660; avg=158.432; max=173.395)Mibits/s
rngtest: Program run time: 276165925 microseconds
[vagrant@localhost ~]$ cat /dev/null > ~/.bash_history && history -c && exit
logout
Connection to 127.0.0.1 closed.
PS C:\TEMP\vagrant.mycentos7> rm mycentos7.box
rm : Impossible de trouver le chemin d'accès « C:\TEMP\vagrant.mycentos7\mycentos7.box », car il n'existe pas.
Au caractère Ligne:1 : 1
+ rm mycentos7.box
+ ~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (C:\TEMP\vagrant.mycentos7\mycentos7.box:String) [Remove-Item], ItemNotFoundException
    + FullyQualifiedErrorId : PathNotFound,Microsoft.PowerShell.Commands.RemoveItemCommand

PS C:\TEMP\vagrant.mycentos7> vagrant package --output mycentos7.box
==> default: Attempting graceful shutdown of VM...
==> default: Clearing any previously set forwarded ports...
==> default: Exporting VM...
==> default: Compressing package to: C:/TEMP/vagrant.mycentos7/mycentos7.box
PS C:\TEMP\vagrant.mycentos7> vagrant box add mycentos7 mycentos7.box --force
==> box: Box file was not detected as metadata. Adding it directly...
==> box: Adding box 'mycentos7' (v0) for provider:
    box: Unpacking necessary files from: file://C:/TEMP/vagrant.mycentos7/mycentos7.box
    box:
==> box: Successfully added box 'mycentos7' (v0) for 'virtualbox'!
PS C:\TEMP\vagrant.mycentos7>
~~~

~~~powershell
vagrant up  --provider=virtualbox --provision
vagran ssh
vagrant destroy -f
~~~
