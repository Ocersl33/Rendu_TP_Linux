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

