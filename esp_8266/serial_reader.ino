const int BUFFER_SIZE = 512;     // Tamaño del buffer
char serialBuffer[BUFFER_SIZE];  // Buffer para almacenar datos
int bufferIndex = 0;
void readSerial() {
  while (Serial.available()) {
    char incomingChar = Serial.read();  // Leer un carácter de Serial3
    //Serial.println(incomingChar);
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
  if (!conectado) {
    if (instructions.startsWith("USER_")) {
      String user = instructions.substring(5);
      user.trim();
      fireuser = user;
    }
    if (instructions.startsWith("PASS_")) {
      String pass = instructions.substring(5);
      pass.trim();
      firepass = pass;
    }
  } else {
    Serial.print(F("Validando instruccion: "));
    Serial.println(instructions);
    if (instructions.startsWith("DOOR_OPENED")) {
      updateDoorStatus(1);
    }
    else if(instructions.startsWith("DOOR_CLOSED")){
      updateDoorStatus(0);
    }
    else if (instructions.startsWith("DOOR_")) {
      String key = instructions.substring(5);
      key.trim();
      int validKeyIndex = checkKeyboardAccess(key);
      if (validKeyIndex >= 0) {
        Serial.println(F("DOOR_OK"));
        sendNotification(NOTIFICACION_APERTURA_CORRECTA, F("Puerta abierta con la clave "), TYPE_KEY, getAuthKeyId(validKeyIndex));
      } else {
        Serial.println(F("DOOR_KO"));
        sendNotificationDoorOpenKO(TYPE_KEY);
      }
    } else if (instructions.startsWith("NOTIF_")) {
      String notification = instructions.substring(6);
      notification.trim();
      if (notification == "OPENKO") {
        sendNotificationDoorOpenKO(TYPE_KEY);
      } else if (notification == "PACKAGE_PERM") {
        sendNotification(NOTIFICACION_APERTURA_CORRECTA, F("Puerta abierta con su llave de acceso"), TYPE_PACKAGE);
      } else if (notification == "LETTER") {
        sendNotification(NOTIFICACION_CARTA_RECIBIDA, F("Ha recibido un nuevo correo"), TYPE_LETTER);
      } else if (notification == "FULL") {
        sendNotification(NOTIFICACION_BUZON_LLENO, F("Es posible que el buzón esté lleno o se haya atascado un correo"), TYPE_MAILBOX);
      }
    } else if (instructions.startsWith("PACKAGE_")) {
      String package = instructions.substring(8);
      package.trim();
      int validPackageIndex = checkPackageAccess(package);
      if (validPackageIndex >= 0) {
        Serial.println(F("DOOR_OK"));
        if(getPackageIsKey(validPackageIndex)){
          sendNotification(NOTIFICACION_ACCESO_LLAVE_NFC, F("Puerta abierta con llave NFC"), TYPE_PACKAGE, getPackageKeyId(validPackageIndex));
        }else{
          sendNotification(NOTIFICACION_PAQUETE_RECIBIDO, F("Puerta abierta con el paquete "), TYPE_PACKAGE, getPackageKeyId(validPackageIndex));
        }
      } else {
        Serial.println(F("DOOR_KO"));
        sendNotificationDoorOpenKO(TYPE_PACKAGE);
      }
    }
  }
}
