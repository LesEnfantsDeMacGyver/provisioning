#!/bin/bash

# Si ce script fonctionne depuis un Docker, il faut activer "privileged: true" et "user: root" pour que les ordres CEC soient exécutés correctement dans startup.sh.

cat << "EOF"

◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎
❖                                                                                               ❖
◼︎   ██╗     ███████╗███████╗    ███████╗███╗   ██╗███████╗ █████╗ ███╗   ██╗████████╗███████╗   ◼︎
❖   ██║     ██╔════╝██╔════╝    ██╔════╝████╗  ██║██╔════╝██╔══██╗████╗  ██║╚══██╔══╝██╔════╝   ❖
◼︎   ██║     █████╗  ███████╗    █████╗  ██╔██╗ ██║█████╗  ███████║██╔██╗ ██║   ██║   ███████╗   ◼︎
❖   ██║     ██╔══╝  ╚════██║    ██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██║██║╚██╗██║   ██║   ╚════██║   ❖
◼︎   ███████╗███████╗███████║    ███████╗██║ ╚████║██║     ██║  ██║██║ ╚████║   ██║   ███████║   ◼︎
❖   ╚══════╝╚══════╝╚══════╝    ╚══════╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝   ❖
◼︎                                                                                               ◼︎
❖   ██████╗ ███████╗    ███╗   ███╗ █████╗  ██████╗ ██████╗██╗   ██╗██╗   ██╗███████╗██████╗    ❖
◼︎   ██╔══██╗██╔════╝    ████╗ ████║██╔══██╗██╔════╝██╔════╝╚██╗ ██╔╝██║   ██║██╔════╝██╔══██╗   ◼︎
❖   ██║  ██║█████╗      ██╔████╔██║███████║██║     ██║  ███╗╚████╔╝ ██║   ██║█████╗  ██████╔╝   ❖
◼︎   ██║  ██║██╔══╝      ██║╚██╔╝██║██╔══██║██║     ██║   ██║ ╚██╔╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗   ◼︎
❖   ██████╔╝███████╗    ██║ ╚═╝ ██║██║  ██║╚██████╗╚██████╔╝  ██║    ╚████╔╝ ███████╗██║  ██║   ❖
◼︎   ╚═════╝ ╚══════╝    ╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝   ╚═╝     ╚═══╝  ╚══════╝╚═╝  ╚═╝   ◼︎
❖                                                                                               ❖
◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎ ❖ ◼︎

Cet assistant va préparer le Dialing Computer :
- Résolution du nom d'hôte pour accéder à Mothership (192.168.64.5)
- Télécharger et installer le script pour allumer automatique la TV
- Configurer la sortie audio vers le port HDMI

🟢 Continuer avec l'installation ? (Y/N) :
EOF

read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "\e[1m🚀 Démarrage de l'installation...\e[0m"
else
    echo -e "\e[1m🛑 Installation annulée.\e[0m"
    exit 1
fi

# Mise à jour du système et installation des paquets de base
echo -e "\e[1m📦 Mise à jour du système et installation des paquets de base...\e[0m"
sudo apt update -y > /dev/null && sudo apt upgrade -y > /dev/null && sudo apt install -y git > /dev/null

# Cloner le dépôt
echo -e "\e[1m🔗 Clonage du dépôt...\e[0m"
if [ -d "provisioning" ]; then
    rm -rf provisioning
fi
git clone https://github.com/LesEnfantsDeMacGyver/provisioning.git

# Remplacer `/opt/custompios/background.png` et `/boot/firmware/splash.png` par le fichier `splash.png` pour que le logo des EMG apparaissent durant le démarrage, en utilisant des symlink.
echo -e "\e[1m🔗 Création des liens symboliques pour le logo de démarrage...\e[0m"
sudo rm -f /opt/custompios/background.png
sudo rm -f /boot/firmware/splash.png
sudo ln -s provisioning/dialing_computer/splash.png /opt/custompios/background.png
sudo ln -s provisioning/dialing_computer/splash.png /boot/firmware/splash.png

# Résolution du nom d'hôte pour accéder à Mothership
echo -e "\e[1m🌐 Résolution du nom d'hôte pour accéder à Mothership (192.168.64.5)...\e[0m"
echo "192.168.64.5 mothership" | sudo tee -a /etc/hosts

# Installation de l'utilitaire pour contrôler les entrées/sorties HDMI 
echo -e "\e[1m📺 Installation des utilitaires Consumer Electronics Control (CEC)...\e[0m"
sudo apt-get install -y cec-utils libcec-dev

# Installation du service pour le Dialing Computer
echo -e "\e[1m🚀 Installation du service pour le Dialing Computer...\e[0m"
sudo chmod +x provisioning/dialing_computer/startup.sh
sudo cp provisioning/dialing_computer/hdmi_control.service /etc/systemd/system/
sudo systemctl enable hdmi_control.service

# Fin de l'installation
echo -e "\e[1m🎉 Installation terminée !\e[0m"

# Attendre une touche pour redémarrer
read -p "Appuyez sur une touche pour redémarrer, ou Ctrl+C pour continuer sans redémarrer..."
sudo reboot