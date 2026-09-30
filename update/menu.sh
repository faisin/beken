#!/bin/bash
clear
m="\033[0;1;36m"
y="\033[0;1;37m"
yy="\033[0;1;32m"
wh="\033[0m"
MYIP=$(curl -sS ifconfig.me)
LOC=$(curl -sS ifconfig.co/country)
Domen="$(cat /etc/xray/domain 2>/dev/null)"
total_ram=$(grep "MemTotal:" /proc/meminfo | awk '{print $2}')
totalram=$(($total_ram/1024))
source /etc/os-release
Tipe=$NAME

echo -e "$yy╔══════════════════════════════════════╗$wh"
echo -e "$yy║          VPN FAYSAL BASRY            ║$wh"
echo -e "$yy╠══════════════════════════════════════╣$wh"
echo -e "$y║ IP      : $MYIP$wh"
echo -e "$y║ COUNTRY : $LOC$wh"
echo -e "$y║ OS      : $Tipe$wh"
echo -e "$y║ RAM     : ${totalram}MB$wh"
echo -e "$y║ DOMAIN  : $Domen$wh"
echo -e "$yy╚══════════════════════════════════════╝$wh"
echo
printf '%b\n' "$yy╭──────────── SERVICE MENU ───────────╮"
printf '%b\n' "$yy│ 01. SSH & OPENVPN MENU              │"
printf '%b\n' "$yy│ 02. L2TP MENU                       │"
printf '%b\n' "$yy│ 03. PPTP MENU                       │"
printf '%b\n' "$yy│ 04. SSTP MENU                       │"
printf '%b\n' "$yy│ 05. WIREGUARD MENU                  │"
printf '%b\n' "$yy│ 06. SHADOWSOCKS MENU                │"
printf '%b\n' "$yy│ 07. SHADOWSOCKSR MENU               │"
printf '%b\n' "$yy│ 08. VMESS MENU                      │"
printf '%b\n' "$yy│ 09. VLESS MENU                      │"
printf '%b\n' "$yy│ 10. TROJAN GFW MENU                 │"
printf '%b\n' "$yy│ 11. TROJAN GO MENU                  │"
printf '%b\n' "$yy│ 12. SETTINGS                        │"
printf '%b\n' "$yy│ 13. EXIT                            │"
printf '%b\n' "$yy╰─────────────────────────────────────╯$wh"
read -p " Select From Options [ 1 - 13 ] : " menu
case $menu in
1) clear; sshovpnmenu ;;
2) clear; l2tpmenu ;;
3) clear; pptpmenu ;;
4) clear; sstpmenu ;;
5) clear; wgmenu ;;
6) clear; ssmenu ;;
7) clear; ssrmenu ;;
8) clear; vmessmenu ;;
9) clear; vlessmenu ;;
10) clear; trmenu ;;
11) clear; trgomenu ;;
12) clear; setmenu ;;
13) clear; exit ;;
*) clear; menu ;;
esac
