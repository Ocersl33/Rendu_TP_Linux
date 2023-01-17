## TP6 : Travail autour de la solution NextCloud
## Module 1 : Reverse Proxy
🌞 On utilisera NGINX comme reverse proxy

.installer le paquet nginx
````powershell
[oceane@localhost ~]$ sudo dnf install -y nginx bind-utils nmap nc tcpdump vim traceroute nano dhclient
```` 
.démarrer le service nginx
 ````powershell
[oceane@localhost ~] sudo systemctl start nginx 
````
````powershell

[oceane@localhost ~] sudo systemctl status nginx 
````
.utiliser la commande ss pour repérer le port sur lequel NGINX écoute
````powershell
[oceane@localhost ~]$ sudo ss -alnpt
State               Recv-Q              Send-Q                           Local Address:Port                           Peer Address:Port             Process
LISTEN              0                   128                                    0.0.0.0:22                                  0.0.0.0:*                 users:(("sshd",pid=690,fd=3))
LISTEN              0                   128                                       [::]:22                                     [::]:*                 users:(("sshd",pid=690,fd=4))
LISTEN              0                   511                                          *:80                                        *:*                 users:(("httpd",pid=712,fd=4),("httpd",pid=711,fd=4),("httpd",pid=710,fd=4),("httpd",pid=688,fd=4))
````
.ouvrir un port dans le firewall pour autoriser le trafic vers NGINX
```powershell
[oceane@localhost ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
[sudo] password for oceane:
success
````
.utiliser une commande ps -ef pour déterminer sous quel utilisateur tourne NGINX
````powershell 
[oceane@localhost ~]$ sudo ps -ef | grep nginx
oceane     11180    1119  0 18:56 pts/0    00:00:00 grep --color=auto nginx
````
.vérifier que le page d'accueil NGINX est disponible en faisant une requête HTTP sur le port 80 de la machine
```` powershell
[oceane@localhost ~]$ curl http://localhost:80

  </ul>
        <p>For more information about Rocky Linux, please visit the
          <a href="https://rockylinux.org/"><strong>Rocky Linux
          website</strong></a>.
        </p>
        </div>
      </div>
      <div class='col-sm-12 col-md-6 col-md-6 col-md-offset-12'>
        <div class='section'>

          <h2>I am the admin, what do I do?</h2>

        <p>You may now add content to the webroot directory for your
        software.</p>

        <p><strong>For systems using the
        <a href="https://httpd.apache.org/">Apache Webserver</strong></a>:
        You can add content to the directory <code>/var/www/html/</code>.
        Until you do so, people visiting your website will see this page. If
        you would like this page to not be shown, follow the instructions in:
        <code>/etc/httpd/conf.d/welcome.conf</code>.</p>

        <p><strong>For systems using
        <a href="https://nginx.org">Nginx</strong></a>:
        You can add your content in a location of your
        choice and edit the <code>root</code> configuration directive
        in <code>/etc/nginx/nginx.conf</code>.</p>

        <div id="logos">
          <a href="https://rockylinux.org/" id="rocky-poweredby"><img src="icons/poweredby.png" alt="[ Powered by Rocky Linux ]" /></a> <!-- Rocky -->
          <img src="poweredby.png" /> <!-- webserver -->
        </div>
      </div>
      </div>

      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>

  </body>
</html>
```` 


🌞 Configurer NGINX

.créer un fichier de configuration NGINX
````powershell
[oceane@localhost ~]$ touch nginx

[oceane@localhost ~]$ cd /etc/nginx

[oceane@localhost nginx]$ sudo nano myapp.conf

[oceane@localhost nginx]$ sudo nano nginx.conf
service nginx restart

[oceane@localhost nginx]$ sudo service nginx restart
```` 

.y'a donc un fichier de conf NextCloud à modifier


🌞 Faites en sorte de

🌞 Une fois que c'est en place

(faire un ping manuel vers l'IP de proxy.tp6.linux fonctionne
faire un ping manuel vers l'IP de web.tp6.linux ne fonctionne pas)
🌞 Une fois que c'est en place

## II. HTTPS
🌞 Faire en sorte que NGINX force la connexion en HTTPS plutôt qu'HTTP

.on génère une paire de clés sur le serveur proxy.tp6.linux
````powershell
[oceane@localhost ~]$ openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout private.key -out certificate.crt

Country Name (2 letter code) [XX]:FR
State or Province Name (full name) []:Bordeaux
Locality Name (eg, city) [Default City]:Bègles
Organization Name (eg, company) [Default Company Ltd]:Bordeaux Ynov Campus
Organizational Unit Name (eg, section) []:
Common Name (eg, your name or your server's hostname) []:192.168.5.6
Email Address []:rousselot234oceane@gmail.com
````
.on ajuste la conf NGINX
```powershell
[oceane@localhost ~]$ sudo nano /etc/nginx/nginx.conf

