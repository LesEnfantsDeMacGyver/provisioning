#!/bin/bash
set -Eeuo pipefail

export DEBIAN_FRONTEND=noninteractive

LAN_CIDR="192.168.64.0/18"
MOTHERSHIP_IP="192.168.64.5"
LAN_GATEWAY="192.168.64.1"
WIRED_CONNECTION="${WIRED_CONNECTION:-Wired connection 1}"
VIDEOSURVEILLANCE_SHARE="//192.168.64.39/EMG/videosurveillance"
VIDEOSURVEILLANCE_MOUNT="/mnt/videosurveillance"
VIDEOSURVEILLANCE_FSTAB="${VIDEOSURVEILLANCE_SHARE} ${VIDEOSURVEILLANCE_MOUNT} cifs username=frigate,password=Lmfh4T7DE5z5GPq,vers=3.0,iocharset=utf8,uid=1000,gid=1000,file_mode=0755,dir_mode=0755 0 0"

run_sudo() {
    sudo "$@"
}

repair_apt_state() {
    echo -e "\e[1m🧰 Réparation de l'état dpkg/apt si nécessaire...\e[0m"
    run_sudo dpkg --force-confdef --force-confold --configure -a
    run_sudo apt-get \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        -f install -y
}

apt_install_base() {
    run_sudo apt-get update -y
    if ! run_sudo apt-get \
        -o Dpkg::Options::="--force-confdef" \
        -o Dpkg::Options::="--force-confold" \
        upgrade -y; then
        repair_apt_state
    fi
    repair_apt_state
    run_sudo apt-get install -y curl cifs-utils
}

install_local_lan_policy_routing() {
    run_sudo tee /etc/systemd/system/local-lan-policy-routing.service >/dev/null <<EOF
[Unit]
Description=Prefer local LAN routing for ${LAN_CIDR} before Tailscale policy routes
After=network-online.target tailscaled.service docker.service
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=-/usr/sbin/ip rule add pref 100 to ${LAN_CIDR} lookup main
ExecStart=/usr/sbin/ip route flush cache
ExecStop=-/usr/sbin/ip rule del pref 100
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF
    run_sudo systemctl daemon-reload
    run_sudo systemctl enable --now local-lan-policy-routing.service
}

install_docker() {
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    run_sudo sh /tmp/get-docker.sh
    run_sudo usermod -aG docker "$USER"
}

install_portainer() {
    run_sudo docker volume create portainer >/dev/null
    if run_sudo docker container inspect portainer >/dev/null 2>&1; then
        run_sudo docker start portainer >/dev/null
    else
        run_sudo docker run -d -p 9443:9443 --name portainer --restart=always \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v portainer:/data \
            portainer/portainer-ce:latest
    fi
}

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
if ! nmcli -t -f NAME connection show | grep -Fxq "${WIRED_CONNECTION}"; then
    WIRED_CONNECTION="$(nmcli -t -f NAME,DEVICE connection show | awk -F: '$2 == "eth0" { print $1; exit }')"
fi

run_sudo nmcli connection modify "${WIRED_CONNECTION}" \
    ipv4.method manual \
    ipv4.addr "${MOTHERSHIP_IP}/18" \
    ipv4.gateway "${LAN_GATEWAY}" \
    ipv4.dns "${LAN_GATEWAY}" \
    ipv4.ignore-auto-dns no
run_sudo nmcli connection up "${WIRED_CONNECTION}"

# Mise à jour du système et installation des paquets de base
echo -e "\e[1m📦 Mise à jour du système et installation des paquets de base...\e[0m"
apt_install_base

# Montage du partage SMB sur /mnt/videosurveillance
run_sudo mkdir -p "${VIDEOSURVEILLANCE_MOUNT}"

# Ajout de l'entrée dans /etc/fstab si elle n'existe pas déjà
run_sudo sed -i '/^stargate11$/d' /etc/fstab
if ! grep -q "${VIDEOSURVEILLANCE_SHARE} ${VIDEOSURVEILLANCE_MOUNT} cifs" /etc/fstab; then
    printf '%s\n' "${VIDEOSURVEILLANCE_FSTAB}" | run_sudo tee -a /etc/fstab >/dev/null
fi

# Montage immédiat du partage
if ! run_sudo timeout 30 mount "${VIDEOSURVEILLANCE_MOUNT}"; then
    echo -e "\e[1m⚠️  Le partage ${VIDEOSURVEILLANCE_SHARE} n'est pas joignable pour l'instant ; l'entrée fstab est configurée et le montage sera retenté au démarrage.\e[0m"
fi

# Règle de routage persistante pour garder le LAN local prioritaire sur Tailscale
install_local_lan_policy_routing

# Installation de Docker
echo -e "\e[1m🐳 Installation de Docker...\e[0m"
install_docker

# Installation de Portainer
echo -e "\e[1m🚢 Installation de Portainer...\e[0m"
install_portainer

echo -e "\e[1m------------------------------------------------------------\e[0m"
echo -e "\e[1m🔗    Finaliser l'installation de services sur Portainer\e[0m"
echo -e "\e[1m      https://$(hostname | awk '{print $1}'):9443\e[0m"
echo -e "\e[1m------------------------------------------------------------\e[0m"

# Fin de l'installation ; encourager l'utilisateur à déployer les services nécessaires
echo -e "\e[1m🎉 Installation terminée !\e[0m"
