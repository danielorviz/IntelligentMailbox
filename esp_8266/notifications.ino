#include "Notification.h"




void enviarNotificacion(String titulo,String mensaje){
  unsigned long currentTime = timeClient.getEpochTime();
  int intentos = 5;
  Serial.println("Enviando notificacion");
  Notification notificacion(ARDUINO_ID,titulo,mensaje,currentTime);
  String jsonMensaje = notificacion.toJsonObject();
  String result = "";
  delay(1000);
  while (result == "" && intentos >0) {
    result = Database.push<object_t>(aClientGeneral, NOTIFICATION_PATH , object_t(jsonMensaje.c_str()));
    delay(100);
    intentos--;

  }
  //Serial.println(notificacion.toJsonObject().get<String>(fid));
}