on ajoute au fichier ces 2 lignes pour qu'il écoute sur le port conventionnel 443 en TCP: 

server {
    listen 443 ssl;
    ssl_certificate /path/to/certificate.crt;
    ssl_certificate_key /path/to/private.key;
    ...
}
````
 .Vérification que NGINX force la connexion en HTTPS pluôt qu'en HTTP.
```powershell
[oceane@localhost ~]$ curl -I http://yourdomain.com
HTTP/1.1 429 Too Many Requests
content-length: 117
cache-control: no-cache
content-type: text/html
```



## Module 2 : Sauvegarde du système de fichiers
1. Ecriture du script

🌞 Ecrire le script bash

.il s'appellera tp6_backup.sh

````powershell
[oceane@localhost ~]$ nano  tp6_backup.sh
 puis #!/bin/bash
 ````
 ````powershell
[oceane@localhost ~]$  chmod +x tp6_backup.sh
````
`````
 exécuter le fichier en utilisant 
 ./nom_du_fichier.sh.

 ./tp6_backup.sh
 
 ``````
 .il devra être stocké dans le dossier /srv sur la machine web.tp6.linux
````powershell
[oceane@localhost srv]$ cp tp6_backup.sh /srv/
````
(il manque la 2 eme partie de 🌞 Ecrire le script bash et les 2 ere partie de clean it 
2. Clean it)

➜ Environnement d'exécution du script

.Créez un utilisateur sur la machine web.tp6.linux
créez un utilisateur sur la machine web.tp6.linux

il s'appellera backup

son homedir sera /srv/backup/

son shell sera /usr/bin/nologin
```powershell
créez un utilisateur sur la machine web.tp6.linux

[oceane@localhost ~]$ sudo adduser nom_utilisateur
[sudo] password for oceane:
[oceane@localhost ~]$ sudo useradd -m -d /srv/backup/backup -s  /usr/bin/nologin backup

```
(il manque la fin de cette partie)

## 3. Service et timer
🌞 Créez un service système qui lance le script
```powershell
[oceane@localhost ~]$ sudo nano /etc/systemd/system/backup.service
[oceane@localhost ~]$ sudo systemctl daemon-reload
[oceane@localhost ~]$ sudo systemctl start backup.service
[oceane@localhost ~]$ sudo systemctl status backup.service
( à compléter en mettant les réponses)
````
🌞 Créez un timer système qui lance le service à intervalles réguliers
````
[oceane@localhost ~]$ sudo nano /etc/systemd/system/backup.timer
[sudo] password for oceane:

[oceane@localhost ~]$  sudo nano /etc/systemd/system/backup.timer

[oceane@localhost ~]$ sudo systemctl daemon-reload

[oceane@localhost ~]$ sudo systemctl start backup.timer

[oceane@localhost ~]$ sudo systemctl status backup.timer
● backup.timer - Timer pour le service de backup
     Loaded: loaded (/etc/systemd/system/backup.timer; disabled; vendor preset: disabled)
     Active: active (waiting) since Mon 2023-01-16 19:46:42 CET; 26s ago
````
🌞 Activez l'utilisation du timer
````powershell
[oceane@localhost ~]$ sudo systemctl daemon-reload
[sudo] password for oceane:

