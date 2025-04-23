#include "conf.h";

extern int PUERTA_ABIERTA = 0;

//ACTIONS
extern bool actionAbrirPuerta = false;

void setup() {
  Serial.begin(115200);  // Comunicación con la PC para depuración
  Serial3.begin(2400);   // Comunicación con el ESP8266

  setupRFID();
  setupTeclado();
  setupPuerta();

  Serial.println("ATmega2560 listo para comunicarse con ESP8266.");
  //clearFirebaseUser();
  //clearFirebasePassword();

}

void sendNotification(const char* notification) {
  Serial.println("Enviando notificacion");
  
  const char* topic = concatenateWithPrefix("NOTIF_", notification);
  Serial.println(topic);

  Serial3.println(topic);
}

char* concatenateWithPrefix(const char* prefix, const char* value) {
  static char buffer[128]; // Tamaño máximo para el resultado, ajusta según tus necesidades
  size_t prefixLength = strlen(prefix);
  size_t valueLength = strlen(value);

  if (prefixLength + valueLength + 1 >= sizeof(buffer)) {
    Serial.println("Error: El resultado excede el tamaño del buffer.");
    return nullptr;
  }

  snprintf(buffer, sizeof(buffer), "%s%s", prefix, value);

  return buffer;
}

void loop() {
  readSerial();

  comprobarCartaRecibida();

  controlarTeclado();


  checkPackageToScan();

  checkOpenDoor();

  checkCloseDoor();
}
