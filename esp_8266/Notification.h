#ifndef NOTIFICATION_H
#define NOTIFICATION_H
#include <ArduinoJson.h>

class Notification {

private:
  const String FID_COL_NAME = "fid";
  const String MAILBOX_COL_NAME = "mailbox";
  const String TITULO_COL_NAME = "titulo";
  const String MENSAJE_COL_NAME = "mensaje";
  const String TIME_COL_NAME = "time";

  String fid_;
  String mailbox_;
  String titulo_;
  String mensaje_;
  unsigned long time_;

public:
  Notification();
  Notification(String& mailbox, String& titulo, String& mensaje, unsigned long& actualTime);
  Notification(JsonObject& json);

  String getFid();
  String getMailbox();
  String getTitulo();
  String getMensaje();
  unsigned long getTime();

  void setFid(String fid);
  void setMailbox(String mailbox);
  void setTitulo(String titulo);
  void setMensaje(String mensaje);
  void setTime(unsigned long actualTime);

  String toJsonObject();
};
Notification::Notification() {
}
Notification::Notification(String& mailbox, String& titulo, String& mensaje, unsigned long& actualTime) {
  fid_ = "fid";
  mailbox_ = mailbox;
  titulo_ = titulo;
  mensaje_ = mensaje;
  time_ = actualTime;
}
Notification::Notification(JsonObject& json) {
  fid_ = json[FID_COL_NAME].as<String>();
  mailbox_ = json[MAILBOX_COL_NAME].as<String>();
  titulo_ = json[TITULO_COL_NAME].as<String>();
  mensaje_ = json[MENSAJE_COL_NAME].as<String>();
  time_ = json[TIME_COL_NAME].as<unsigned long>();
}

String Notification::toJsonObject() {
   String jsonString = "{\"" + String(FID_COL_NAME) + "\":\"" + fid_ + "\","
                        "\"" + String(MAILBOX_COL_NAME) + "\":\"" + mailbox_ + "\","
                        "\"" + String(TITULO_COL_NAME) + "\":\"" + titulo_ + "\","
                        "\"" + String(MENSAJE_COL_NAME) + "\":\"" + mensaje_ + "\","
                        "\"" + String(TIME_COL_NAME) + "\":" + String(time_) + "}";

    return jsonString;
}

String Notification::getFid() {
  return fid_;
}
String Notification::getMailbox() {
  return mailbox_;
}
String Notification::getTitulo() {
  return titulo_;
}
String Notification::getMensaje() {
  return mensaje_;
}

unsigned long Notification::getTime() {
  return time_;
}

void Notification::setFid(String fid) {
  fid_ = fid;
}
void Notification::setMailbox(String mailbox) {
  mailbox_ = mailbox;
}
void Notification::setTitulo(String titulo) {
  titulo_ = titulo;
}
void Notification::setMensaje(String mensaje) {
  mensaje_ = mensaje;
}

void Notification::setTime(unsigned long actualTime) {
  time_ = actualTime;
}
#endif