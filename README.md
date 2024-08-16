# Préparation automatique des machines

Ce dépôt contient les scripts nécessaires à la préparation automatique des machines, notamment les logiciels, la configuration réseau et les scripts de démarrage.

## Mothership
1. Déployer Raspberry Pi OS Lite (64-bit) sur une carte SD / sur un SSD avec (par exemple en utilisant [Raspberry Pi Imager](https://www.raspberrypi.com/software/)). Dans les paramètres, définir le nom d'hôte à `mothership`, activer SSH (avec un mot de passe), définir le nom d'utilisateur et mot de passe (comme indiqué dans [CREDENTIALS.md](https://github.com/LesEnfantsDeMacGyver/control_system/CREDENTIALS.md), désactiver le Wi-Fi et définir les réglages locaux (fuseau horaire `Europe/Zurich` et clavier `ch`).
<!-- 2. Modifier le fichier `cmdline.txt` sur la partition boot pour y définir une adresse IP fixe :
   ```
   ip=192.168.64.5
   ``` -->
3. Démarrer la machine et connecter une session SSH. Exécuter la commande d'installation automatisée :
   `bash <(wget -qO- https://raw.githubusercontent.com/LesEnfantsDeMacGyver/provisioning/mothership/install.sh)` (on peut copier-coller le lien du fichier en version brute depuis GitHub, il contient le jeton de sécurité dans l'URL).
4. Dans Portainer, [ajouter une stack la méthode Git](https://docs.portainer.io/user/docker/stacks/add#option-3-git-repository) en pointant vers le dépôt `https://github.com/LesEnfantsDeMacGyver/control_system/`.
5. Lors du premier démarrage de Chataigne, il faut (peut-être) resélectionner le convertisseur USB-DMX dans les modules, puis redémarrer l'application.

## Dialing Computer

1. Déployer FullPageOS (64-bit) sur une carte SD / sur un SSD avec (par exemple en utilisant [Raspberry Pi Imager](https://www.raspberrypi.com/software/)). Dans les paramètres, définir le nom d'hôte à `dialing-computer`, activer SSH (avec un mot de passe), définir le nom d'utilisateur et mot de passe (comme indiqué dans [CREDENTIALS.md](https://github.com/LesEnfantsDeMacGyver/control_system/CREDENTIALS.md), désactiver le Wi-Fi et définir les réglages locaux (fuseau horaire `Europe/Zurich` et clavier `ch`).
2. Démarrer la machine et connecter une session SSH. Exécuter la commande d'installation automatisée :
   `bash <(wget -qO- https://raw.githubusercontent.com/LesEnfantsDeMacGyver/provisioning/dialing_computer/install.sh)` et suivre les instructions.