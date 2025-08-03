# Kit de Inicio de Avalanche

Este repositorio contiene código inicial para construir aplicaciones **cross-chain** en Avalanche utilizando el protocolo **Teleporter** y **ICM (Inter-Chain Messaging)**.

## Comenzando

Este repositorio está optimizado para el desarrollo en **GitHub Codespaces**, proporcionando un entorno preconfigurado con todas las herramientas y dependencias necesarias.

### Opción 1: GitHub Codespaces (Recomendado)

1. Haz clic en el botón verde **"Code"** en la parte superior.
2. Selecciona la pestaña **"Codespaces"**.
3. Haz clic en **"Create codespace on main"**.
4. Sigue las instrucciones en [CODESPACE.md](./CODESPACE.md).

### Opción 2: Desarrollo Local

Para instrucciones de desarrollo local y configuración, consulta [LOCAL.md](./LOCAL.md).

## Características

- Mensajería cross-chain usando los protocolos **Teleporter** e **ICM**.
- Entorno de desarrollo preconfigurado.
- Contratos de ejemplo para comunicación entre cadenas.
- Configuración automatizada de relayers para el envío de mensajes.
- Soporte integrado para **Docker** para ejecutar servicios.
- Pruebas y despliegue basados en **Foundry**.

## Arquitectura

El kit de inicio demuestra la comunicación cross-chain entre:
- **Avalanche Fuji C-Chain (testnet)**
- **Avalanche Dispatch Chain (testnet)**

Los mensajes pueden enviarse en ambas direcciones entre estas cadenas utilizando:
- **Protocolo Teleporter**
- **ICM (Inter-Chain Messaging)**

## Aprende Más

- [Documentación de Foundry](https://book.getfoundry.sh/)
- [Documentación de Avalanche](https://docs.avax.network/)
- [Documentación de Teleporter](https://docs.avax.network/build/cross-chain/teleporter/overview)
- [Documentación de ICM](https://docs.avax.network/build/cross-chain/icm/overview)

## Smart Contract de los mensajes
El archivo  TeleporterContract.sol agregar en el Remix Etherum IDE, luego hacer las respectivas tranasciones para obtener la direccion de contrato con CORE tesnet.