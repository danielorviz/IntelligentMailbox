#ifndef AUTHORIZEDKEY_H
#define AUTHORIZEDKEY_H
#include <ArduinoJson.h>

class AuthorizedKey {

private:
  String id;
  String name;
  String value;
  unsigned long initDate;
  unsigned long finishDate;
  bool permanent;

public:

  //AuthorizedKey (AuthorizedKey*& key);
  AuthorizedKey();

  AuthorizedKey(JsonObject& json);

  String getId();

  String getName();

  String getValue();

  unsigned long getInitDate();

  unsigned long getFinishDate();

  bool isPermanent();

  bool checkDateInRange(unsigned long date);

  void setName(const String& newName);

  void setValue(const String& newValue);

  void setInitDate(unsigned long newInitDate);

  void setFinishDate(unsigned long newFinishDate);

  void setPermanent(bool newPermanent);
};

AuthorizedKey::AuthorizedKey() {}
AuthorizedKey::AuthorizedKey(JsonObject& json) {
  (id) = json["id"].as<String>();
  (name) = json["name"].as<String>();
  (value) = json["value"].as<String>();
  (value).trim();
  (initDate) = json["initDate"].as<unsigned long>();
  (permanent) = json["permanent"].as<bool>();
  (finishDate) = json["finishDate"].as<unsigned long>();
}

String AuthorizedKey::getId() {
  return (id);
}

String AuthorizedKey::getName() {
  return (name);
}

String AuthorizedKey::getValue() {
  return (value);
}

unsigned long AuthorizedKey::getInitDate() {
  return (initDate);
}

unsigned long AuthorizedKey::getFinishDate() {
  return (finishDate);
}
void AuthorizedKey::setName(const String& newName) {
  name = newName;
}

void AuthorizedKey::setValue(const String& newValue) {
  value = newValue;
  value.trim();  // Ensure no trailing spaces
}

void AuthorizedKey::setInitDate(unsigned long newInitDate) {
  initDate = newInitDate;
}

void AuthorizedKey::setFinishDate(unsigned long newFinishDate) {
  finishDate = newFinishDate;
}

void AuthorizedKey::setPermanent(bool newPermanent) {
  permanent = newPermanent;
}

bool AuthorizedKey::isPermanent() {
  return (permanent);
}

bool AuthorizedKey::checkDateInRange(unsigned long date) {
  if (date >= initDate && date <= finishDate) {
    return true;
  }
  return false;
}

#endif