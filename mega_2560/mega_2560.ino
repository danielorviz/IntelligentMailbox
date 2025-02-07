#include <Keypad.h>
#include <Servo.h>
#include "AuthorizedKey.h"
#include "Notification.h"
#include "Constantes.h"


Keypad teclado = Keypad(makeKeymap(teclas), pfilas, pcolumnas, nfilas, ncolumnas);

const int BUFFER_SIZE = 1024;    // Tamaño del buffer
char serialBuffer[BUFFER_SIZE];  // Buffer para almacenar datos
int bufferIndex = 0;

int contador = 1;

// BUZZER
int buzzer = 32;

//VARIABLES TECLADO
int PUERTA_ABIERTA = 0;
int TECLADO_START_COUNT = 0;
unsigned long TECLADO_START_MILLIS = 0;
int TECLADO_MAX_MILLIS = 3000;
String keypadKey = "";

//ACTIONS
bool actionAbrirPuerta= false;

void setup() {
  Serial.begin(115200);  // Comunicación con la PC para depuración
  Serial3.begin(9600);   // Comunicación con el ESP8266

  Serial.println("ATmega2560 listo para comunicarse con ESP8266.");
}
void abrirPuerta() {
  if(actionAbrirPuerta){
    Serial.println("AUTORIZADO");
    PUERTA_ABIERTA = 1;
    //servo1.write(0);
    tone(buzzer,1000);
    delay(1000);
    noTone(buzzer);
    actionAbrirPuerta = false;
  }
}
void cerrarPuerta() {
  PUERTA_ABIERTA = 0;
  //servo1.write(50);
}

void resetKeypad() {
  keypadKey = "";
  TECLADO_START_COUNT = 0;
}
void processMessage(char* message) {
  String dataFromESP = String(message);  // Convierte el buffer a String para manipularlo fácilmente

  if (dataFromESP.startsWith("DOOR_")) {
    Serial.println("ABRIR desde ESP8266: " + dataFromESP);
    String action = dataFromESP.substring(5);
    action.trim();
    actionAbrirPuerta = (action == "OK");
    
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
      serialBuffer[bufferIndex] = '\0';     // Termina la cadena
      processMessage(serialBuffer);  // Procesa el mensaje
      bufferIndex = 0;                      // Resetea el índice del buffer


    } else {
      // Agrega el carácter al buffer si no está lleno
      if (bufferIndex < BUFFER_SIZE - 1) {
        serialBuffer[bufferIndex++] = incomingChar;
      } else {
        // Si el buffer se llena, resetea para evitar desbordamiento
        Serial.println("ERROR: Buffer overflow");
        bufferIndex = 0;
      }
    }
  }
}
void controlarTeclado() {
  char tecla = teclado.getKey();
  if (tecla != '\0') {
    delay(100);
    Serial.println("tecla pulsada: " + String(tecla));

    if (tecla != '#') {
      
      TECLADO_START_COUNT = 1;
      TECLADO_START_MILLIS = millis();
      if (!PUERTA_ABIERTA) {
        keySound();
        Serial.println("pulsando");
      }
      keypadKey += tecla;
    } else if (tecla == '#' && !PUERTA_ABIERTA) {
      Serial3.println("DOOR_" + keypadKey);
  
      resetKeypad();
    }
  }
  abrirPuerta();
  if (TECLADO_START_COUNT && (millis() - TECLADO_START_MILLIS) >= TECLADO_MAX_MILLIS) {
    Serial.println("Teclado reseteado");
    resetKeypad();
    keySoundWrong();
    Serial.println("wrong");
  }

  if (PUERTA_ABIERTA) {
    delay(300);
    //int colisionado = analogRead(colision);
    //Serial.println(colisionado);
    //if (colisionado < 500) {
    cerrarPuerta();
    resetKeypad();
  }
}
void keySound(){
    tone(buzzer,1000);
    delay(300);
    noTone(buzzer);
}

void keySoundWrong(){
    tone(buzzer,1000);
    delay(300);
    noTone(buzzer);
    delay(100);
    tone(buzzer,1000);
    delay(300);
    noTone(buzzer);
    delay(100);
    tone(buzzer,1000);
    delay(300);
    noTone(buzzer);
}
void loop() {
  readSerial();
  controlarTeclado();
}
