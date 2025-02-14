#include <Servo.h>

// PINES

int colision = A0;

// servo
Servo servo1;

void setupPuerta(){
  servo1.attach(33);
  servo1.write(50);
}
void abrirPuerta() {
  if (actionAbrirPuerta) {
    Serial.println("AUTORIZADO");
    PUERTA_ABIERTA = 1;
    servo1.write(0);
    emitSound(1000,1000);
    actionAbrirPuerta = false;
  } 
}
void comprobarPuerta(){
  if (PUERTA_ABIERTA) {
    delay(300);
    int colisionado = analogRead(colision);
    //Serial.println(colisionado);
    if (colisionado < 500) {
      cerrarPuerta();
      resetKeypad();
    }
    delay(50);
    if (!PUERTA_ABIERTA && !isSensorPuertaColisionado()) {
      abrirPuerta();
    }
  }
}
void cerrarPuerta() {
  PUERTA_ABIERTA = 0;
  servo1.write(50);
}

int isSensorPuertaColisionado() {
  int colisionado = analogRead(colision);
  if (colisionado < 500) {
    return 1;
  }
  return 0;
}