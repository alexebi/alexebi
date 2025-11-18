# Escáner de Red Local 🔍

Script en bash para escanear y detectar dispositivos conectados a tu red doméstica.

## 🚀 Características

- **Escaneo rápido con ping**: Detecta dispositivos activos en tu red
- **Integración con nmap**: Escaneo avanzado si nmap está instalado
- **Detección automática**: Identifica automáticamente tu interfaz de red y rango IP
- **Información detallada**: Muestra IP, hostname y dirección MAC de cada dispositivo
- **Tabla ARP**: Visualiza la tabla ARP del sistema
- **Exportación de resultados**: Guarda los resultados en un archivo de texto
- **Interfaz colorida**: Output con colores para mejor legibilidad

## 📋 Requisitos

### Básicos (incluidos en la mayoría de sistemas Linux)
- `bash`
- `ip` (iproute2)
- `ping`
- `arp`

### Opcionales (para funcionalidad avanzada)
- `nmap` - Para escaneo avanzado de puertos y servicios

## 🔧 Instalación

### Instalar nmap (opcional pero recomendado)

**Amazon Linux / RHEL / Fedora:**
```bash
sudo dnf install nmap
```

**Debian / Ubuntu:**
```bash
sudo apt install nmap
```

## 💻 Uso

### Ejecución básica
```bash
./network_scanner.sh
```

### Ejecución con privilegios (recomendado para mejor precisión)
```bash
sudo ./network_scanner.sh
```

## 📖 Opciones del Menú

1. **Escaneo rápido con ping**: Método básico que usa ping para detectar dispositivos
2. **Escaneo con nmap**: Utiliza nmap para un escaneo más detallado (requiere nmap instalado)
3. **Mostrar tabla ARP**: Muestra la tabla ARP actual del sistema
4. **Escaneo completo**: Combina ping y nmap para resultados completos
5. **Salir**: Cierra el script

## 📊 Ejemplo de Salida

```
================================
  Escáner de Red Local
================================

[✓] Interfaz detectada: eth0
[✓] Tu IP local: 192.168.1.100
[✓] Rango de red: 192.168.1.0/24

[*] Iniciando escaneo con ping...

Dispositivos encontrados:
-----------------------------------
[✓] 192.168.1.1 - router.local
    MAC: aa:bb:cc:dd:ee:ff

[✓] 192.168.1.50 - smartphone.local
    MAC: 11:22:33:44:55:66

-----------------------------------
[✓] Escaneo completado: 5 dispositivos encontrados
```

## 🔒 Consideraciones de Seguridad

- **Uso ético**: Este script debe usarse solo en tu propia red
- **Permisos**: Ejecutar como root proporciona información más detallada
- **Privacidad**: No escanees redes que no te pertenezcan

## 🛠️ Funcionalidades Técnicas

### Detección Automática de Red
El script detecta automáticamente:
- Interfaz de red activa
- Dirección IP local
- Rango de red (CIDR)

### Métodos de Escaneo

**Ping Sweep:**
- Escanea el rango completo (1-254)
- Timeout de 1 segundo por host
- Resolución de hostname
- Obtención de dirección MAC

**Nmap (si está disponible):**
- Escaneo de hosts activos (-sn)
- Escaneo rápido de puertos (-F)
- Detección de servicios

## 📝 Archivos de Salida

Los resultados se guardan con el formato:
```
network_scan_YYYYMMDD_HHMMSS.txt
```

Ejemplo: `network_scan_20251118_143025.txt`

## 🐛 Solución de Problemas

### "No se pudo detectar una interfaz de red activa"
- Verifica que estés conectado a una red
- Ejecuta `ip link show` para ver interfaces disponibles

### "MAC no disponible"
- Ejecuta el script con `sudo` para acceder a la tabla ARP completa
- Algunos dispositivos pueden no responder a ARP

### Escaneo lento
- El escaneo completo de 254 IPs puede tomar varios minutos
- Considera usar nmap para escaneos más rápidos

## 📄 Licencia

Este script es de código abierto y puede ser usado libremente para propósitos educativos y personales.

## ⚠️ Disclaimer

Este script es para uso educativo y personal. El escaneo de redes sin autorización puede ser ilegal en tu jurisdicción. Úsalo solo en redes de tu propiedad o con permiso explícito.
