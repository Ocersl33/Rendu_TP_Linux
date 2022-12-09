# TP2 : Appréhender l'environnement Linux
## I. Service SSH
1. Analyse du service
🌞 S'assurer que le service sshd est démarré
```
[oceane@coucou ~]$ sudo systemctl status sshd 
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2022-12-05 12:05:33 CET; 19min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 685 (sshd)
      Tasks: 1 (limit: 5904)
     Memory: 5.8M
        CPU: 375ms
     CGroup: /system.slice/sshd.service
             └─685 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Dec 05 12:05:33 coucou systemd[1]: Started OpenSSH server daemon.
Dec 05 12:07:36 coucou unix_chkpwd[855]: password check failed for user (root)
Dec 05 12:07:36 coucou sshd[853]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.56.111  user=root
Dec 05 12:07:38 coucou sshd[853]: Failed password for root from 192.168.56.111 port 50053 ssh2
Dec 05 12:07:47 coucou unix_chkpwd[856]: password check failed for user (root)
Dec 05 12:07:49 coucou sshd[853]: Failed password for root from 192.168.56.111 port 50053 ssh2
Dec 05 12:07:52 coucou sshd[853]: Connection reset by authenticating user root 192.168.56.111 port 50053 [preauth]
Dec 05 12:07:52 coucou sshd[853]: PAM 1 more authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.56.111  user=root
Dec 05 12:08:02 coucou sshd[857]: Accepted password for oceane from 192.168.56.111 port 50054 ssh2
Dec 05 12:08:03 coucou sshd[857]: pam_unix(sshd:session): session opened for user oceane(uid=1000) by (uid=0)
```

🌞 Analyser les processus liés au service SSH
```
[oceane@coucou ~]$ ps -ef | grep sshd
root         685       1  0 12:05 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         857     685  0 12:07 ?        00:00:00 sshd: oceane [priv]
oceane       871     857  0 12:08 ?        00:00:00 sshd: oceane@pts/0
oceane      1022     872  0 12:34 pts/0    00:00:00 grep --color=auto sshd
```
🌞 Déterminer le port sur lequel écoute le service SSH
```
[oceane@coucou ~]$ ss | grep ssh
tcp   ESTAB  0      52                  192.168.56.110:ssh       192.168.56.111:50054
```
🌞 Consulter les logs du service SSH
```
[oceane@coucou ~]$ journalctl | grep ssh
Dec 05 12:05:30 coucou systemd[1]: Created slice Slice /system/sshd-keygen.
Dec 05 12:05:31 coucou systemd[1]: Reached target sshd-keygen.target.
Dec 05 12:05:33 coucou sshd[685]: Server listening on 0.0.0.0 port 22.
Dec 05 12:05:33 coucou sshd[685]: Server listening on :: port 22.
Dec 05 12:07:36 coucou sshd[853]: pam_unix(sshd:auth): authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.56.111  user=root
Dec 05 12:07:38 coucou sshd[853]: Failed password for root from 192.168.56.111 port 50053 ssh2
Dec 05 12:07:49 coucou sshd[853]: Failed password for root from 192.168.56.111 port 50053 ssh2
Dec 05 12:07:52 coucou sshd[853]: Connection reset by authenticating user root 192.168.56.111 port 50053 [preauth]
Dec 05 12:07:52 coucou sshd[853]: PAM 1 more authentication failure; logname= uid=0 euid=0 tty=ssh ruser= rhost=192.168.56.111  user=root
Dec 05 12:08:02 coucou sshd[857]: Accepted password for oceane from 192.168.56.111 port 50054 ssh2
Dec 05 12:08:03 coucou sshd[857]: pam_unix(sshd:session): session opened for user oceane(uid=1000) by (uid=0)
Dec 05 12:24:49 coucou sudo[980]:   oceane : TTY=pts/0 ; PWD=/home/oceane ; USER=root ; COMMAND=/bin/systemctl status sshd
```

```
[oceane@coucou /]$ cd var/log
[oceane@coucou log]$ ls
anaconda       chrony         cron-20221205    firewalld            lastlog           maillog-20221205   messages-20221205  secure-20221110  spooler-20221110  tallylog
audit          cron           dnf.librepo.log  hawkey.log           maillog           messages           private            secure-20221128  spooler-20221128  wtmp
btmp           cron-20221110  dnf.log          hawkey.log-20221110  maillog-20221110  messages-20221110  README             secure-20221205  spooler-20221205
btmp-20221205  cron-20221128  dnf.rpm.log      kdump.log            maillog-20221128  messages-20221128  secure             spooler          sssd
```
 se sont les fichiers "secure"

2. Modification du service
🌞 Identifier le fichier de configuration du serveur SSH

```
[oceane@coucou /]$ cd etc/ssh/; ls
moduli      ssh_config.d  sshd_config.d       ssh_host_ecdsa_key.pub  ssh_host_ed25519_key.pub  ssh_host_rsa_key.pub
ssh_config  sshd_config   ssh_host_ecdsa_key  ssh_host_ed25519_key    ssh_host_rsa_key
```
le nom du fichier est: ssh_config 

