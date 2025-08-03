// SPDX-License-Identifier: MIT

pragma solidity 0.8.18;

// ============================================================================
// INTERFACES DE TELEPORTER (definidas manualmente)
// ============================================================================

/**
 * @title Estructura de información de comisiones para Teleporter
 */
struct TeleporterFeeInfo {
    address feeTokenAddress;
    uint256 amount;
}

/**
 * @title Estructura de entrada de mensaje para Teleporter
 */
struct TeleporterMessageInput {
    bytes32 destinationBlockchainID;
    address destinationAddress;
    TeleporterFeeInfo feeInfo;
    uint256 requiredGasLimit;
    address[] allowedRelayerAddresses;
    bytes message;
}

/**
 * @title Interfaz del Messenger de Teleporter
 */
interface ITeleporterMessenger {
    /**
     * @notice Envía un mensaje entre cadenas
     * @param messageInput Estructura con toda la información del mensaje
     * @return messageID ID único del mensaje enviado
     */
    function sendCrossChainMessage(TeleporterMessageInput calldata messageInput)
        external
        returns (bytes32 messageID);
}

/**
 * @title Interfaz del Receptor de Teleporter
 */
interface ITeleporterReceiver {
    /**
     * @notice Recibe mensajes de Teleporter
     * @param sourceBlockchainID ID de la blockchain origen
     * @param originSenderAddress Dirección del remitente original
     * @param message Mensaje en formato bytes
     */
    function receiveTeleporterMessage(
        bytes32 sourceBlockchainID,
        address originSenderAddress,
        bytes calldata message
    ) external;
}

// ============================================================================
// CONTRATOS PRINCIPALES
// ============================================================================

/**
 * @title Contrato Emisor en C-Chain (Core/Avalanche)
 * @dev Este contrato envía mensajes a otra cadena usando Teleporter.
 */
contract EmisorEnCChain {
    // Interfaz del Messenger de Teleporter
    ITeleporterMessenger public immutable mensajeroTeleporter;
    
    // Evento que se emite cuando se envía un mensaje
    event MensajeEnviado(

        bytes32 indexed destinationBlockchainID,
        address indexed destinationAddress,
        string mensaje,
        bytes32 messageID

    );

    // Dirección del contrato Teleporter en C-Chain
    constructor() {
        mensajeroTeleporter = ITeleporterMessenger(
            0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf
        );
    }

    /**
     * @notice Envía un mensaje a otra blockchain
     * @param direccionDestino Dirección del contrato receptor en la otra cadena
     * @param mensaje Texto que se enviará como mensaje
     */
    

    function enviarMensaje(address direccionDestino, string calldata mensaje) external {
        // Crea la estructura del mensaje
        TeleporterMessageInput memory mensajeTeleporter = TeleporterMessageInput({
            destinationBlockchainID: 0x9f3be606497285d0ffbb5ac9ba24aa60346a9b1812479ed66cb329f394a4b1c7, // ID de Dispatch
            destinationAddress: direccionDestino,
            feeInfo: TeleporterFeeInfo({
                feeTokenAddress: address(0), 
                amount: 0
            }), // Sin comisión
            requiredGasLimit: 100000, // Gas estimado para procesar
            allowedRelayerAddresses: new address[](0), // Cualquiera puede retransmitir
            message: abi.encode(mensaje) // Convierte el string a bytes
        });

        // Llama a Teleporter para enviar el mensaje
        bytes32 messageID = mensajeroTeleporter.sendCrossChainMessage(mensajeTeleporter);
        
        // Emite evento para tracking
        emit MensajeEnviado(
            mensajeTeleporter.destinationBlockchainID,
            direccionDestino,
            mensaje,
            messageID
        );
    }
    

    
}



/**
 * @title Contrato Receptor en la cadena destino (Dispatch)
 * @dev Este contrato recibe los mensajes enviados por Teleporter.
 */
contract ReceptorEnDispatch is ITeleporterReceiver {
    // Interfaz del Messenger de Teleporter
    ITeleporterMessenger public immutable mensajeroTeleporter;

    // Último mensaje recibido
    string public ultimoMensaje;
    
    // Información del último remitente
    address public ultimoRemitente;
    bytes32 public ultimoOrigenChainID;
    
    // Evento que se emite cuando se recibe un mensaje
    event MensajeRecibido(
        bytes32 indexed origenChainID,
        address indexed direccionRemitente,
        string mensaje
    );

    constructor() {
        mensajeroTeleporter = ITeleporterMessenger(
            0x253b2784c75e510dD0fF1da844684a1aC0aa5fcf
        );
    }

    /**
     * @notice Recibe mensajes enviados desde otra cadena
     * @param origenChainID ID de la blockchain origen
     * @param direccionRemitente Dirección del contrato emisor
     * @param mensaje Mensaje enviado en formato bytes
     */
    function receiveTeleporterMessage(
        bytes32 origenChainID,
        address direccionRemitente,
        bytes calldata mensaje
    ) external override {
        // Solo Teleporter puede entregar mensajes
        require(
            msg.sender == address(mensajeroTeleporter),
            "Receptor: Solo Teleporter puede llamar esta funcion"
        );

        // Decodifica el mensaje de bytes a string y lo guarda
        string memory mensajeDecodificado = abi.decode(mensaje, (string));
        
        // Actualiza el estado
        ultimoMensaje = mensajeDecodificado;
        ultimoRemitente = direccionRemitente;
        ultimoOrigenChainID = origenChainID;
        
        // Emite evento
        emit MensajeRecibido(origenChainID, direccionRemitente, mensajeDecodificado);
    }
    
    /**
     * @notice Función para leer el último mensaje (getter adicional)
     * @return mensaje El último mensaje recibido
     * @return remitente Dirección del último remitente
     * @return chainID ID de la cadena origen del último mensaje
     */
    function obtenerUltimoMensaje() external view returns (
        string memory mensaje,
        address remitente,
        bytes32 chainID
    ) {
        return (ultimoMensaje, ultimoRemitente, ultimoOrigenChainID);
    }
}