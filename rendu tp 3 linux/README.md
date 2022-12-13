## TP 3 : We do a little scripting
### I. Script carte d'identité
🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie, dans des balises de code.
````
#! /bin/bash
hostname="$(hostnamectl | grep 'Static hostname')"
OS="$(cat /etc/redhat-release | awk '{print $1 " " $2}')"
OSversion="$(cat /etc/redhat-release | awk '{print $4}')"
IP="$(ip a | grep 'inet' | grep 'enp0s8' | awk '{print $2}' | cut -d '/' -f1)"
RAMtotal="$(free -h | grep "Mem" | awk '{print $2}')"
RAMavailable="$(free -h | grep "Mem" | awk '{print $4}')"
DISKavailable="$(df -h | grep 'G' | awk '{print $4}')"
PROG1="$(ps -eo command,%mem --sort=%mem | tail -n 5 | head -n 1)"
PROG2="$(ps -eo command,%mem --sort=%mem | tail -n 4 | head -n 1)"
PROG3="$(ps -eo command,%mem --sort=%mem | tail -n 3 | head -n 1)"
PROG4="$(ps -eo command,%mem --sort=%mem | tail -n 2 | head -n 1)"
PROG5="$(ps -eo command,%mem --sort=%mem | tail -n 1 | head -n 1)"
PORT="$(ss -lpn4H | awk '{print $5}' | cut -d':' -f2 | head -n 1)"
echo "Machine name : ${hostname}"
echo "OS ${OS} and kernel version is ${OSversion}"
echo "IP : ${IP}"
echo "RAM : ${RAMavailable} memory available on ${RAMtotal} total memory"
echo "Disk : ${DISKavailable} space left"
echo "Top 5 processes by RAM usage :
  - $PROG1
  - $PROG2
  - $PROG3
  - $PROG4
  - $PROG5"
echo "Listening ports :
  - 22 tcp : sshd
  - ${PORT} udp : loopback"
  file_name='toto'

curl --silent -o "${file_name}" https://cataas.com/cat

file_output="$(file $file_name)"

if [[ "${file_output}" == *JPEG* ]] ; then
  file_type='jpg'
elif [[ "${file_output}" == *PNG* ]] ; then
  file_type='png'
elif [[ "${file_output}" == *GIF* ]] ; then
  file_type='gif'
fi
rm *cat* 2> /dev/null
mv "${file_name}" "cat.${file_type}"

echo "Here is your random cat ./cat.${file_type}"
````


### II. Script youtube-dl

🌞 Vous fournirez dans le compte-rendu, en plus du fichier, un exemple d'exécution avec une sortie, dans des balises de code.


````
#!/bin/bash

video_title="$(youtube-dl -e $1)"
cd /srv/yt/downloads/
mkdir "${video_title}" > /dev/null
cd "${video_title}"
youtube-dl $1 > /dev/null
echo "Vidéo" $1 "was downloaded."
nom_vid="$(ls *.mp4)"
youtube-dl --get-description $1 > description
echo "File path : /srv/yt/downloads/""${video_title}""/""${nom_vid}"
cd /var/log/yt
echo "[""$(date "+%Y/%m/%d"" ""%T")""]" >> /var/log/yt/download.log
echo "Vidéo" $1 "was downloaded. File path : /srv/yt/downloads/""${video_title}""/""${nom_vid}" >> /var/log/yt/download.log
````


````
[oceane@localhost yt]$ cat download.log
[2022/12/12 17:02:40]
Vidéo https://www.youtube.com/watch?v=uGciGE-6MqU&ab_channel=CarsonTV was downloaded. File path : /srv/yt/downloads/ LAURENT GERRA, LE MIROIR DE SON ÉPOQUE/LAURENT GERRA, LE MIROIR DE SON ÉPOQUE-6MqU&.mp4
[2022/12/12 17:30:50]
Vidéo https://www.youtube.com/watch?v=LOFc6mGoJts&ab_channel=CarsonTV was downloaded. File path : /srv/yt/downloads/Un soir à Monaco avec Laurent Gerra/Un soir à Monaco avec Laurent Gerra-LOFc6mGoJts.mp4
````
````
[oceane@localhost yt]$ ./yt.shhttps://www.youtube.com/watch?v=uGciGE-6MqU&ab_channel=CarsonTV
Vidéo https://www.youtube.com/watch?v=uGciGE-6MqU&ab_channel=CarsonTVwas downloaded.
 File path : /srv/yt/downloads/Un soir à Monaco avec Laurent Gerra/Un soir à Monaco avec Laurent Gerra-LOFc6mGoJts.mp4
````





### III. MAKE IT A SERVICE

🌞 Vous fournirez dans le compte-rendu, en plus des fichiers :
````
#!/bin/bash

while true ; do
  vue="$(cat /srv/yt/url_vid.txt)"
  while read line ;
  do
    vue="$(head -1 /srv/yt/url_vid.txt)"
    video_title="$(youtube-dl -e ""${vue}"" 2> /dev/null )"
    cd /srv/yt
    vue="$(cat /srv/yt/url_vid.txt)"
    if [[ "$vue" == "https://www.youtube.com/watch?v="* ]]; then
      cd /srv/yt/downloads/
      mkdir "${video_title}" 2> /dev/null
      cd "${video_title}"
      youtube-dl "${vue}" > /dev/null
      echo "Vidéo" "${vue}" "was downloaded."
      nom_vid="$(ls *.mp4)"
      youtube-dl --get-description "${vue}" > description
      echo "File path : /srv/yt/downloads/""${video_title}""/""${nom_vid}"
      cd /var/log/yt
      echo "[""$(date "+%Y/%m/%d"" ""%T")""]" >> /var/log/yt/download.log
      echo "Vidéo" "${vue}" "was downloaded. File path : /srv/yt/downloads/""${video_title}""/""${nom_vid}" >> /var/log/yt/download.log
      sed -i '1d' /srv/yt/url_vid.txt
  fi
  done <<< "${vue}"
  sleep 30
done
````
````
[Unit]
Description=Youtube téléchargeur

[Service]
ExecStart=/srv/yt/yt-v2.sh
User=yt

[Install]
WantedBy=multi-user.target
````

````
[ytb@tp3linux system]$ sudo journalctl -xe -u yt -f
Dec 12 18:00:36 tp3linux systemd[1]: Started Youtube téléchargeur.
░░ Subject: A start job for unit yt.service has finished successfully
░░ Defined-By: systemd
░░ Support: https://access.redhat.com/support
░░
░░ A start job for unit yt.service has finished successfully.
░░
░░ The job identifier is 2763.
Dec 12 18:01:50 tp3linux yt-v2.sh[3408]: Vidéo https://www.youtube.com/watch?v=uGciGE-6MqU&ab_channel=CarsonTVwas downloaded.
Dec 12 18:01:53 TP3 yt-v2.sh[3408]: File path : /srv/yt/downloads/Me at the zoo/Me at the zoo-jNQXAC9IVRw.mp4
````