[oceane@localhost ~]$ sudo systemctl enable backup.timer
Created symlink /etc/systemd/system/timers.target.wants/backup.timer → /etc/systemd/system/backup.timer.

[oceane@localhost ~]$ sudo systemctl daemon-reload

[oceane@localhost ~]$ sudo systemctl start backup.timer

[oceane@localhost ~]$ sudo systemctl enable backup.timer
[sudo] password for oceane:
● backup.timer - Timer pour le service de backup
     Loaded: loaded (/etc/systemd/system/backup.timer; enabled; vendor preset: disabled)
     Active: active (waiting) since Mon 2023-01-16 19:46:42 CET; 14min ago


[oceane@localhost ~]$  sudo systemctl list-timers
NEXT                        LEFT          LAST                        PASSED    UNIT                         ACTIVATES
Mon 2023-01-16 21:44:01 CET 1h 41min left Mon 2023-01-16 19:46:13 CET 15min ago dnf-makecache.timer          dnf-makecache.service
Tue 2023-01-17 00:00:00 CET 3h 57min left Mon 2023-01-16 19:04:55 CET 57min ago logrotate.timer              logrotate.service
Tue 2023-01-17 19:19:48 CET 23h left      Mon 2023-01-16 19:19:48 CET 42min ago systemd-tmpfiles-clean.timer systemd-tmpfiles-clean.service
Tue 2023-01-17 19:46:42 CET 23h left      Mon 2023-01-16 19:46:42 CET 15min ago backup.timer                 backup.service

4 timers listed.
Pass --all to see loaded but inactive timers, too.
[oceane@localhost ~]$
````
## II. NFS

🌞 Préparer un dossier à partager sur le réseau(sur la machine storage.tp6.linux) 
````powershell
[oceane@localhost ~]$ sudo mkdir /srv/nfs_shares
[sudo] password for oceane:

[oceane@localhost ~]$ sudo mkdir /srv/nfs_shares/web.tp6.linux
````
🌞 Installer le serveur NFS (sur la machine storage.tp6.linux)
```powershell
[oceane@localhost ~]$ sudo yum update
Rocky Linux 9 - BaseOS                                                                               6.8 kB/s | 3.6 kB     00:00
Rocky Linux 9 - BaseOS                                                                               1.1 MB/s | 1.7 MB     00:01
Rocky Linux 9 - AppStream

[oceane@localhost ~]$ yum install nfs-utils
````

.créer le fichier /etc/exports
````powershell
[oceane@localhost ~]$ sudo touch /etc/exports
[oceane@localhost ~]$ /srv/nfs_shares    *(rw,sync,no_subtree_check)
````
.ouvrir les ports firewall nécessaires
````powershell
[oceane@localhost ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
````
.démarrer le service
```powershell
[oceane@localhost ~]$ sudo systemctl start nfs-server

[oceane@localhost ~]$ sudo systemctl enable nfs-server

Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
```

## 2. Client NFS
🌞 Installer un client NFS sur web.tp6.linux
```powershell
[oceane@localhost ~]$ sudo dnf install nfs-common

[oceane@localhost ~]$ sudo mkdir -p /srv/backup

[oceane@localhost ~]$ sudo mount storage.tp6.linux:/srv/nfs_shares/web.tp6.linux/ /srv/backup
mount: /srv/backup: bad option; for several filesystems (e.g. nfs, cifs) you might need a /sbin/mount.<type> helper program.

[oceane@localhost /]$ sudo nano /etc/fstab
storage.tp6.linux:/srv/nfs_shares/web.tp6.linux/ /srv/backup/ nfs defaults 0 0

[oceane@localhost /]$ sudo mount -a
[sudo] password for oceane:
mount: /srv/backup: bad option; for several filesystems (e.g. nfs, cifs) you might need a /sbin/mount.<type> helper program.

🌞 Tester la restauration des données sinon ça sert à rien :)

