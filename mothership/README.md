# Mothership

1. Déployer Raspberry Pi OS Lite (64-bit) sur une carte SD ou un SSD avec [Raspberry Pi Imager](https://www.raspberrypi.com/software/). Dans les paramètres, définir le nom d'hôte à `mothership`, activer SSH, définir le nom d'utilisateur et le mot de passe (comme indiqué dans `CREDENTIALS.md` du dépôt `control_system`), désactiver le Wi-Fi et définir les réglages locaux (`Europe/Zurich`, clavier `ch`).
2. Démarrer la machine et lancer l'installation automatisée :
   `bash <(wget -qO- https://raw.githubusercontent.com/LesEnfantsDeMacGyver/provisioning/refs/heads/main/mothership/install.sh)`
3. Le script :
   - fixe l'adresse `192.168.64.5/18` sur l'interface filaire
   - configure le partage SMB `//192.168.64.39/EMG/videosurveillance` sur `/mnt/videosurveillance`
   - installe Docker et Portainer
   - installe une règle de routage persistante qui force le sous-réseau local `192.168.64.0/18` à sortir sur le réseau local avant Tailscale
   - force les opérations `apt`/`dpkg` en mode non interactif et répare les paquets laissés non configurés par les mises à jour du noyau Raspberry Pi
   - continue l'installation si le partage SMB est temporairement injoignable ; l'entrée `/etc/fstab` reste configurée pour un montage ultérieur
4. Dans Portainer, [ajouter une stack via Git](https://docs.portainer.io/user/docker/stacks/add#option-3-git-repository) en pointant vers `https://github.com/LesEnfantsDeMacGyver/control_system/`.
5. Lors du premier démarrage de Chataigne, il faut parfois resélectionner le convertisseur USB-DMX dans les modules puis redémarrer l'application.
