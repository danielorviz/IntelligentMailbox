const int BUFFER_SIZE = 512;     // Tamaño del buffer
char serialBuffer[BUFFER_SIZE];  // Buffer para almacenar datos
int bufferIndex = 0;
void readSerial() {
  while (Serial.available()) {
    char incomingChar = Serial.read();  // Leer un carácter de Serial3

    // Si el carácter es un salto de línea, procesamos el mensaje completo
    if (incomingChar == '\n') {
      serialBuffer[bufferIndex] = '\0';  // Termina la cadena
      processInstruction(serialBuffer);  // Procesa el mensaje
      memset(serialBuffer, '\0', BUFFER_SIZE);
      bufferIndex = 0;  // Resetea el índice del buffer


    } else {
      // Agrega el carácter al buffer si no está lleno
      if (bufferIndex < BUFFER_SIZE - 1) {
        serialBuffer[bufferIndex++] = incomingChar;
      } else {
        // Si el buffer se llena, resetea para evitar desbordamiento
        memset(serialBuffer, '\0', BUFFER_SIZE);
        bufferIndex = 0;
      }
    }
  }
}

void processInstruction(char* message) {
  String instructions = String(message);
  Serial.print("Validando instruccion: ");
  Serial.println(instructions);
  if (instructions.startsWith("DOOR_")) {
    String key = instructions.substring(5);
    key.trim();
    int validKeyIndex = checkKeyboardAccess(key);
    if (validKeyIndex >= 0) {
      Serial.println("DOOR_OK");
      sendNotification(NOTIFICACION_APERTURA_CORRECTA, "Puerta abierta con la clave: " + getAuthKeyName(validKeyIndex));
    } else {
      Serial.println("DOOR_KO");
      sendNotificationDoorOpenKO();
    }
  } else if (instructions.startsWith("NOTIF_")) {
    String notification = instructions.substring(6);
    notification.trim();
    if (notification == "OPENKO") {
      sendNotificationDoorOpenKO();
    } else if (notification == "PACKAGE_PERM") {
      sendNotification(NOTIFICACION_APERTURA_CORRECTA, "Puerta abierta con su llave de acceso");
    } else if (notification == "LETTER") {
      sendNotification(NOTIFICACION_CARTA_RECIBIDA, "Ha recibido un nuevo correo");
    } else if (notification == "FULL") {
      sendNotification(NOTIFICACION_BUZON_LLENO, "Es posible que el buzón esté lleno o se haya atascado un correo");
    }
  } else if (instructions.startsWith("PACKAGE_")) {
    String package = instructions.substring(8);
    package.trim();
    int validPackageIndex = checkPackageAccess(package);
    if (validPackageIndex >= 0) {
      Serial.println("DOOR_OK");
      sendNotification(NOTIFICACION_APERTURA_CORRECTA, "Puerta abierta con el paquete: " + getPackageKeyName(validPackageIndex));
    } else {
      Serial.println("DOOR_KO");
      sendNotificationDoorOpenKO();
    }
  }
}