[oceane@localhost /]$ sudo  -avz --ignore-existing
usage: sudo -h | -K | -k | -V
usage: sudo -v [-AknS] [-g group] [-h host] [-p prompt] [-u user]
usage: sudo -l [-AknS] [-g group] [-h host] [-p prompt] [-U user] [-u user] [command]
usage: sudo [-AbEHknPS] [-r role] [-t type] [-C num] [-D directory] [-g group] [-h host] [-p prompt] [-R directory] [-T
            timeout] [-u user] [VAR=value] [-i|-s] [<command>]
usage: sudo -e [-AknS] [-r role] [-t type] [-C num] [-D directory] [-g group] [-h host] [-p prompt] [-R directory] [-T
            timeout] [-u user] file ...
```


## Module 3 : Fail2Ban
🌞 Faites en sorte que :

.si quelqu'un se plante 3 fois de password pour une co SSH en moins de 1 minute, il est ban
```powershell

PS C:\Users\rouss> ssh oceane@192.168.5.8
oceane@192.168.5.8's password:
Permission denied, please try again.
oceane@192.168.5.8's password:
Permission denied, please try again.
oceane@192.168.5.8's password:
oceane@192.168.5.8: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password).

(J'ai essayé de taper 3 fois mon mot de passe en faisant des erreurs pour être ban, voilà le résultat)
````

```powershell
[oceane@localhost /]$ sudo dnf install fail2ban
Waiting for process with pid 1232 to finish.

[oceane@localhost /]$ sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

[oceane@localhost /]$ sudo nano /etc/fail2ban/jail.local

[oceane@localhost ~]$ sudo systemctl restart fail2ban

[oceane@localhost ~]$ sudo fail2ban-client status ssh-iptables
[sudo] password for oceane:
2023-01-17 15:49:08,278 fail2ban                [1763]: ERROR   Failed to access socket path: /var/run/fail2ban/fail2ban.sock. Is fail2ban running?

[oceane@localhost ~]$ sudo firewall-cmd --list-all
public (active)

[oceane@localhost ~]$ sudo fail2ban-client set ssh-iptables unbanip IP
2023-01-17 15:51:24,933 fail2ban                [1775]: ERROR   Failed to access socket path: /var/run/fail2ban/fail2ban.sock. Is fail2ban running?
````

## Module 4 : Monitoring
🌞 Installer Netdata
````powershell
[oceane@localhost ~]$ sudo dnf install netdata 
````

➜ Une fois en place, Netdata déploie une interface un Web pour avoir moult stats en temps réel, utilisez une commande ss pour repérer sur quel port il tourne.
````powershell 
[oceane@localhost ~]$ ss -alptn
State          Recv-Q         Send-Q                 Local Address:Port                    Peer Address:Port         Process
LISTEN         0              128                          0.0.0.0:22                           0.0.0.0:*
LISTEN         0              4096                       127.0.0.1:8125                         0.0.0.0:*
LISTEN         0              4096                       127.0.0.1:19999                        0.0.0.0:*
LISTEN         0              511                                *:80                                 *:*
LISTEN         0              128                             [::]:22                              [::]:*
LISTEN         0              4096                           [::1]:8125                            [::]:*
LISTEN         0              4096                           [::1]:19999                           [::]:*
````

🌞 Une fois Netdata installé et fonctionnel, déterminer :
.l'utilisateur sous lequel tourne le(s) processus Netdata
```powershell
[oceane@localhost ~]$ ps aux | grep netdata~
oceane      2305  0.0  0.2   6412  2336 pts/0    S+   21:16   0:00 grep --color=auto netdata~
````
s.i Netdata écoute sur des ports
````
[oceane@localhost ~]$ ss -alptn
State          Recv-Q         Send-Q                 Local Address:Port                    Peer Address:Port         Process
LISTEN         0              128                          0.0.0.0:22                           0.0.0.0:*
LISTEN         0              4096                       127.0.0.1:8125                         0.0.0.0:*
LISTEN         0              4096                       127.0.0.1:19999                        0.0.0.0:*
LISTEN         0              511                                *:80                                 *:*
LISTEN         0              128                             [::]:22                              [::]:*
LISTEN         0              4096                           [::1]:8125                            [::]:*
LISTEN         0              4096                           [::1]:19999                           [::]:*
````



