const int BUFFER_SIZE = 1024;    // Tamaño del buffer
char serialBuffer[BUFFER_SIZE];  // Buffer para almacenar datos
int bufferIndex = 0;


void processMessage(char* message) {
  String dataFromESP = String(message);  // Convierte el buffer a String para manipularlo fácilmente

  if (dataFromESP.startsWith("DOOR_")) {
    Serial.println("ABRIR desde ESP8266: " + dataFromESP);
    String action = dataFromESP.substring(5);
    action.trim();
    actionAbrirPuerta = (action == "OK");

    if(!actionAbrirPuerta){
      keySoundWrong();
    }

  } else {
    // Si no comienza con "TO_", es un mensaje de debug
    Serial.println("DEBUG: " + dataFromESP);
  }
  return "";
}

void readSerial() {
  while (Serial3.available()) {
    char incomingChar = Serial3.read();  // Leer un carácter de Serial3

    // Si el carácter es un salto de línea, procesamos el mensaje completo
    if (incomingChar == '\n') {
      serialBuffer[bufferIndex] = '\0';  // Termina la cadena
      processMessage(serialBuffer);      // Procesa el mensaje
      memset(serialBuffer, '\0', BUFFER_SIZE);
      bufferIndex = 0;                   // Resetea el índice del buffer


    } else {
      // Agrega el carácter al buffer si no está lleno
      if (bufferIndex < BUFFER_SIZE - 1) {
        serialBuffer[bufferIndex++] = incomingChar;
      } else {
        // Si el buffer se llena, resetea para evitar desbordamiento
        Serial.println("ERROR: Buffer overflow");
        memset(serialBuffer, '\0', BUFFER_SIZE);
        bufferIndex = 0;
      }
    }
  }
}