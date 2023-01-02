# TP4 : Real services
### Partie 1 : Partitionnement du serveur de stockage
🌞 Partitionner le disque à l'aide de LVM
```powershell
[oceane@localhost ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
sda           8:0    0  8.1G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0  7.1G  0 part
  ├─rl-root 253:0    0  6.3G  0 lvm  /
  └─rl-swap 253:1    0  832M  0 lvm  [SWAP]
sdb           8:16   0    2G  0 disk
sr0          11:0    1 1024M  0 rom
```
```powershell
[oceane@localhost ~]$ sudo pvcreate /dev/sdb
[sudo] password for oceane:
  Physical volume "/dev/sdb" successfully created.
  ```
```powershell 

[oceane@localhost ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
  ```
```powershell 
  [oceane@localhost ~]$ sudo lvcreate -L 1G storage -n coucou
  Logical volume "coucou" created.*
   ```

   🌞 Formater la partition
```powershell
[oceane@localhost storage]$ sudo mkfs -t ext4 /dev/storage/coucou
[sudo] password for oceane:
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: 24567028-342c-4e7a-8d13-38497f19a88d
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
```
```powershell
[oceane@localhost storage]$ sudo lvdisplay
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VB4c0573e1-f4cbd891_ PVID 3a0D50XeNPq54ShzOhLMckEGrlBB4QeE last seen on /dev/sda2 not found.
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBcd4d828a-46292037_ PVID N7lw9NHQxi6Sjgg6d711LWPzNkqpOj1j last seen on /dev/sdb not found.
  --- Logical volume ---
  LV Path                /dev/storage/coucou
  ```

  🌞 Monter la partition
 
 ```` powershell 
  [oceane@localhost storage]$ mkdir mountplace
mkdir: cannot create directory ‘mountplace’: Permission denied
[oceane@localhost storage]$ sudo !!
sudo mkdir mountplace
[sudo] password for oceane:
[oceane@localhost storage]$ mount coucou mountplace
mount: /dev/storage/mountplace: must be superuser to use mount.
[oceane@localhost storage]$ sudo !!
sudo mount coucou mountplace
``` 
```
[oceane@localhost storage]$ df -h | grep "mountplace"
/dev/mapper/storage-coucou  974M   24K  907M   1% /dev/storage/mountplace
```
```
[oceane@localhost ~]$ cat /etc/fstab

/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=16f77830-d570-4519-81c1-413c7107fa03 /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0
/dev/storage/coucou /dev/storage/mountplace ext4 defaults 0 0
```
```
[oceane@localhost ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /dev/storage/mountplace does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/dev/storage/mountplace  : successfully mounted
```

### Partie 2 : Serveur de partage de fichiers
````powershell 
🌞 Donnez les commandes réalisées sur le serveur NFS storage.tp4.linux

[oceane@localhost ~]$ sudo cat /etc/exports
/mnt/storage_1/site_web_1       10.3.1.53(rm,sync,no_subtree_check)
/mnt/storage_1/site_web_2       10.3.1.53(rm,sync,no_subtree_check)


🌞 Donnez les commandes réalisées sur le client NFS web.tp4.linux

[oceane@localhost ~]$ df -h | grep 10.3.1.52
10.3.1.52:/mnt/storage_1/site_web_1  2.0G     0  1.9G   0% /var/www/site_web_1
10.3.1.52:/mnt/storage_1/site_web_2  2.0G     0  1.9G   0% /var/www/site_web_2



[oceane@localhost ~]$ sudo cat /etc/fstab | grep 10.3.1.52
10.3.1.52:/mnt/storage_1/site_web_1    /var/www/site_web_1   nfs defaults 0 0
10.3.1.52:/mnt/storage_1/site_web_2    /var/www/site_web_2   nfs defaults 0 0
````

