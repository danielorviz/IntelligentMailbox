#include <Servo.h>

// PINES

int colision = A0;

// servo
Servo servo1;

void setupPuerta(){
  servo1.attach(33);
  servo1.write(50);
}
void checkOpenDoor() {
  if (actionAbrirPuerta) {
    Serial.println("AUTORIZADO");
    PUERTA_ABIERTA = 1;
    servo1.write(0);
    emitSound(1000,1000);
    actionAbrirPuerta = false;
  } 
}
void checkCloseDoor(){
  if (PUERTA_ABIERTA) {
    delay(300);
    int colisionado = analogRead(colision);
    //Serial.println(colisionado);
    if (colisionado < 100) {
      cerrarPuerta();
      resetKeypad();
    }
    delay(50);
    if (!PUERTA_ABIERTA && !isSensorPuertaColisionado()) {
      checkOpenDoor();
    }
  }
}
void cerrarPuerta() {
  PUERTA_ABIERTA = 0;
  servo1.write(50);
  Serial3.println("DOOR_CLOSED");
}

int isSensorPuertaColisionado() {
  int colisionado = analogRead(colision);
  if (colisionado < 500) {
    return 1;
  }
  return 0;
}