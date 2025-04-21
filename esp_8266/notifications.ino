#include "Notification.h"


const bool notificationsActive= true;

void sendNotification(String titulo,String mensaje, int type){
  sendNotification(titulo,mensaje,type,"");
}

void sendNotification(String titulo,String mensaje, int type, String typeInfo){
  if(!notificationsActive){return;}

  unsigned long currentTime = timeClient.getEpochTime();
  int intentos = 5;
  Serial.println(F("Enviando notificacion"));
  Notification notificacion(ARDUINO_ID,titulo,mensaje,currentTime,type, typeInfo);
  String jsonMensaje = notificacion.toJsonObject();
  String result = "";
  delay(200);
  while (result == "" && intentos >0) {
    result = Database.push<object_t>(aClientGeneral, NOTIFICATION_PATH + ARDUINO_ID + "/" , object_t(jsonMensaje.c_str()));
    delay(1000);
    intentos--;

  }
}

void sendNotificationDoorOpenKO(){
  sendNotification(NOTIFICACION_APERTURA_INCORRECTA, F("Se ha intentado abrir la puerta"),TYPE_KEY, "");
}