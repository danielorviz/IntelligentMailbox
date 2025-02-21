#include <SPI.h>
#include <MFRC522.h>

const int RST_PIN = 45;  //Pin 45 para el reset del RC522
const int SS_PIN = 53;

MFRC522 mfrc522(SS_PIN, RST_PIN);  //Creamos el objeto para el RC522

void setupRFID() {
  SPI.begin();         //Iniciamos el Bus SPI
  mfrc522.PCD_Init();  // Iniciamos  el MFRC522
}

String escanearRFID() {
  //Seleccionamos una tarjeta
  String codigoTarjeta;

  // Enviamos serialemente su UID
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    //s+= mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ";
    codigoTarjeta += String(mfrc522.uid.uidByte[i], HEX);
  }
  // Terminamos la lectura de la tarjeta  actual
  mfrc522.PICC_HaltA();
  codigoTarjeta.toUpperCase();
  return codigoTarjeta;
}

void checkPackageToScan(){
  // Revisamos si hay nuevas tarjetas  presentes
   if ( mfrc522.PICC_IsNewCardPresent()){  
      if ( mfrc522.PICC_ReadCardSerial()){
        String codigo = escanearRFID();
        Serial.println(codigo);
        checkPacakageCode(codigo);
        delay(500);
      }
   }
}
void checkPacakageCode(String codigo){
    if(PERMANENT_RFID_KEY == codigo){
      actionAbrirPuerta=true;
      Serial3.println("NOTIF_PACKAGE_PERM");
      return;
    }
    Serial3.println("PACKAGE_" + codigo);
   }