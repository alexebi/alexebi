# ⚔️ DDoS Local Tester (Entorno Controlado)

Herramienta educativa de pruebas de estrés para **entornos de red locales y controlados**.  
Diseñada exclusivamente para laboratorios de ciberseguridad y pruebas de rendimiento en servidores propios.

## ⚠️ ADVERTENCIA LEGAL
**Este software es solo para fines educativos y de investigación en entornos controlados.**  
El uso de esta herramienta contra sistemas que no sean de tu propiedad o sin autorización explícita es **ILEGAL**.  
El autor no se hace responsable del mal uso que se le pueda dar.

## 🚀 Funcionalidades
- Detección automática de IPs públicas/privadas mediante WebRTC.
- Agregado manual de IPs objetivo (ej: `127.0.0.1`, `192.168.1.X`).
- Ataque de inundación HTTP (flood) contra el puerto **6346** de la IP seleccionada.
- Interfaz visual con contador de peticiones en tiempo real.
- Bloqueo de seguridad: solicita confirmación antes de atacar IPs públicas.

## 🧪 Instrucciones de uso (Laboratorio)
1.  **Prepara la víctima**: Levanta un servidor en el puerto 6346.
    ```bash
    python3 -m http.server 6346
