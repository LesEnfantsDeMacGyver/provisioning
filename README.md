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
   `bash <(wget -qO- https://raw.githubusercontent.com/LesEnfantsDeMacGyver/provisioning/main/dialing_computer/install.sh?token=$(cat /proc/sys/kernel/random/uuid))` et suivre les instructions.

En cas de besoin, on pourra remplacer le contenu de `dialing_program_url.txt` par une URL personnalisée (par exemple `https://www.youtube.com/embed/2-0W4qsc3Vw?si=sC5WBUwrzZ5p358Y&autoplay=true&controls=0&modestbranding&loop=1` pour afficher une vidéo YouTube en boucle).

### Diagnostiquer les problèmes de Chromium à distance
1. Ajouter l'argument `--remote-debugging-port=9222` à la ligne de commande du Chromium distant.
2. Lancer `ssh -L 9222:localhost:9222 pi@dialing-computer` sur la machine locale.
3. Naviguer vers `chrome://inspect/#devices` sur la machine locale.
4. L'instance Chromium de la machine distante devrait apparaître dans la liste. Cliquer sur `Inspect` pour ouvrir la console de développement de Chromium.
