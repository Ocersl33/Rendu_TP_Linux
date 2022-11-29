# TP1 : Are you dead yet ?
## Méthode 1

- J'ai fais cd.. pour aller dans / 
- Ensuite cd /etc/usr/bin
- et puis rm *bash*
- ensuite, on reboot
#### la machine demande le nom d'utilisateur et le mot de passe et une fois les deux données, la machine les demande a nouveau (et ce a l'infini).
## Méthode 2
- Nouvelle VM, on fait cd .. pour aller dans /
- on fait cd /etc/usr/bin
- on tape rm ls, rm cd, rm nano... etc pour toutes les commandes que l'on connait...
#### La vm fonctionne (la fonction cd aussi je ne sais pas pourquoi puisque le fichier cd a été supprimé) mais toutes les fonctions sont inutilisables parce que rocky ne les connait plus.
## Méthode 3
- on commence par faire un nano .bashrc
- a la fin de ce dernier, on définit des alias du nom des commandes (cd, ls, rm, touch...) et surtout de la commande nano (pour éviter de pouvoir modifier .bashrc) en commande reboot en écrivant 
```
"alias [commande]='reboot'
```

#### maintenant, lorsque l'on lance la vm, et que l'on tape une commande, elle se redémarre.
## Méthode 4
- on retourne dans le .bashrc (avec "nano .bashrc")
- on va en haut du fichier , au dessus du début du programme et au lieu de faire des alias, on écrit "exit"
#### Lorsque l'on relance la VM, et que l'on entre le nom d'utilisateur et le mot de passe, le programme nous déconnecte directement sans que l'on ait le temps d'appuyer sur ctrl+C. 