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
````powershell
[oceane@localhost ~]$ cat nginx.conf | grep proxy_pass
        proxy_pass http://10.105.1.12:80;
````
````powershell
[oceane@localhost ~]$ sudo cat config.php | grep trusted
  'trusted_domains' => 'proxy.tp6.linux'
````

🌞 Faites en sorte de
```powershell
[oceane@localhost ~]$ sudo firewall-cmd --zone=public --add-rich-rule='rule family="ipv4" source address="10.105.1.13/32" invert="True" drop' --permanent
[sudo] password for oceane:
success

````
🌞 Une fois que c'est en place
````powershell 
PS C:\Users\ocean> ping 10.105.1.13

Envoi d’une requête 'Ping'  10.105.1.13 avec 32 octets de données :
Réponse de 10.105.1.13 : octets=32 temps<1ms TTL=64
Réponse de 10.105.1.13 : octets=32 temps<1ms TTL=64
Réponse de 10.105.1.13 : octets=32 temps<1ms TTL=64

Statistiques Ping pour 10.105.1.13:
    Paquets : envoyés = 3, reçus = 3, perdus = 0 (perte 0%),
Durée approximative des boucles en millisecondes :
    Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
````

```powershell 
PS C:\Users\ocean> ping 10.105.1.11

Envoi d’une requête 'Ping'  10.105.1.11 avec 32 octets de données :
Délai d’attente de la demande dépassé.
Délai d’attente de la demande dépassé.
Délai d’attente de la demande dépassé.
Délai d’attente de la demande dépassé.

Statistiques Ping pour 10.105.1.11:
    Paquets : envoyés = 4, reçus = 0, perdus = 4 (perte 100%),
````

## II.HTTPS

🌞 Faire en sorte que NGINX force la connexion en HTTPS plutôt qu'HTTP
```powershell
[oceane@localhost ~]$ sed '41,42!d' nginx.conf
        server_name  _;
        return 301   https://$host$request_uri;
````
````powershell
oceane@LAPTOP-MDL3A6CL MINGW64 ~
$ curl -iL http://web.tp6.linux
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   169  100   169    0     0  38269      0 --:--:-- --:--:-- --:--:-- 56333
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0HTTP/1.1 301 Moved Permanently
Server: nginx/1.20.1
Date: Fri, 18 Jan 2023 10:12:48 GMT
Content-Type: text/html
Content-Length: 169
Connection: keep-alive
Location: https://web.tp6.linux/


curl: (60) SSL certificate problem: self signed certificate
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
````



## Module 2 : Sauvegarde du système de fichiers
1. Ecriture du script

🌞 Ecrire le script bash


````powershell
cd /srv
mkdir backup
cd /backup
heure="$(date +%H%M)"
jour="$(date +%y%m%d)"
zip -r "nextcloud_"${jour}""${heure}"" /home/oceane/nextcloud/core/Db /home/oceane/nextcloud/core/Data /home/oceane/nextcloud/config /home/oceane/nextcloud/themes
cd /srv
mv nextcloud* /srv/backup
````


## 3. Service et timer
🌞 Créez un service système qui lance le script
```powershell
[Unit]
Description=BAckup de nextcloud

[Service]
ExecStart=/srv/tp6_nextcloud.sh
Type=oneshot
```
```powershell
[oceane@localhost system]$ sudo systemctl status backup | grep Jan
Jan 18 12:32:37 web.tp5.linux systemd[1]: Starting BAckup de nextcloud...
Jan 18 12:32:38 web.tp5.linux systemd[1]: backup.service: Deactivated successfully.
Jan 18 12:32:38 web.tp5.linux systemd[1]: Finished BAckup de nextcloud.
````
🌞 Créez un timer système qui lance le service à intervalles réguliers
````powershell
[oceane@localhost system]$ cat backup.timer
[Unit]
Description=Run service backup.service

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target

````
🌞 Activez l'utilisation du timer
```powershell
[oceane@localhost system]$ sudo systemctl list-timers | grep backup
Sun 2023-01-15 04:00:00 CET 15h left  n/a         n/a          backup.timer        backup.service
```
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
[oceane@localhost /]$ sudo mount 10.105.1.15:/srv/nfs_shares/web.tp6.linux /srv/backup/
````
````powershell
[oceane@localhost /]$ df -h | grep /srv/backup
10.105.1.15:/srv/nfs_shares/web.tp6.linux  6.2G  1.3G  4.9G  21%  /srv/backup 
````

🌞 Tester la restauration des données sinon ça sert à rien :)
````powershell
[oceane@storage web.tp6.linux]$ sudo unzip nextcloud_2301162145.zip
````


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
````
🌞 Configurer Netdata pour qu'il vous envoie des alertes
````powershell
[oceane@localhost ~]$ cat /etc/netdata/health_alarm_notify.conf
###############################################################################

# enable/disable sending discord notifications
SEND_DISCORD="YES"

# Create a webhook by following the official documentation -
# https://support.discordapp.com/hc/en-us/articles/228383668-Intro-to-Webhooks
DISCORD_WEBHOOK_URL="https://discord.com/api/webhooks/1063442238765539401/-LqWUr77GYSKhUJzClfJQxf7YKt_65bwezjg0eCsfWzduylkEOc1vl-qgyfWNu-YvLC6"

# if a role's recipients are not configured, a notification will be send to
# this discord channel (empty = do not send a notification for unconfigured
# roles):
DEFAULT_RECIPIENT_DISCORD="général"
````

🌞 Vérifier que les alertes fonctionnent
````powershell
[oceane@localhost ~]$ cat prog.py
a=2
for i in range (1,10):
        a=a**a
        print(a)
````
````powershell
[oceane@localhost ~]$ python3 prog.py
4
256
32317006071311007300714876688669951960444102669715484032130345427524655138867890893197201411522913463688717960921898019494119559150490921095088152386448283120630877367300996091750197750389652106796057638384067568276792218642619756161838094338476170470581645852036305042887575891541065808607552399123930385521914333389668342420684974786564569494856176035326322058077805659331026192708460314150258592864177116725943603718461857357598351152301645904403697613233287231227125684710820209725157101726931323469678542580656697935045997268352998638215525166389437335543602135433229604645318478604952148193555853611059596230656
Killed
````
````powershell
[oceane@localhost netdata]$ cat health.log | tail -n 7
2023-01-18 14:17:44: [db.tp5.linux]: Alert event for [mem.available.ram_available], value [2.06%], status [CRITICAL].
2023-01-18 14:17:44: [db.tp5.linux]: Sending notification for alarm 'mem.available.ram_available' status CRITICAL.
2023-01-18 14:18:03: [db.tp5.linux]: Alert event for [mem.available.ram_available], value [64.1%], status [CLEAR].
2023-01-18 14:19:33: [db.tp5.linux]: Alert event for [system.swapio.30min_ram_swapped_out], value [190.4% of RAM], status [WARNING].
2023-01-18 14:19:33: [db.tp5.linux]: Sending notification for alarm 'system.swapio.30min_ram_swapped_out' status WARNING.
2023-01-18 14:20:33: [db.tp5.linux]: Alert event for [mem.oom_kill.oom_kill], value [1 kills], status [WARNING].
2023-01-18 14:20:33: [db.tp5.linux]: Sending notification for alarm 'mem.oom_kill.oom_kill' status WARNING.
