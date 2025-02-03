#include <Keypad.h>
#include <Servo.h>
#include "AuthorizedKey.h"
#include "Notification.h"
#include "Constantes.h"


Keypad teclado = Keypad( makeKeymap(teclas), pfilas, pcolumnas, nfilas, ncolumnas );

const int BUFFER_SIZE = 128; // Tamaño del buffer
char serialBuffer[BUFFER_SIZE]; // Buffer para almacenar datos
int bufferIndex = 0; 

int contador =1;
void setup() {
  Serial.begin(115200);    // Comunicación con la PC para depuración
  Serial3.begin(9600);     // Comunicación con el ESP8266

  Serial.println("ATmega2560 listo para comunicarse con ESP8266.");
}
void processMessage(char* message) {
  String dataFromESP = String(message); // Convierte el buffer a String para manipularlo fácilmente

  if (dataFromESP.startsWith("TO_")) {
    Serial.println("Recibido desde ESP8266: " + dataFromESP);

    String enviar = "mensaje" + String(contador);
    Serial.print("Enviado a ESP8266: ");
    Serial.println(contador);

    Serial3.println(contador); // Envía el mensaje al ESP8266
    contador++;
  } else {
    // Si no comienza con "TO_", es un mensaje de debug
    Serial.println("DEBUG: " + dataFromESP);
  }
}

void readSerial(){
   while (Serial3.available()) {
    char incomingChar = Serial3.read(); // Leer un carácter de Serial3

    // Si el carácter es un salto de línea, procesamos el mensaje completo
    if (incomingChar == '\n') {
      serialBuffer[bufferIndex] = '\0'; // Termina la cadena
      processMessage(serialBuffer);    // Procesa el mensaje
      bufferIndex = 0;                 // Resetea el índice del buffer
    } 
    else {
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

void loop() {
    //readSerial();
    //delay(1000); 
    
    char tecla = teclado.getKey();
    if (tecla != '\0'){
        Serial.println("tecla pulsada: "+String(tecla));
    }

  }


