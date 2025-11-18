#!/bin/bash

# Script para escanear dispositivos en la red local
# Autor: Blackbox
# Fecha: 2025-11-18

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # Sin color

# Banner
echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Escáner de Red Local${NC}"
echo -e "${BLUE}================================${NC}\n"

# Verificar si se ejecuta como root (recomendado para mejor precisión)
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}[!] Advertencia: No se está ejecutando como root.${NC}"
    echo -e "${YELLOW}    Algunos escaneos pueden ser menos precisos.${NC}\n"
fi

# Función para detectar la interfaz de red activa
get_network_interface() {
    # Obtener la interfaz con conexión activa (excluyendo loopback)
    INTERFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)
    
    if [ -z "$INTERFACE" ]; then
        echo -e "${RED}[✗] No se pudo detectar una interfaz de red activa${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[✓] Interfaz detectada: $INTERFACE${NC}"
}

# Función para obtener la IP local y rango de red
get_network_info() {
    LOCAL_IP=$(ip addr show $INTERFACE | grep "inet " | awk '{print $2}' | cut -d/ -f1)
    NETWORK_RANGE=$(ip addr show $INTERFACE | grep "inet " | awk '{print $2}')
    
    if [ -z "$LOCAL_IP" ]; then
        echo -e "${RED}[✗] No se pudo obtener la dirección IP${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[✓] Tu IP local: $LOCAL_IP${NC}"
    echo -e "${GREEN}[✓] Rango de red: $NETWORK_RANGE${NC}\n"
}

# Función para escanear con ping (método básico)
scan_with_ping() {
    echo -e "${BLUE}[*] Iniciando escaneo con ping...${NC}\n"
    echo -e "${YELLOW}Dispositivos encontrados:${NC}"
    echo -e "-----------------------------------"
    
    # Extraer los primeros 3 octetos de la IP
    NETWORK_PREFIX=$(echo $LOCAL_IP | cut -d. -f1-3)
    
    # Contador de dispositivos
    COUNT=0
    
    # Escanear rango 1-254
    for i in {1..254}; do
        IP="$NETWORK_PREFIX.$i"
        
        # Ping silencioso con timeout corto
        if ping -c 1 -W 1 $IP &> /dev/null; then
            COUNT=$((COUNT + 1))
            
            # Intentar obtener el hostname
            HOSTNAME=$(getent hosts $IP | awk '{print $2}')
            
            if [ -z "$HOSTNAME" ]; then
                HOSTNAME="(hostname desconocido)"
            fi
            
            # Intentar obtener el fabricante del MAC (requiere arp)
            MAC=$(arp -n $IP 2>/dev/null | grep -v incomplete | awk '{print $3}')
            
            if [ -z "$MAC" ]; then
                MAC="(MAC no disponible)"
            fi
            
            echo -e "${GREEN}[✓] $IP${NC} - $HOSTNAME"
            echo -e "    MAC: $MAC"
            echo ""
        fi
    done
    
    echo -e "-----------------------------------"
    echo -e "${GREEN}[✓] Escaneo completado: $COUNT dispositivos encontrados${NC}\n"
}

# Función para escanear con nmap (si está disponible)
scan_with_nmap() {
    if command -v nmap &> /dev/null; then
        echo -e "${BLUE}[*] nmap detectado. Realizando escaneo avanzado...${NC}\n"
        
        echo -e "${YELLOW}Escaneo rápido de hosts activos:${NC}"
        nmap -sn $NETWORK_RANGE -oG - | grep "Up" | awk '{print $2, $3}'
        
        echo -e "\n${YELLOW}¿Deseas realizar un escaneo de puertos? (s/n)${NC}"
        read -r RESPONSE
        
        if [[ "$RESPONSE" =~ ^[Ss]$ ]]; then
            echo -e "${BLUE}[*] Escaneando puertos comunes...${NC}"
            nmap -F $NETWORK_RANGE
        fi
    else
        echo -e "${YELLOW}[!] nmap no está instalado. Usando método básico.${NC}"
        echo -e "${YELLOW}    Para instalar nmap: sudo dnf install nmap${NC}\n"
    fi
}

# Función para mostrar tabla ARP
show_arp_table() {
    echo -e "${BLUE}[*] Tabla ARP actual:${NC}"
    echo -e "-----------------------------------"
    arp -a
    echo -e "-----------------------------------\n"
}

# Función para guardar resultados
save_results() {
    TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    OUTPUT_FILE="network_scan_$TIMESTAMP.txt"
    
    echo -e "${YELLOW}¿Deseas guardar los resultados? (s/n)${NC}"
    read -r SAVE_RESPONSE
    
    if [[ "$SAVE_RESPONSE" =~ ^[Ss]$ ]]; then
        {
            echo "Escaneo de Red Local"
            echo "Fecha: $(date)"
            echo "Interfaz: $INTERFACE"
            echo "IP Local: $LOCAL_IP"
            echo "Rango: $NETWORK_RANGE"
            echo ""
            echo "Dispositivos encontrados:"
            arp -a
        } > $OUTPUT_FILE
        
        echo -e "${GREEN}[✓] Resultados guardados en: $OUTPUT_FILE${NC}"
    fi
}

# Menú principal
show_menu() {
    echo -e "${BLUE}Selecciona el método de escaneo:${NC}"
    echo "1) Escaneo rápido con ping"
    echo "2) Escaneo con nmap (si está disponible)"
    echo "3) Mostrar tabla ARP"
    echo "4) Escaneo completo (ping + nmap)"
    echo "5) Salir"
    echo ""
    read -p "Opción: " OPTION
    
    case $OPTION in
        1)
            scan_with_ping
            save_results
            ;;
        2)
            scan_with_nmap
            save_results
            ;;
        3)
            show_arp_table
            ;;
        4)
            scan_with_ping
            scan_with_nmap
            save_results
            ;;
        5)
            echo -e "${GREEN}[✓] Saliendo...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}[✗] Opción inválida${NC}"
            show_menu
            ;;
    esac
}

# Ejecución principal
main() {
    get_network_interface
    get_network_info
    show_menu
}

# Ejecutar script
main
