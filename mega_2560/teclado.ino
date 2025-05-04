#include <Keypad.h>

const byte nfilas = 4;
const byte ncolumnas = 4;
char teclas[nfilas][ncolumnas] = {
 {'1','4','7','*'},
 {'2','5','8','0'},
 {'3','6','9','#'},
 {'A','B','C','D'}
};
byte pcolumnas[nfilas] = {22,23,24,25};  // Filas
byte pfilas[ncolumnas] = {26,27,28,29};

const char* notification_open_ko ="OPENKO";

//VARIABLES TECLADO
int TECLADO_START_COUNT = 0;
unsigned long TECLADO_START_MILLIS = 0;
int TECLADO_MAX_MILLIS = 3000;

Keypad teclado = Keypad(makeKeymap(teclas), pfilas, pcolumnas, nfilas, ncolumnas);
String keypadKey;



void setupTeclado(){
    String keypadKey = "";
}

void resetKeypad() {
  keypadKey = "";
  TECLADO_START_COUNT = 0;
}

void controlarTeclado() {
  char tecla = teclado.getKey();
  if (!PUERTA_ABIERTA && tecla != '\0') {
    delay(100);
    Serial.println("tecla pulsada: " + String(tecla));

    if (tecla != '#') {

      TECLADO_START_COUNT = 1;
      TECLADO_START_MILLIS = millis();
      if (!PUERTA_ABIERTA) {
        keySound();
        Serial.println("pulsando");
      }
      Serial.print("Puerta: ");
      Serial.println(PUERTA_ABIERTA);
      keypadKey += tecla;
    } else if (tecla == '#' && !PUERTA_ABIERTA) {
      emitSound(1000, 400);
      Serial.print("Enviando: ");
      String instruction = "DOOR_" + keypadKey;
      Serial.println(instruction);
      Serial3.println(instruction);
      delay(100);

      resetKeypad();
    }
  }
  
  if (TECLADO_START_COUNT && (millis() - TECLADO_START_MILLIS) >= TECLADO_MAX_MILLIS) {
    Serial.println("Teclado reseteado");
    resetKeypad();
    keySoundWrong();
    Serial.println("wrong");
    sendNotification(notification_open_ko);
  }
  
}

