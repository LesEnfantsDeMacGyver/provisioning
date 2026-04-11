#!/bin/bash

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

Cet assistant va déployer Docker et Portainer. Ensuite, il faudra finaliser
le déploiement des services nécessaires dans Portainer.

Attention : l'adresse IP de l'interface réseau filaire sera définie à "192.168.64.5" et s'attend à trouver un routeur avec une adresse IP "192.168.64.1" et un sous-réseau "192.168.64.0/18" (255.255.192.0).

🟢 Continuer avec l'installation ? (Y/N) :
EOF

read -r response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "\e[1m🚀 Démarrage de l'installation...\e[0m"
else
    echo -e "\e[1m🛑 Installation annulée.\e[0m"
    exit 1
fi

# Définition d'une adresse IP statique
sudo nmcli connection modify "Wired connection 1" ipv4.method manual ipv4.addr "192.168.64.5/18" ipv4.gateway "192.168.64.1" ipv4.dns "192.168.64.1" ipv4.ignore-auto-dns no
sudo nmcli connection up "Wired connection 1"

# Mise à jour du système et installation des paquets de base
echo -e "\e[1m📦 Mise à jour du système et installation des paquets de base...\e[0m"
sudo apt update -y && sudo apt upgrade -y && sudo apt install -y curl cifs-utils

# Montage du partage SMB sur /mnt/videosurveillance
sudo mkdir -p /mnt/videosurveillance

# Ajout de l'entrée dans /etc/fstab si elle n'existe pas déjà
if ! grep -q "//192.168.64.39/EMG/videosurveillance /mnt/videosurveillance cifs" /etc/fstab; then
    echo "//192.168.64.39/EMG/videosurveillance /mnt/videosurveillance cifs username=frigate,password=Lmfh4T7DE5z5GPq,vers=3.0,iocharset=utf8,uid=1000,gid=1000,file_mode=0755,dir_mode=0755 0 0" | sudo tee -a /etc/fstab
fi

# Montage immédiat du partage
sudo mount -a

# Installation de Docker
echo -e "\e[1m🐳 Installation de Docker...\e[0m"
curl -fsSL get.docker.com | bash
sudo usermod -aG docker $USER

# Installation de Portainer
echo -e "\e[1m🚢 Installation de Portainer...\e[0m"
sudo docker volume create portainer
sudo docker run -d -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer:/data portainer/portainer-ce:latest

echo -e "\e[1m------------------------------------------------------------\e[0m"
echo -e "\e[1m🔗    Finaliser l'installation de services sur Portainer\e[0m"
echo -e "\e[1m      https://$(hostname | awk '{print $1}'):9443\e[0m"
echo -e "\e[1m------------------------------------------------------------\e[0m"

# Fin de l'installation ; encourager l'utilisateur à déployer les services nécessaires
echo -e "\e[1m🎉 Installation terminée !\e[0m"
