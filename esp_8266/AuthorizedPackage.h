#ifndef AUTHORIZEDPACKAGE_H
#define AUTHORIZEDPACKAGE_H
#include <ArduinoJson.h>

class AuthorizedPackage {

private:
  String id_;
  String name_;
  String value_;
  unsigned long initDate_;
  unsigned long finishDate_;
  bool permanent_;

public:

  AuthorizedPackage();

  AuthorizedPackage(String& idSt, JsonObject& json);

  String getId();

  String getName();

  String getValue();

  unsigned long getInitDate();

  unsigned long getFinishDate();

  bool isPermanent();

  bool checkDateInRange(unsigned long date);

  // Setters
  void setId(const String& id);
  void setName(const String& name);
  void setValue(const String& value);
  void setInitDate(unsigned long initDate);
  void setFinishDate(unsigned long finishDate);
  void setPermanent(bool permanent);
};

AuthorizedPackage::AuthorizedPackage() {}
AuthorizedPackage::AuthorizedPackage(String& idSt, JsonObject& json) {
  id_ = idSt;
  name_ = json["name"].as<String>();
  value_ = json["value"].as<String>();
  initDate_ = json["initDate"].as<unsigned long>();
  permanent_ = json["permanent"].as<bool>();
  finishDate_ = json["finishDate"].as<unsigned long>();
}

String AuthorizedPackage::getId() {
  return (id_);
}

String AuthorizedPackage::getName() {
  return (name_);
}

String AuthorizedPackage::getValue() {
  return (value_);
}


unsigned long AuthorizedPackage::getInitDate() {
  return (initDate_);
}

unsigned long AuthorizedPackage::getFinishDate() {
  return (finishDate_);
}
bool AuthorizedPackage::isPermanent() {
  return (permanent_);
}

void AuthorizedPackage::setName(const String& name) {
  name_ = name;
}

void AuthorizedPackage::setValue(const String& value) {
  value_ = value;
}

void AuthorizedPackage::setInitDate(unsigned long initDate) {
  initDate_ = initDate;
}

void AuthorizedPackage::setFinishDate(unsigned long finishDate) {
  finishDate_ = finishDate;
}

void AuthorizedPackage::setPermanent(bool permanent) {
  permanent_ = permanent;
}

bool AuthorizedPackage::checkDateInRange(unsigned long date) {
  if (date >= initDate_ && date <= finishDate_) {
    return true;
  }
  return false;
}
#endif