🌞 Modifier le fichier de conf
```
[oceane@coucou ssh]$ echo $RANDOM
64
```
```
[oceane@coucou ssh]$ sudo cat sshd_config | grep -i port
# If you want to change the port on a SELinux system, you have to tell
# semanage port -a -t ssh_port_t -p tcp #PORTNUMBER
Port 64
# WARNING: 'UsePAM no' is not supported in Fedora and may cause several
#GatewayPorts no
```
```
[oceane@coucou ssh]$ sudo systemctl restart sshd
```
```
[oceane@coucou ssh]$ sudo firewall-cmd --add-port=64/tcp --permanent
[sudo] password for oceane:
success
[oceane@coucou ssh]$ sudo firewall-cmd --reload
success
```
```
[oceane@coucou ssh]$ ss -alptn
State                 Recv-Q                Send-Q                                Local Address:Port                                 Peer Address:Port                Process
LISTEN                0                     128                                         0.0.0.0:64                                        0.0.0.0:*
LISTEN                0                     128                                            [::]:64                                           [::]:*
```
🌞 Effectuer une connexion SSH sur le nouveau port
```
PS C:\Users\rouss> ssh -p 64 oceane@192.168.56.110
oceane@192.168.56.110's password:
Last login: Tue Dec  6 11:09:01 2022 from 192.168.56.111
[oceane@coucou ~]$
```
## II. Service HTTP
1. Mise en place
🌞 Installer le serveur NGINX
```
[oceane@coucou ssh]$ sudo dnf --enablerepo=devel install nginx
[sudo] password for oceane:
Rocky Linux 9 - Devel WARNING! FOR BUILDROOT ONLY DO NOT LEAVE ENABLED                                                                                       6.0 MB/s |  12 MB     00:02
Last metadata expiration check: 0:00:07 ago on Tue 06 Dec 2022 12:33:38 PM CET.
Dependencies resolved.
=============================================================================================================================================================================================
 Package                                           Architecture                           Version                                            Repository                                 Size
=============================================================================================================================================================================================
Installing:
 nginx                                             x86_64                                 1:1.20.1-13.el9                                    appstream                                  38 k
Installing dependencies:
 nginx-core                                        x86_64                                 1:1.20.1-13.el9                                    appstream                                 567 k
 nginx-filesystem                                  noarch                                 1:1.20.1-13.el9                                    appstream                                  11 k
 rocky-logos-httpd                                 noarch                                 90.13-1.el9                                        appstream                                  24 k

Transaction Summary
=============================================================================================================================================================================================
Install  4 Packages

Total download size: 640 k
Installed size: 1.8 M
Is this ok [y/N]: y
Downloading Packages:
(1/4): nginx-filesystem-1.20.1-13.el9.noarch.rpm                                                                                                             112 kB/s |  11 kB     00:00
(2/4): nginx-1.20.1-13.el9.x86_64.rpm                                                                                                                        338 kB/s |  38 kB     00:00
(3/4): rocky-logos-httpd-90.13-1.el9.noarch.rpm                                                                                                              203 kB/s |  24 kB     00:00
(4/4): nginx-core-1.20.1-13.el9.x86_64.rpm                                                                                                                   3.1 MB/s | 567 kB     00:00
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                        909 kB/s | 640 kB     00:00
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                                                                                                                                     1/1
  Running scriptlet: nginx-filesystem-1:1.20.1-13.el9.noarch                                                                                                                             1/4
  Installing       : nginx-filesystem-1:1.20.1-13.el9.noarch                                                                                                                             1/4
  Installing       : nginx-core-1:1.20.1-13.el9.x86_64                                                                                                                                   2/4
  Installing       : rocky-logos-httpd-90.13-1.el9.noarch                                                                                                                                3/4
  Installing       : nginx-1:1.20.1-13.el9.x86_64                                                                                                                                        4/4
  Running scriptlet: nginx-1:1.20.1-13.el9.x86_64                                                                                                                                        4/4
  Verifying        : rocky-logos-httpd-90.13-1.el9.noarch                                                                                                                                1/4
  Verifying        : nginx-filesystem-1:1.20.1-13.el9.noarch                                                                                                                             2/4
  Verifying        : nginx-1:1.20.1-13.el9.x86_64                                                                                                                                        3/4
  Verifying        : nginx-core-1:1.20.1-13.el9.x86_64                                                                                                                                   4/4

Installed:
  nginx-1:1.20.1-13.el9.x86_64             nginx-core-1:1.20.1-13.el9.x86_64             nginx-filesystem-1:1.20.1-13.el9.noarch             rocky-logos-httpd-90.13-1.el9.noarch

Complete!
```
🌞 Démarrer le service NGINX
```
[oceane@coucou sbin]$ sudo systemctl start nginx
Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service
```
🌞 Déterminer sur quel port tourne NGINX
`````
[oceane@coucou /]$ sudo ss -alnpt |grep nginx
LISTEN 0   511     0.0.0.0:80
0.0.0.0:*  users:
(("nginx",pid=11473,fd=6),
("nginx",pid=11472,fd=6))
LISTEN 0   511    [::]:80        [::]:*
users:(("nginx",pid=11473,fd=7),
("nginx",pid=11472,fd=7))      
`````

🌞 Déterminer le path du fichier de configuration de NGINX
```
[oceane@coucou /]$ which nginx
/usr/sbin/nginx
[oceane@coucou /]$ ls -al /usr/sbin/nginx
-rwxr-xr-x. 1 root root 1330200 Oct 31 16:37 /usr/sbin/nginx
```


