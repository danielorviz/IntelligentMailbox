//
extern int PUERTA_ABIERTA = 0;

//ACTIONS
extern bool actionAbrirPuerta = false;

void setup() {
  Serial.begin(115200);  // Comunicación con la PC para depuración
  Serial3.begin(9600);   // Comunicación con el ESP8266

  setupTeclado();
  setupPuerta();

  Serial.println("ATmega2560 listo para comunicarse con ESP8266.");
}



void loop() {
  readSerial();
  controlarTeclado();
}
